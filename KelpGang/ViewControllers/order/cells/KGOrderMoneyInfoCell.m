//
//  KGOrderMoneyInfoCell.m
//  KelpGang
//
//  Created by Andy on 14-9-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderMoneyInfoCell.h"

@implementation KGOrderMoneyInfoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.moneyLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        self.moneyLeft.text = @"金额";
        self.moneyLeft.textColor = RGB(187, 187, 187);
        self.moneyLeft.font = [UIFont systemFontOfSize:12];
        self.moneyLeft.backgroundColor = [UIColor clearColor];
        [self addSubview:self.moneyLeft];

        self.moneyRight = [[UILabel alloc] initWithFrame:CGRectZero];
        self.moneyRight.textColor = RGB(114, 114, 114);
        self.moneyRight.font = [UIFont systemFontOfSize:12];
        self.moneyRight.backgroundColor = [UIColor clearColor];
        [self addSubview:self.moneyRight];

        self.gratuityLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        self.gratuityLeft.textColor = RGB(187, 187, 187);
        self.gratuityLeft.text = @"跑腿费比例";
        self.gratuityLeft.font = [UIFont systemFontOfSize:12];
        self.gratuityLeft.backgroundColor = [UIColor clearColor];
        [self addSubview:self.gratuityLeft];

        self.gratuityRight = [[UILabel alloc] initWithFrame:CGRectZero];
        self.gratuityRight.textColor = RGB(114, 114, 114);
        self.gratuityRight.font = [UIFont systemFontOfSize:12];
        self.gratuityRight.backgroundColor = [UIColor clearColor];
        [self addSubview:self.gratuityRight];

        self.totalLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        self.totalLeft.textColor = RGB(187, 187, 187);
        self.totalLeft.text = @"总金额";
        self.totalLeft.font = [UIFont systemFontOfSize:12];
        self.totalLeft.backgroundColor = [UIColor clearColor];
        [self addSubview:self.totalLeft];

        self.totalRight = [[UILabel alloc] initWithFrame:CGRectZero];
        self.totalRight.textColor = MAIN_COLOR;
        self.totalRight.font = [UIFont systemFontOfSize:15];
        self.totalRight.backgroundColor = [UIColor clearColor];
        [self addSubview:self.totalRight];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.moneyLeft sizeToFit];
    self.moneyLeft.left = 15;
    self.moneyLeft.centerY = self.height / 2;

    [self.moneyRight sizeToFit];
    self.moneyRight.origin = CGPointMake(self.moneyLeft.right, self.moneyLeft.top);

    [self.gratuityLeft sizeToFit];
    self.gratuityLeft.origin = CGPointMake(self.moneyRight.right + 10, self.moneyRight.top);

    [self.gratuityRight sizeToFit];
    self.gratuityRight.origin = CGPointMake(self.gratuityLeft.right, self.gratuityLeft.top);

    [self.totalLeft sizeToFit];
    self.totalLeft.origin = CGPointMake(self.gratuityRight.right + 10, self.gratuityRight.top);

    [self.totalRight sizeToFit];
    self.totalRight.left = self.totalLeft.right;
    self.totalRight.centerY = self.height / 2;
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSArray *arr = object;
    CGFloat money = [arr[0] floatValue];
    CGFloat gratuity = [arr[1] floatValue];
    CGFloat totalMoney = [arr[2] floatValue];
    self.moneyRight.text = [NSString stringWithFormat:@"￥%0.0f", money];
    self.gratuityRight.text = [NSString stringWithFormat:@"%0.0f%%", gratuity];
    self.totalRight.text = [NSString stringWithFormat:@"￥%0.1f", totalMoney];
    [self setNeedsLayout];
}


@end
