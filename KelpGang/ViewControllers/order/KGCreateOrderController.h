//
//  KGCreateOrderController.h
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGAddressObject;

@interface KGCreateOrderController : UIViewController

@property (nonatomic, strong) KGAddressObject *addrObj;
@property (nonatomic, strong) NSString *buyerName;
@property (nonatomic, strong) NSString *taskName;

@end
