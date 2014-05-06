//
//  KGCompletedOrderLabelCell.m
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderLabelCell.h"

@implementation KGCompletedOrderLabelCell

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

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.titleLabel sizeToFit];
    self.titleLabel.left = 15;
    self.titleLabel.centerY = self.height / 2;
    [self.valueLabel sizeToFit];
    self.valueLabel.centerY = self.height / 2;
    self.valueLabel.left = self.titleLabel.right + 2;
}

- (void)setTitle:(NSString *)title value: (NSString *)value {
    self.titleLabel.text = title;
    self.valueLabel.text = value;
}


@end
