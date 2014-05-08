//
//  KGLocationManager.m
//  KelpGang
//
//  Created by Andy on 14-5-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLocationManager.h"


@interface KGLocationManager()

@property (nonatomic, copy)LocationBlock locationBlock;
@property (nonatomic, strong)NSString *location;

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
            self.location = placeMark.name;
            [self stopLocation];
        }

        if (self.locationBlock) {
            self.locationBlock(self.location);
        }
    };
    [clGeoCoder reverseGeocodeLocation:newLocation completionHandler:handle];
}

- (void)mapView:(MKMapView *)mapView didFailToLocateUserWithError:(NSError *)error {
    [self stopLocation];
}


@end
