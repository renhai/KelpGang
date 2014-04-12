//
//  KGChatMessageOtherCell.h
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kMessageLableMaxWidth = 240.0;
static const CGFloat kMessageLabelMarginTop = 21.0;
static const CGFloat kMessageLabelMarginBottom = 21.0;

@class KGMessageObject;

@interface KGChatTextMessageCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) KGMessageObject *msgObj;

- (void)configCell:(KGMessageObject *)msgObj;

@end
