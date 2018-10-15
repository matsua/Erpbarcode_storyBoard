//
//  ERPLocationManager.h
//  erpbarcode
//
//  Created by 박수임 on 14. 1. 3..
//  Copyright (c) 2014년 ktds. All rights reserved.
//
// 코어 로케이션 프레임워크를 임포트
#import <CoreLocation/CoreLocation.h>

@interface ERPLocationManager : NSObject <CLLocationManagerDelegate>

@property (strong, nonatomic) CLLocationManager* locationManager;
@property (strong, nonatomic) NSDictionary* locationDic;
@property (assign, nonatomic) BOOL isStopUpdateLocation;
@property (assign, nonatomic) CLLocationCoordinate2D currentLocation;

+ (ERPLocationManager *)getInstance;
- (double)getDiffDistanceWithAddress:(NSString*)input;
- (double) distanceP1:(CLLocationCoordinate2D)Position1 andP2:(CLLocationCoordinate2D)Postion2;
- (CLLocationCoordinate2D)addressLocation:(NSString *)input;
//- (void)getMyPosition;

@end

