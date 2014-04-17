//
//  KGBaseMessageCell.h
//  KelpGang
//
//  Created by Andy on 14-4-16.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGChatObject;

@interface KGBaseMessageCell : UITableViewCell

@property (nonatomic, strong) KGChatObject *chatObj;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)configCell:(KGChatObject *)chatObj;

- (void)showMessageIndicator: (BOOL)display;

@end
