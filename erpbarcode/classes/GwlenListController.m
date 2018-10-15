//
//  GwlenListController.m
//  erpbarcode
//
//  Created by matsua on 17. 07. 26..
//  Copyright (c) 2017년 ktds. All rights reserved.
//

#import "GwlenListController.h"
#import "GridBoldColumn2Cell.h"

@interface GwlenListController ()
@property(nonatomic,strong) IBOutlet UITableView* _tableView;
@property(nonatomic,strong) IBOutlet UILabel* _totalCount;

@end

@implementation GwlenListController
@synthesize delegate;
@synthesize list;
@synthesize _tableView;
@synthesize _totalCount;


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [_tableView reloadData];
    
    _totalCount.text = [NSString stringWithFormat:@"  Total : %d 건 ",(int)[list count]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - UITableViewDelegate
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [list count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    GridBoldColumn2Cell *cell = (GridBoldColumn2Cell*)[tableView dequeueReusableCellWithIdentifier:@"GridBoldColumn2Cell"];
    if (!cell){
        NSArray *nib = [[NSBundle mainBundle] loadNibNamed:@"GridBoldColumn2Cell" owner:self options:nil];
        for (id object in nib)
        {
            if ([object isMemberOfClass:[GridBoldColumn2Cell class]])
            {
                cell = object;
                break;
            }
        }
    }
    
    NSDictionary* dic = [list objectAtIndex:indexPath.row];
    NSString* equnr = [dic objectForKey:@"EQUNR"];
    NSString* gwlen = [dic objectForKey:@"GWLEN_O"];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    cell.lblColumn1.text = equnr;
    cell.lblColumn2.text = gwlen;
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableViewArg heightForRowAtIndexPath:(NSIndexPath *)indexPath {
     return 44;
}

#pragma IGwlenRequest delegate
- (void)gwlenRequest:(BOOL)send{
    [delegate gwlenRequest:send];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark -  User Define Action
- (IBAction)close:(id)sender
{
    [self gwlenRequest:YES];
    [self.presentingViewController dismissViewControllerAnimated:NO completion:nil];
}

- (IBAction)cansel:(id)sender
{
    [self gwlenRequest:NO];
}

- (IBAction)send:(id)sender
{
    [self gwlenRequest:YES];
}



@end
