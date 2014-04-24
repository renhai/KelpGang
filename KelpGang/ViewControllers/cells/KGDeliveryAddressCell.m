//
//  KGDeliveryAddressCell.m
//  KelpGang
//
//  Created by Andy on 14-4-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDeliveryAddressCell.h"
#import "KGAddressObject.h"

@interface KGDeliveryAddressCell ()

@property (nonatomic, strong) KGAddressObject *addrObj;

@end

@implementation KGDeliveryAddressCell

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
}

- (void)setObject: (KGAddressObject *)addrObj {
    self.addrObj = addrObj;
    self.nameLabel.text = addrObj.consignee;
    self.districtLabel.text = [NSString stringWithFormat:@"%@%@%@", addrObj.province, addrObj.city, addrObj.district];
    self.detailAddrLabel.text = addrObj.street;
    self.defaultAddrImageView.hidden = !addrObj.isDefault;
}

@end
