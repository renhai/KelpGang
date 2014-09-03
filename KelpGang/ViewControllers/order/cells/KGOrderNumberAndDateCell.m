//
//  KGOrderNumberAndDateCell.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderNumberAndDateCell.h"

@implementation KGOrderNumberAndDateCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);
        self.ordernumberLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        self.ordernumberRight = [[UILabel alloc]initWithFrame:CGRectZero];
        self.orderDateLeft = [[UILabel alloc]initWithFrame:CGRectZero];
        self.orderDateRight = [[UILabel alloc]initWithFrame:CGRectZero];

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

        [self addSubview:self.ordernumberLeft];
        [self addSubview: self.ordernumberRight];
        [self addSubview: self.orderDateLeft];
        [self addSubview: self.orderDateRight];
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

}

- (void)setObject:(id)object {
    [super setObject:object];

    NSArray *arr = (NSArray *)object;
    self.ordernumberLeft.text = @"订单号";
    self.ordernumberLeft.textColor = RGB(187, 187, 187);
    self.ordernumberLeft.font = [UIFont systemFontOfSize:13];
    self.ordernumberRight.text = [NSString stringWithFormat:@"%@", arr[0]];
    self.orderDateRight.textColor = RGB(187, 187, 187);
    self.orderDateRight.font = [UIFont systemFontOfSize:13];
    self.orderDateLeft.text = @"订单日期";
    NSDateFormatter *df = [[NSDateFormatter alloc] init];
    [df setDateFormat:@"yyyy.M.d hh:mm:ss"];
    self.orderDateRight.text = [df stringFromDate:arr[1]];

    [self setNeedsLayout];
}

@end
