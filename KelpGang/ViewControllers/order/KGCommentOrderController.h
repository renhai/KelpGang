//
//  KGCommentOrderController.h
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGOrderObject;

@interface KGCommentOrderController : UITableViewController

@property (nonatomic, strong) KGOrderObject *orderObj;
@property (nonatomic, copy) VoidBlock block;

@end
