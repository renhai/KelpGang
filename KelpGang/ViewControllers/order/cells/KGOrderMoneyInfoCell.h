//
//  KGOrderMoneyInfoCell.h
//  KelpGang
//
//  Created by Andy on 14-9-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGOrderMoneyInfoCell : KGTableViewCell

@property (nonatomic, strong) UILabel *moneyLeft;
@property (nonatomic, strong) UILabel *moneyRight;
@property (nonatomic, strong) UILabel *gratuityLeft;
@property (nonatomic, strong) UILabel *gratuityRight;
@property (nonatomic, strong) UILabel *totalLeft;
@property (nonatomic, strong) UILabel *totalRight;

@end
