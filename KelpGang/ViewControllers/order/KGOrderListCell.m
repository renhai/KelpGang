//
//  KGOrderListCell.m
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderListCell.h"
#import "KGOrderSummaryObject.h"
#import "UIImageView+WebCache.h"

@implementation KGOrderListCell

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
    [self.nameLabel sizeToFit];
    self.nameLabel.left = self.headImageView.right + 5;
    self.nameLabel.top = self.headImageView.centerY - self.nameLabel.height / 2;

    [self.orderNumLabel sizeToFit];
    [self.orderDescLabel sizeToFit];
}

- (void)setObject: (KGOrderSummaryObject *)orderSummaryObj {
    self.orderSummaryObj = orderSummaryObj;
    [self.headImageView setImageWithURL:[NSURL URLWithString:orderSummaryObj.ownerAvatar]];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.nameLabel.text = orderSummaryObj.ownerName;
    self.badgeView.hidden = !orderSummaryObj.hasNewNotification;
    [self.orderImageView setImageWithURL:[NSURL URLWithString:orderSummaryObj.orderImageUrl]];
    self.orderImageView.layer.borderWidth = 1;
    self.orderImageView.layer.borderColor = RGBCOLOR(201, 201, 201).CGColor;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号 %@", orderSummaryObj.orderNumber];
    self.orderDescLabel.text = orderSummaryObj.orderDesc;
    self.orderMoneyLabel.text = [NSString stringWithFormat:@"￥%i", orderSummaryObj.orderMoney];

    self.orderStatusLabel.layer.cornerRadius = 4;
    self.orderStatusLabel.layer.borderWidth = 1;
    if (orderSummaryObj.orderStatus != PENDING_COMMENT) {
        self.orderStatusLabel.textColor = RGBCOLOR(187, 187, 187);
        self.orderStatusLabel.layer.borderColor = RGBCOLOR(187, 187, 187).CGColor;
    } else {
        self.orderStatusLabel.textColor = MAIN_COLOR;
        self.orderStatusLabel.layer.borderColor = MAIN_COLOR.CGColor;
    }
    switch (orderSummaryObj.orderStatus) {
        case ALREADY_COMPLETE:
            self.orderStatusLabel.text = @"已完成";
            break;
        case PENDING_COMMENT:
            self.orderStatusLabel.text = @"待评价";
            break;
        case ALREADY_PAID:
            self.orderStatusLabel.text = @"已付款";
            break;
        default:
            break;
    }
}

@end
