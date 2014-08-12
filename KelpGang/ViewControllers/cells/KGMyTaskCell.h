//
//  KGMyTaskCell.h
//  KelpGang
//
//  Created by Andy on 14-8-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGTaskObject;

@interface KGMyTaskCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *taskImgView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

- (void)setObject:(KGTaskObject *)obj;

@end
