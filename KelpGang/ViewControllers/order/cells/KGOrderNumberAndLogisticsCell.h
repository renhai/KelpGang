//
//  KGOrderNumberAndLogisticsCell.h
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTableViewCell.h"

@interface KGOrderNumberAndLogisticsCell : KGTableViewCell

@property (nonatomic, strong) UILabel *ordernumberLeft;
@property (nonatomic, strong) UILabel *ordernumberRight;
@property (nonatomic, strong) UILabel *orderDateLeft;
@property (nonatomic, strong) UILabel *orderDateRight;
@property (nonatomic, strong) UILabel *logisticsLeft;
@property (nonatomic, strong) UILabel *logisticsRight;

@end
