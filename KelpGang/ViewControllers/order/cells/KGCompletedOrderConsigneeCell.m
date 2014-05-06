//
//  KGCompletedOrderConsigneeCell.m
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderConsigneeCell.h"
#import "KGAddressObject.h"

@implementation KGCompletedOrderConsigneeCell

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
    [self.consigneeTitleLabel sizeToFit];
    self.consigneeTitleLabel.left = 15;
    self.consigneeTitleLabel.top = 14;

    [self.consigneeValueLabel sizeToFit];
    self.consigneeValueLabel.left = self.consigneeTitleLabel.right + 2;
    self.consigneeValueLabel.centerY = self.consigneeTitleLabel.centerY;

    [self.mobileLabel sizeToFit];
    self.mobileLabel.right = self.width - 15;
    self.mobileLabel.centerY = self.consigneeTitleLabel.centerY;

    [self.addrTitleLabel sizeToFit];
    self.addrTitleLabel.left = self.consigneeTitleLabel.left;
    self.addrTitleLabel.top = self.consigneeTitleLabel.bottom + 10;

    [self.addrValueLabel sizeToFit];
    self.addrValueLabel.top = self.addrTitleLabel.top;
    self.addrValueLabel.left = self.addrTitleLabel.right + 2;
    self.addrValueLabel.width = self.width - self.addrValueLabel.left - 15;
}

- (void)setObject:(KGAddressObject *)addrObj {
    self.consigneeValueLabel.text = addrObj.consignee;
    self.mobileLabel.text = addrObj.mobile;
    self.addrValueLabel.text = [NSString stringWithFormat:@"%@%@%@%@", addrObj.province, addrObj.city, addrObj.district, addrObj.street];
}


@end
