//
//  ScanViewController.m
//  erpbarcode
//
//  Created by Barcode on 02/12/2018.
//  Copyright © 2018 ktds. All rights reserved.
//

#import <AVFoundation/AVFoundation.h>
#import "ScanViewController.h"

@interface ScanViewController () <AVCaptureMetadataOutputObjectsDelegate>
{
    AVCaptureSession *_session;
    AVCaptureDevice *_device;
    AVCaptureDeviceInput *_input;
    AVCaptureMetadataOutput *_output;
    AVCaptureVideoPreviewLayer *_prevLayer;
    
    UIView *_highlightView;
    UILabel *_label;
}

@property (strong, nonatomic) IBOutlet UIView *scanView;

@end

@implementation ScanViewController
@synthesize delegate;


- (void)viewDidLoad
{
    [super viewDidLoad];
    
    _highlightView = [[UIView alloc] init];
    _highlightView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin|UIViewAutoresizingFlexibleLeftMargin|UIViewAutoresizingFlexibleRightMargin|UIViewAutoresizingFlexibleBottomMargin;
    _highlightView.layer.borderColor = [UIColor greenColor].CGColor;
    _highlightView.layer.borderWidth = 3;
    [self.view addSubview:_highlightView];

    _label = [[UILabel alloc] init];
    _label.frame = CGRectMake(0, self.view.bounds.size.height - 80, self.view.bounds.size.width, 80);
    _label.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    _label.backgroundColor = [UIColor colorWithWhite:0.15 alpha:0.65];
    _label.textColor = [UIColor whiteColor];
    _label.textAlignment = NSTextAlignmentCenter;
    _label.text = @"";
    [self.view addSubview:_label];
    
    _session = [[AVCaptureSession alloc] init];
    _device = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    NSError *error = nil;
    
    _input = [AVCaptureDeviceInput deviceInputWithDevice:_device error:&error];
    if (_input) {
        [_session addInput:_input];
    } else {
        NSLog(@"Error: %@", error);
    }
    
    _output = [[AVCaptureMetadataOutput alloc] init];
    [_output setMetadataObjectsDelegate:self queue:dispatch_get_main_queue()];
    [_session addOutput:_output];
    
    _output.metadataObjectTypes = [_output availableMetadataObjectTypes];
    
    _prevLayer = [AVCaptureVideoPreviewLayer layerWithSession:_session];
    _prevLayer.frame = self.view.bounds;
    _prevLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:_prevLayer];
    
    [_session startRunning];
    
    [self.view bringSubviewToFront:_highlightView];
    [self.view bringSubviewToFront:_label];
}

- (void)captureOutput:(AVCaptureOutput *)captureOutput didOutputMetadataObjects:(NSArray *)metadataObjects fromConnection:(AVCaptureConnection *)connection
{
    CGRect highlightViewRect = CGRectZero;
    AVMetadataMachineReadableCodeObject *barcodeObject;
    NSString *detectionString = nil;
    //    NSArray *barCodeTypes = @[AVMetadataObjectTypeUPCECode, AVMetadataObjectTypeCode39Code, AVMetadataObjectTypeCode39Mod43Code,
    //            AVMetadataObjectTypeEAN13Code, AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode93Code, AVMetadataObjectTypeCode128Code,
    //            AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode, AVMetadataObjectTypeAztecCode];
    
    NSArray *barcodeTypes = @[AVMetadataObjectTypePDF417Code, AVMetadataObjectTypeQRCode];
    
    for (AVMetadataObject *metadata in metadataObjects) {
        for (NSString *type in barcodeTypes) {
            if ([metadata.type isEqualToString:type])
            {
                barcodeObject = (AVMetadataMachineReadableCodeObject *)[_prevLayer transformedMetadataObjectForMetadataObject:(AVMetadataMachineReadableCodeObject *)metadata];
                highlightViewRect = barcodeObject.bounds;
                detectionString = [(AVMetadataMachineReadableCodeObject *)metadata stringValue];
                break;
            }
        }
        
        if (detectionString != nil)
        {
//            _label.text = detectionString;
            [delegate setScanBarcode:detectionString withResult:true];
            [self.presentingViewController dismissViewControllerAnimated:YES completion:nil];
//            break;
        }
        else
            _label.text = @"";
    }
    
    _highlightView.frame = highlightViewRect;
}

@end
