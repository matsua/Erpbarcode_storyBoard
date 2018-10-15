//
//  AppDelegate.h
//  erpbarcode
//
//  Created by  Jung dae ho on 13. 7. 25..
//  Copyright (c) 2013년 ktds. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LoadingView.h"
#import "LoginViewController.h"
#import "KDCReader.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;
@property (strong,nonatomic) LoadingView* loadingView;
@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (nonatomic,assign) NSInteger loadingInterval;

+(id)sharedInstance;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;

- (BOOL)getKdcIsConnected;
- (uint8_t *)getKdcFirmwareVersion;
- (uint8_t *)getKdcSerialNumber;
- (uint8_t *)getKdcModelName;
- (uint8_t *)getKdcBluetoothMacAddress;
- (uint8_t *)getKdcBluetoothFirmwareVersion;
- (int)getKdcBatteryCapacity;


@end
