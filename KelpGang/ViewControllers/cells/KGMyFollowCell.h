//
//  KGMyFollowCell.h
//  KelpGang
//
//  Created by Andy on 14-8-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGUserFollowObject;

@interface KGMyFollowCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UIButton *followBtn;

- (void)setObject: (KGUserFollowObject *)obj;

@end
