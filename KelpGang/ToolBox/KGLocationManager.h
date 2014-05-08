//
//  KGLocationManager.h
//  KelpGang
//
//  Created by Andy on 14-5-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MapKit/MapKit.h>

typedef void(^LocationBlock)(NSString *location);

@interface KGLocationManager : NSObject <MKMapViewDelegate>

@property (nonatomic, strong) MKMapView *mapView;
@property (nonatomic, assign) CLLocationCoordinate2D coordinate;


+ (KGLocationManager *)shareLocation;

- (void)getAddress:(LocationBlock)locationBlock;

@end
