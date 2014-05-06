//
//  KGCompletedOrderPriceCell.m
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderPriceCell.h"

@implementation KGCompletedOrderPriceCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.left = 15;
    self.titleLabel.centerY = self.height / 2;
    [self.valueLabel sizeToFit];
    self.valueLabel.centerY = self.height / 2;
    self.valueLabel.right = self.width - 15;
}

- (void)setPrice:(NSString *)price {
    self.valueLabel.text = price;
}

@end
