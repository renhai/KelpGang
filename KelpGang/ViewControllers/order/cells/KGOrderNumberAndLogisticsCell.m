//
//  KGOrderNumberAndLogisticsCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderNumberAndLogisticsCell.h"

@implementation KGOrderNumberAndLogisticsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);
        self.ordernumberLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        self.ordernumberRight = [[UILabel alloc]initWithFrame:CGRectZero];
        self.orderDateLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        self.orderDateRight = [[UILabel alloc]initWithFrame:CGRectZero];
        self.logisticsLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        self.logisticsRight = [[UILabel alloc]initWithFrame:CGRectZero];

        self.ordernumberLeft.textColor = RGB(187, 187, 187);
        self.ordernumberLeft.font = [UIFont systemFontOfSize:13];
        self.ordernumberLeft.backgroundColor = CLEARCOLOR;

        self.ordernumberRight.textColor = RGB(187, 187, 187);
        self.ordernumberRight.font = [UIFont systemFontOfSize:13];
        self.ordernumberRight.backgroundColor = CLEARCOLOR;

        self.orderDateLeft.textColor = RGB(187, 187, 187);
        self.orderDateLeft.font = [UIFont systemFontOfSize:13];
        self.orderDateLeft.backgroundColor = CLEARCOLOR;

        self.orderDateRight.textColor = RGB(187, 187, 187);
        self.orderDateRight.font = [UIFont systemFontOfSize:13];
        self.orderDateRight.backgroundColor = CLEARCOLOR;

        self.logisticsLeft.textColor = RGB(187, 187, 187);
        self.logisticsLeft.font = [UIFont systemFontOfSize:13];
        self.logisticsLeft.backgroundColor = CLEARCOLOR;

        self.logisticsRight.textColor = RGB(187, 187, 187);
        self.logisticsRight.font = [UIFont systemFontOfSize:13];
        self.logisticsRight.backgroundColor = CLEARCOLOR;

        [self addSubview:self.ordernumberLeft];
        [self addSubview: self.ordernumberRight];
        [self addSubview: self.orderDateLeft];
        [self addSubview: self.orderDateRight];
        [self addSubview: self.logisticsLeft];
        [self addSubview: self.logisticsRight];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.ordernumberLeft sizeToFit];
    self.ordernumberLeft.origin = CGPointMake(15, 5);

    [self.ordernumberRight sizeToFit];
    self.ordernumberRight.origin = CGPointMake(self.ordernumberLeft.right + 20, self.ordernumberLeft.top);

    [self.orderDateLeft sizeToFit];
    self.orderDateLeft.origin = CGPointMake(15, self.ordernumberLeft.bottom + 10);

    [self.orderDateRight sizeToFit];
    self.orderDateRight.origin = CGPointMake(self.orderDateLeft.right + 20, self.orderDateLeft.top);

    [self.logisticsLeft sizeToFit];
    self.logisticsLeft.origin = CGPointMake(self.ordernumberLeft.left, self.orderDateLeft.bottom + 10);

    [self.logisticsRight sizeToFit];
    self.logisticsRight.origin = CGPointMake(self.logisticsLeft.right + 20, self.logisticsLeft.top);
}

- (void)setObject:(id)object {
    [super setObject:object];

    NSArray *arr = (NSArray *)object;
    self.ordernumberLeft.text = @"订单号";
    self.ordernumberRight.text = [NSString stringWithFormat:@"%@", arr[0]];
    self.orderDateLeft.text = @"订单日期";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.M.d hh:mm:ss"];
    self.orderDateRight.text = [df stringFromDate:arr[1]];
    self.logisticsLeft.text = @"物流公司";
    NSString *company = arr[2];
    NSString *number = arr[3];
    if (company.length > 0 && number.length > 0) {
        self.logisticsRight.text = [NSString stringWithFormat:@"%@ %@", company, number];
    } else {
        self.logisticsRight.text = @"卖家未填写物流信息";
    }

    [self setNeedsLayout];
}


@end
