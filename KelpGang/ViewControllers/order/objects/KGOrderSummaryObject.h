//
//  KGOrderSummaryObject.h
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGOrderSummaryObject : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderDesc;
@property (nonatomic, assign) CGFloat orderMoney;
@property (nonatomic, strong) NSString *orderImageUrl;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) NSInteger userId;
@property (nonatomic, strong) NSString *userName;
@property (nonatomic, strong) NSString *userAvatar;
@property (nonatomic, assign) BOOL hasNewNotification;


@end
