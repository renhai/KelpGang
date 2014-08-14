//
//  KGJourneyObject.h
//  KelpGang
//
//  Created by Andy on 14-8-14.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGJourneyObject : NSObject

@property (nonatomic, assign) NSInteger journeyId;
@property (nonatomic, strong) NSString *toCountry;
@property (nonatomic, assign) BOOL permanent;
@property (nonatomic, strong) NSString *fromCity;
@property (nonatomic, strong) NSDate *backDate;
@property (nonatomic, strong) NSDate *startDate;
@property (nonatomic, strong) NSString *desc;

@end
