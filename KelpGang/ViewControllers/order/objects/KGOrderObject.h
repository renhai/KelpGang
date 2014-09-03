//
//  KGOrderObject.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGAddressObject;

@interface KGOrderObject : NSObject

@property (nonatomic, assign) NSInteger orderId;
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
@property (nonatomic, assign) NSInteger buyerId;;

@end
