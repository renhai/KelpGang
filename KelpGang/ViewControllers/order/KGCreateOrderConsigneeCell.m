//
//  KGCreateOrderConsigneeCell.m
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderConsigneeCell.h"
#import "KGAddressObject.h"

@implementation KGCreateOrderConsigneeCell

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
    self.arrowImageView.right = 305;
    self.arrowImageView.centerY = self.height / 2;

    [self.consigneeNameLabel sizeToFit];
    self.consigneeNameLabel.left = 15;
    self.consigneeNameLabel.top = 20;

    [self.consigneeValueLabel sizeToFit];
    self.consigneeValueLabel.left = self.consigneeNameLabel.right + 2;
    self.consigneeValueLabel.centerY = self.consigneeNameLabel.centerY;

    [self.mobileLabel sizeToFit];
    self.mobileLabel.right = 280;
    self.mobileLabel.centerY = self.consigneeNameLabel.centerY;

    [self.addrNameLabel sizeToFit];
    self.addrNameLabel.left = 15;
    self.addrNameLabel.top = 50;

    self.addrValueLabel.numberOfLines = 2;
    [self.addrValueLabel sizeToFit];
    self.addrValueLabel.width = 205;
    self.addrValueLabel.top = self.addrNameLabel.top;
    self.addrValueLabel.left = self.addrNameLabel.right + 2;
}

- (void)setObject:(KGAddressObject *)addrObj {
    self.consigneeValueLabel.text = addrObj.consignee;
    self.mobileLabel.text = addrObj.mobile;
    self.addrValueLabel.text = [NSString stringWithFormat:@"%@%@%@%@", addrObj.province, addrObj.city, addrObj.district, addrObj.street];
}

@end
