//
//  KGDeliveryAddressTableViewController.h
//  KelpGang
//
//  Created by Andy on 14-3-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGAddressObject;

typedef void(^SelectAddressBlock)(KGAddressObject *obj);

@interface KGDeliveryAddressController : UITableViewController

@property (nonatomic, copy) SelectAddressBlock selectBlock;

@end
