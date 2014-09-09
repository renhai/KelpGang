//
//  KGLogisticsCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLogisticsCell.h"

@implementation KGLogisticsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);

        UIView *companyView = [[UIView alloc] initWithFrame:CGRectMake(15, 15, 290, 30)];
        companyView.backgroundColor = [UIColor whiteColor];
        companyView.layer.cornerRadius = 5;
        companyView.layer.borderWidth = 1;
        companyView.layer.borderColor = RGB(216, 224, 227).CGColor;

        UILabel *cLeftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        cLeftLbl.text = @"物流公司";
        cLeftLbl.textColor = RGB(187, 187, 187);
        cLeftLbl.font = [UIFont systemFontOfSize:13];
        [cLeftLbl sizeToFit];
        cLeftLbl.left = 5;
        cLeftLbl.centerY = companyView.height / 2;
        [companyView addSubview:cLeftLbl];

        self.logisticsCompanyTF = [[UITextField alloc] initWithFrame:CGRectMake(cLeftLbl.right + 10, 0, 200, companyView.height)];
        self.logisticsCompanyTF.textColor = MAIN_COLOR;
        self.logisticsCompanyTF.tag = 1001;
        [companyView addSubview:self.logisticsCompanyTF];

        UIView *orderNumberView = [[UIView alloc] initWithFrame:CGRectMake(15, companyView.bottom + 15, 290, 30)];
        orderNumberView.backgroundColor = [UIColor whiteColor];
        orderNumberView.layer.cornerRadius = 5;
        orderNumberView.layer.borderWidth = 1;
        orderNumberView.layer.borderColor = RGB(216, 224, 227).CGColor;

        UILabel *oLeftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        oLeftLbl.text = @"订单号";
        oLeftLbl.textColor = RGB(187, 187, 187);
        oLeftLbl.font = [UIFont systemFontOfSize:13];
        [oLeftLbl sizeToFit];
        oLeftLbl.left = 5;
        oLeftLbl.centerY = orderNumberView.height / 2;
        [orderNumberView addSubview:oLeftLbl];

        self.logisticsNumberTF = [[UITextField alloc] initWithFrame:CGRectMake(oLeftLbl.right + 10, 0, 200, orderNumberView.height)];
        self.logisticsNumberTF.textColor = MAIN_COLOR;
        self.logisticsNumberTF.tag = 1002;
        [orderNumberView addSubview:self.logisticsNumberTF];

        [self addSubview:companyView];
        [self addSubview:orderNumberView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)setObject:(id)object {
    [super setObject:object];
    [self setNeedsLayout];
}


@end
