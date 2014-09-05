//
//  KGLocationManager.m
//  KelpGang
//
//  Created by Andy on 14-5-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLocationManager.h"
#import "KGLocationObject.h"


@interface KGLocationManager()

@property (nonatomic, copy)LocationBlock locationBlock;
@property (nonatomic, strong)KGLocationObject *location;
@property (nonatomic, assign) BOOL called;

@end

@implementation KGLocationManager
+ (KGLocationManager *)shareLocation {
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init];
    });
    return _sharedObject;
}

-(void)startLocation {
    if (_mapView) {
        _mapView = nil;
    }

    _mapView = [[MKMapView alloc] init];
    _mapView.delegate = self;
    _mapView.showsUserLocation = YES;
    self.called = NO;
}

-(void)stopLocation {
    _mapView.showsUserLocation = NO;
    _mapView = nil;
}

- (void)getAddress:(LocationBlock)locationBlock {
    self.locationBlock = locationBlock;
    [self startLocation];
}


#pragma MKMapViewDelegate

- (void)mapView:(MKMapView *)mapView didUpdateUserLocation:(MKUserLocation *)userLocation {
    CLLocation *newLocation = userLocation.location;
    self.coordinate = mapView.userLocation.location.coordinate;

    CLGeocoder *clGeoCoder = [[CLGeocoder alloc] init];
    CLGeocodeCompletionHandler handle = ^(NSArray *placemarks,NSError *error) {
        for (CLPlacemark * placeMark in placemarks) {
            self.location = [[KGLocationObject alloc] init];
            self.location.longitude = [NSNumber numberWithDouble:placeMark.location.coordinate.longitude];
            self.location.latitude = [NSNumber numberWithDouble: placeMark.location.coordinate.latitude];
            self.location.addressDictionary = placeMark.addressDictionary;
            [self stopLocation];
        }

        if (self.locationBlock && !self.called) {
            self.locationBlock(self.location);
            self.called = YES;
        }
    };
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self stopLocation];
    if (kCLErrorDenied == error.code || kCLErrorLocationUnknown == error.code) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"定位服务未开启" message:@"需要到手机设置开启定位服务完成此次操作" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
    }
}


@end
