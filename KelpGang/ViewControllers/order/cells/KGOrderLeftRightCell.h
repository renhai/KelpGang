//
//  KGLeftRightCell.h
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGOrderLeftRightCell : KGTableViewCell

@property (nonatomic, strong) UILabel *leftLbl;
@property (nonatomic, strong) UILabel *rightLbl;

- (void)setRightLblTextColor: (UIColor *)color;

@end
