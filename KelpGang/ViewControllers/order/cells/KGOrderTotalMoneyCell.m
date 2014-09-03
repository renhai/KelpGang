//
//  KGOrderTotalMoneyCell.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderTotalMoneyCell.h"

@implementation KGOrderTotalMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);

        self.leftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rightLbl = [[UILabel alloc] initWithFrame:CGRectZero];

        self.leftLbl.textColor = RGB(187, 187, 187);
        self.leftLbl.font = [UIFont systemFontOfSize:16];
        self.leftLbl.backgroundColor = [UIColor clearColor];

        self.rightLbl.textColor = MAIN_COLOR;
        self.rightLbl.font = [UIFont systemFontOfSize:20];
        self.rightLbl.backgroundColor = [UIColor clearColor];

        [self addSubview:self.leftLbl];
        [self addSubview:self.rightLbl];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.leftLbl sizeToFit];
    self.leftLbl.left = 15;
    self.leftLbl.centerY = self.height / 2;

    [self.rightLbl sizeToFit];
    self.rightLbl.centerY = self.leftLbl.centerY;
    self.rightLbl.right = self.width - 15;
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSString *value = object;
    self.leftLbl.text = @"订单总价：";
    self.rightLbl.text = value;
    
    [self setNeedsLayout];
}

@end
