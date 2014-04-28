//
//  KGOrderSummaryObject.h
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    WAITING_CONFIRM =       0,//待确认
    WAITING_PAID =          1,//待付款
    PURCHASING =            2,//采购中
    RETURNING =             3,//返程中
    WAITING_RECEIPT =       4,//等待买家确认收货
    COMPLETED =             5,//已完成
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
