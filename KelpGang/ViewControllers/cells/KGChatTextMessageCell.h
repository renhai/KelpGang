//
//  KGChatMessageOtherCell.h
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGBaseMessageCell.h"

@interface KGChatTextMessageCell : KGBaseMessageCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *headView;

@end
