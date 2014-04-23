//
//  KGRecentContactsCell.h
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGRecentContactObject;

@interface KGRecentContactsCell : UITableViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UILabel *messageLabel;
@property (nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UIImageView *badgeView;

@property (nonatomic, strong) KGRecentContactObject* contactObj;

- (void)configCell: (KGRecentContactObject *)contactObj;

@end
