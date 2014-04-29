//
//  KGCreateOrderBuyerCell.m
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderBuyerCell.h"

@implementation KGCreateOrderBuyerCell

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
    [self.buyerValueLabel sizeToFit];
}

- (void)setObject:(NSString *)buyerName {
    self.buyerValueLabel.text = buyerName;
}


@end
