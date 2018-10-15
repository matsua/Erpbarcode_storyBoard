//
//  ERPLocationManager.m
//  erpbarcode
//
//  Created by 박수임 on 14. 1. 3..
//  Copyright (c) 2014년 ktds. All rights reserved.
//

#import "ERPLocationManager.h"

@implementation ERPLocationManager

@synthesize currentLocation;

- (id)init
{
    self = [super init];
    
    if (self){
        self.locationManager = [[CLLocationManager alloc] init];
        self.locationManager.desiredAccuracy = kCLLocationAccuracyHundredMeters;
        self.locationManager.delegate = self;
        self.isStopUpdateLocation = NO;
    }
    
    return self;
}

+ (ERPLocationManager *)getInstance
{
    static ERPLocationManager *instance = nil;
    
    @synchronized(self)
    {
        if (!instance) {
            instance = [[self alloc] init];
        }
    }
    
    return instance;
}

// GPS위치를 찾고 -> 코어로케이션 매니저 전달 -> didUpdateLocations 매소드 콜
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations
{
    // 현재 찾은 위치값을 추출함(마지막찾은)
    CLLocation* location = [locations lastObject];
    
    [self.locationManager stopUpdatingLocation];
    
    self.isStopUpdateLocation = YES;
    
    currentLocation.latitude = location.coordinate.latitude;
    currentLocation.longitude = location.coordinate.longitude;
    
    float longitude=location.coordinate.longitude;
    float latitude=location.coordinate.latitude;
    
    self.locationDic = [NSDictionary dictionaryWithObjectsAndKeys:[NSNumber numberWithFloat:longitude],@"LONGTITUDE",[NSNumber numberWithFloat:latitude],@"LATITUDE",@"0",@"DIFF_TITUDE",nil];
}

// 문자로 전달된 주소정보를  GPS정보로 환산해 거리를 Km로 리턴한다.
- (double)getDiffDistanceWithAddress:(NSString*)input
{
    CLLocationCoordinate2D inputLocation = [self addressLocation:input];
    
    if (inputLocation.longitude <= 0 && inputLocation.latitude <= 0)
        return 0;
    
    // 현재 폰이 있는 위치과 입력받은 주소의 위치와의 거리 차를 계산(m로 받는다.)
    double distance = [self distanceP1:currentLocation andP2:inputLocation];
    
    // return distance in Km
    return distance / 1000;
}

// 주소로 입력된 정보를 GPS정보(CCLocationCoordinate2D)로 리턴한다.
- (CLLocationCoordinate2D)addressLocation:(NSString *)input {
	NSError *fileError = nil;
	NSStringEncoding encoding;
    double latitude = 0.0;
    double longitude = 0.0;
    
	NSString *urlString =
        [NSString stringWithFormat:@"http://maps.googleapis.com/maps/api/geocode/json?address=%@&sensor=true", [input stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *locationString = [NSString stringWithContentsOfURL:[NSURL URLWithString:urlString] usedEncoding:&encoding error:&fileError ];
    
    NSDictionary* responseDic = [locationString objectFromJSONString];
    
    NSArray* resultList = [responseDic objectForKey:@"results"];
    
    if (resultList != nil && resultList.count > 0){
        NSDictionary* locationDic = [[[resultList objectAtIndex:0] objectForKey:@"geometry"] objectForKey:@"location"];
        
        latitude = [[locationDic objectForKey:@"lat"] doubleValue];
        longitude = [[locationDic objectForKey:@"lng"] doubleValue];
    }
	
    CLLocationCoordinate2D location;
    location.latitude = latitude;
    location.longitude = longitude;
    
    return location;
}

// P1, P2의 거리를 m로 리턴해준다.
- (double) distanceP1:(CLLocationCoordinate2D)Position1 andP2:(CLLocationCoordinate2D)Postion2
{
    if ((Position1.latitude == Postion2.latitude) && (Position1.longitude == Postion2.longitude))
    {
        return 0;
    }
    
    double e10 = Position1.latitude * M_PI / 180;
    double e11 = Position1.longitude * M_PI / 180;
    double e12 = Postion2.latitude * M_PI / 180;
    double e13 = Postion2.longitude * M_PI / 180;
    
    /* 타원체 GRS80 */
    double c16 = 6356752.314140910;
    double c15 = 6378137.000000000;
    double c17 = 0.0033528107;
    
    double c18 = e13 - e11;
    double c20 = (1 - c17) * tan(e10);
    double c21 = atan(c20);
    double c22 = sin(c21);
    double c23 = cos(c21);
    double c24 = (1 - c17) * tan(e12);
    double c25 = atan(c24);
    double c26 = sin(c25);
    double c27 = cos(c25);
    
    double c29 = c18;
    double c31 = (c27 * sin(c29) * c27 * sin(c29)) + (c23 * c26 - c22 * c27 * cos(c29)) * (c23 * c26 - c22 * c27 * cos(c29));
    double c33 = (c22 * c26) + (c23 * c27 * cos(c29));
    double c35 = sqrt(c31) / c33;
    double c38 = 0;
    if (c31==0)
    {
        c38 = 0;
    }else{
        c38 = c23 * c27 * sin(c29) / sqrt(c31);
    }
    
    double c40 = 0;
    if ((cos(asin(c38)) * cos(asin(c38))) == 0)
    {
        c40 = 0;
    }else{
        c40 = c33 - 2 * c22 * c26 / (cos(asin(c38)) * cos(asin(c38)));
    }
    
    double c41 = cos(asin(c38)) * cos(asin(c38)) * (c15 * c15 - c16 * c16) / (c16 * c16);
    double c43 = 1 + c41 / 16384 * (4096 + c41 * (-768 + c41 * (320 - 175 * c41)));
    double c45 = c41 / 1024 * (256 + c41 * (-128 + c41 * (74 - 47 * c41)));
    double c47 = c45 * sqrt(c31) * (c40 + c45 / 4 * (c33 * (-1 + 2 * c40 * c40) - c45 / 6 * c40 * (-3 + 4 * c31) * (-3 + 4 * c40 * c40)));
    
    double c54 = c16 * c43 * (atan(c35) - c47);
    
    // return distance in meter
    return c54;
}

// 로케이션 매니져에게 위치를 찾아달라고 함
//- (void)getMyPosition
//{
//    if (![[Util udObjectForKey:BARCODE_SERVER_ID] isEqualToString:@"QA"])
//        return;
//    
//    self.isStopUpdateLocation = NO;
//    
//    [self.locationManager startUpdatingLocation];
//}

@end
