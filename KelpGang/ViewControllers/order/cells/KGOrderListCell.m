//
//  KGOrderListCell.m
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderListCell.h"
#import "KGOrderSummaryObject.h"

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
    self.nameLabel.centerY = self.headImageView.centerY;

    [self.orderNumLabel sizeToFit];

    self.orderDescLabel.width = 210;
    [self.orderDescLabel sizeToFit];

    [self.orderMoneyLabel sizeToFit];

    [self.orderStatusLabel sizeToFit];
    self.orderStatusLabel.width += 4;
    self.orderStatusLabel.height += 2;
    self.orderStatusLabel.right = 300;
}

- (void)setObject: (KGOrderSummaryObject *)orderSummaryObj {
    self.orderSummaryObj = orderSummaryObj;
    [self.headImageView setImageWithURL:[NSURL URLWithString:orderSummaryObj.userAvatar] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.headImageView.userInteractionEnabled = YES;
    self.nameLabel.text = orderSummaryObj.userName;
    self.nameLabel.userInteractionEnabled = YES;
    self.badgeView.hidden = !orderSummaryObj.hasNewNotification;
    [self.orderImageView setImageWithURL:[NSURL URLWithString:orderSummaryObj.orderImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.orderImageView.layer.borderWidth = 1;
    self.orderImageView.layer.borderColor = RGBCOLOR(201, 201, 201).CGColor;
    self.orderNumLabel.text = [NSString stringWithFormat:@"订单号 %@", orderSummaryObj.orderNumber];
    self.orderDescLabel.text = orderSummaryObj.orderDesc;
    self.orderMoneyLabel.text = [NSString stringWithFormat:@"￥%0.2f", orderSummaryObj.orderMoney];

    self.orderStatusLabel.layer.cornerRadius = 4;
    self.orderStatusLabel.layer.borderWidth = 1;
    if (orderSummaryObj.orderStatus == COMPLETED) {
        self.orderStatusLabel.textColor = RGBCOLOR(187, 187, 187);
        self.orderStatusLabel.layer.borderColor = RGBCOLOR(187, 187, 187).CGColor;
    } else {
        self.orderStatusLabel.textColor = MAIN_COLOR;
        self.orderStatusLabel.layer.borderColor = MAIN_COLOR.CGColor;
    }
    switch (orderSummaryObj.orderStatus) {
        case WAITING_CONFIRM:
            self.orderStatusLabel.text = @"待确认";
            break;
        case WAITING_PAID:
            self.orderStatusLabel.text = @"待付款";
            break;
        case PURCHASING:
            self.orderStatusLabel.text = @"采购中";
            break;
        case RETURNING:
            self.orderStatusLabel.text = @"采购完成";
            break;
        case WAITING_RECEIPT:
            self.orderStatusLabel.text = @"等待买家确认收货";
            break;
        case WAITING_COMMENT:
            self.orderStatusLabel.text = @"待评价";
            break;
        case COMPLETED:
            self.orderStatusLabel.text = @"已完成";
            break;
        default:
            break;
    }
}

@end
