//
//  KGBuyerSummaryObject.h
//  KelpGang
//
//  Created by Andy on 14-5-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGBuyerSummaryObject : NSObject

@property (nonatomic, assign)NSInteger userId;
@property (nonatomic, strong)NSString *userName;
@property (nonatomic, strong)NSString *avatarUrl;
@property (nonatomic, assign)Gender gender;
@property (nonatomic, assign)NSInteger level;
@property (nonatomic, strong)NSString *country;
@property (nonatomic, strong)NSString *routeDuration;
@property (nonatomic, strong)NSString *fromCountry;
@property (nonatomic, strong)NSString *toCountry;
@property (nonatomic, strong)NSString *desc;

@end
