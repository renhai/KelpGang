//
//  KGChatMessageOtherCell.h
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kBackgroundViewMarginLeft = 5.0;
static const CGFloat kBackgroundViewMarginTop = 8.0;
static const CGFloat kBackgroundViewPaddingTop = 13.0;
static const CGFloat kBackgroundViewPaddingBottom = 13.0;

static const CGFloat kHeaderImageWidth = 25.0;
static const CGFloat kHeaderImageHeight = 25.0;
static const CGFloat kHeaderImageMarginLeft = 14.0;
static const CGFloat kHeaderImageMarginRight = 10.0;
static const CGFloat kHeaderImageMarginTop = 16.0;

static const CGFloat kMessageLableMaxWidth = 240.0;
static const CGFloat kMessageLabelMarginTop = 21.0;
static const CGFloat kMessageLabelMarginBottom = 21.0;
static const CGFloat kMessageLabelMarginRight = 10.0;

@class KGMessageObject;

@interface KGChatTextMessageCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *headView;

- (void)configCell:(KGMessageObject *)msgObj;

@end
