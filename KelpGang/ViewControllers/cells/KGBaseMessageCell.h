//
//  KGBaseMessageCell.h
//  KelpGang
//
//  Created by Andy on 14-4-16.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGChatCellInfo;

@interface KGBaseMessageCell : UITableViewCell

@property (nonatomic, strong) KGChatCellInfo *chatCellInfo;
@property (nonatomic, strong) UIActivityIndicatorView *indicatorView;

- (void)configCell:(KGChatCellInfo *)chatCellInfo;

- (void)showMessageIndicator: (BOOL)display;

@end
