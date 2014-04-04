//
//  KGCommonMenuCell.h
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCommonMenuCell : UITableViewCell

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *bottomLine;

- (void)setLabelText: (NSString *)text;
- (NSString *)labelText;

@end
