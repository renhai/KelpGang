//
//  KGOrderObject.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGAddressObject;
@class KGLocationObject;

@interface KGOrderObject : NSObject

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, assign) NSInteger ownerId;
@property (nonatomic, strong) NSString *orderNumber;
@property (nonatomic, strong) NSString *orderImageUrl;
@property (nonatomic, assign) OrderStatus orderStatus;
@property (nonatomic, strong) NSDate *orderDate;
@property (nonatomic, strong) KGAddressObject *addr;
@property (nonatomic, assign) CGFloat gratuity;
@property (nonatomic, assign) CGFloat totalMoney;
@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, assign) CGFloat taskMoney;
@property (nonatomic, strong) NSString *taskTitle;
@property (nonatomic, strong) NSString *taskMessage;
@property (nonatomic, strong) NSString *buyerName;
@property (nonatomic, assign) NSInteger buyerId;
@property (nonatomic, strong) NSString *leaveMessage;
@property (nonatomic, strong) KGLocationObject *location;
@property (nonatomic, strong) NSString *logisticsCompany;
@property (nonatomic, strong) NSString *logisticsNumber;
@property (nonatomic, assign) BOOL commented;


@end
