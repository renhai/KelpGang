//
//  KGCreateOrderTextFieldCell.h
//  KelpGang
//
//  Created by Andy on 14-5-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCreateOrderTextFieldCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UITextField *textField;

- (void)configCell: (NSString *)title text: (NSString *)text;

@end
