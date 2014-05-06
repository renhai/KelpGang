//
//  KGCompletedOrderController.h
//  KelpGang
//
//  Created by Andy on 14-5-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGOrderObject;

@interface KGCompletedOrderController : UIViewController

@property (nonatomic, assign)NSInteger orderId;
@property (nonatomic, strong)KGOrderObject *orderObj;


@end
