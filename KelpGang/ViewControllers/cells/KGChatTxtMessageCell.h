//
//  KGChatTxtMessageCell.h
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGChatCellInfo;

@interface KGChatTxtMessageCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UIView *timeView;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UILabel *messageLabel;

@property (nonatomic, strong) KGChatCellInfo *chatCellInfo;


- (void)configCell:(KGChatCellInfo *)chatCellInfo;

@end
