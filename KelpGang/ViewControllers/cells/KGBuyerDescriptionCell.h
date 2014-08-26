//
//  KGBuyerDescriptionCell.h
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGUserObject;

@interface KGBuyerDescriptionCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIImageView *vipImageView;
@property (weak, nonatomic) IBOutlet UIButton *followButton;
@property (weak, nonatomic) IBOutlet UIView *levelView;

- (void)setUserInfo: (KGUserObject *)userInfo;

@end
