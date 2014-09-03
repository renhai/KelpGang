//
//  KGOrderAddressCell.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderAddressCell.h"
#import "KGAddressObject.h"

@implementation KGOrderAddressCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.consigneeLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        self.consigneeRight = [[UILabel alloc] initWithFrame:CGRectZero];
        self.mobileLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.addressLeftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.addressRightLbl = [[UILabel alloc] initWithFrame:CGRectZero];

        self.consigneeLeft.textColor = RGB(187, 187, 187);
        self.consigneeLeft.font = [UIFont systemFontOfSize:16];
        self.consigneeLeft.backgroundColor = [UIColor clearColor];

        self.consigneeRight.textColor = RGB(114, 114, 114);
        self.consigneeRight.font = [UIFont systemFontOfSize:16];
        self.consigneeRight.backgroundColor = [UIColor clearColor];

        self.mobileLbl.textColor = RGB(114, 114, 114);
        self.mobileLbl.font = [UIFont systemFontOfSize:16];
        self.mobileLbl.backgroundColor = [UIColor clearColor];

        self.addressLeftLbl.textColor = RGB(187, 187, 187);
        self.addressLeftLbl.font = [UIFont systemFontOfSize:13];
        self.addressLeftLbl.backgroundColor = [UIColor clearColor];

        self.addressRightLbl.textColor = RGB(114, 114, 114);
        self.addressRightLbl.font = [UIFont systemFontOfSize:13];
        self.addressRightLbl.backgroundColor = [UIColor clearColor];

        [self addSubview:self.consigneeLeft];
        [self addSubview:self.consigneeRight];
        [self addSubview:self.mobileLbl];
        [self addSubview:self.addressLeftLbl];
        [self addSubview:self.addressRightLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.consigneeLeft sizeToFit];
    self.consigneeLeft.origin = CGPointMake(15.0, 10);
    [self.consigneeRight sizeToFit];
    self.consigneeRight.origin = CGPointMake(self.consigneeLeft.right + 5, self.consigneeLeft.top);
    [self.mobileLbl sizeToFit];
    self.mobileLbl.top = self.consigneeLeft.top;
    self.mobileLbl.right = self.width - 15;
    [self.addressLeftLbl sizeToFit];
    self.addressLeftLbl.origin = CGPointMake(self.consigneeLeft.left, self.consigneeLeft.bottom + 10);
    [self.addressRightLbl sizeToFit];
    self.addressRightLbl.width = 230;
    self.addressRightLbl.origin = CGPointMake(self.addressLeftLbl.right + 5, self.addressLeftLbl.top);
}

- (void)setObject:(id)object {
    [super setObject:object];
    KGAddressObject *addrObj = object;
    self.consigneeLeft.text = @"收货人：";
    self.consigneeRight.text = addrObj.consignee;
    self.mobileLbl.text = addrObj.mobile;
    self.addressLeftLbl.text = @"收货地址：";
    self.addressRightLbl.text = [NSString stringWithFormat:@"%@%@%@%@", addrObj.province, addrObj.city, addrObj.district, addrObj.street];
    [self setNeedsLayout];
}

@end
