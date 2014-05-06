//
//  KGCompletedOrderBuyerCell.m
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderBuyerCell.h"

@implementation KGCompletedOrderBuyerCell

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
    [self.buyerTitleLabel sizeToFit];
    [self.buyerValueLabel sizeToFit];
    self.buyerTitleLabel.left = 15;
    self.buyerTitleLabel.centerY = self.height / 2;
    self.buyerValueLabel.left = self.buyerTitleLabel.right + 2;
    self.buyerValueLabel.centerY = self.height / 2;
}

- (void)setBuyerName: (NSString *)value {
    self.buyerValueLabel.text = value;
}


@end
