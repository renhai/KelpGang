//
//  KGLeaveMessageController.h
//  KelpGang
//
//  Created by Andy on 14-9-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGLeaveMessageController : UIViewController

@property (nonatomic, assign) NSInteger orderId;
@property (nonatomic, strong) NSString *oriMessage;
@property (nonatomic, copy) VoidBlock_string block;

@end
