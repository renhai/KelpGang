//
//  KGOrderObject.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGOrderObject : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderDesc;
@property (nonatomic, assign) NSInteger orderMoney;
@property (nonatomic, strong) NSString *orderImageUrl;
@property (nonatomic, assign) OrderStatus orderStatus;

@end
