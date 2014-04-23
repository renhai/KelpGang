//
//  KGOrderSummaryObject.h
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    ALREADY_PAID =          0,//已付款
    PENDING_COMMENT =       1,//待评价
    ALREADY_COMPLETE =      2 //已完成
} OrderStatus;

@interface KGOrderSummaryObject : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderDesc;
@property (nonatomic, assign) NSInteger orderMoney;
@property (nonatomic, strong) NSString *orderImageUrl;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, assign) NSInteger ownerId;
@property (nonatomic, strong) NSString *ownerName;
@property (nonatomic, strong) NSString *ownerAvatar;
@property (nonatomic, assign) BOOL hasNewNotification;


@end
