//
//  KGCreateOrderTaskNameCell.h
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCreateOrderTaskNameCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *taskNameLabel;
@property (weak, nonatomic) IBOutlet UITextView *taskValueTextView;

- (void)setObject:(NSString *)taskName;

@end
