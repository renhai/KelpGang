//
//  KGTaskViewHeadCell.h
//  KelpGang
//
//  Created by Andy on 14-8-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGTaskObject;

@interface KGTaskViewHeadCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *commissionLabel;

- (void)setObject: (KGTaskObject *)obj;

@end
