//
//  KGChatMessageOtherCell.h
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGChatObject;

@interface KGChatTextMessageCell : UITableViewCell

@property (nonatomic, strong) UIView *bgView;
@property (nonatomic, strong) UILabel *msgLabel;
@property (nonatomic, strong) UIImageView *headView;
@property (nonatomic, strong) KGChatObject *chatObj;

- (void)configCell:(KGChatObject *)chatObj;

@end
