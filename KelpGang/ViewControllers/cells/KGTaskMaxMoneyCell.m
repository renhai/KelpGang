//
//  KGTaskMaxMoneyCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskMaxMoneyCell.h"

@interface KGTaskMaxMoneyCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation KGTaskMaxMoneyCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.text = @"不超过金额";
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.backgroundColor = CLEARCOLOR;
        leftLabel.textColor = RGB(187, 187, 187);
        self.leftLabel = leftLabel;

        UILabel *moneyLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        moneyLabel.font = [UIFont systemFontOfSize:16];
        moneyLabel.backgroundColor = CLEARCOLOR;
        moneyLabel.textColor = MAIN_COLOR;
        self.moneyLabel = moneyLabel;

        UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(15, 0, 290, LINE_HEIGHT)];
        self.bottomLine = bottomLine;

        [self addSubview:self.leftLabel];
        [self addSubview:self.moneyLabel];
        [self addSubview:self.bottomLine];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftLabel sizeToFit];
    self.leftLabel.left = 15;
    self.leftLabel.centerY = self.height / 2;

    [self.moneyLabel sizeToFit];
    self.moneyLabel.left = self.leftLabel.right + 10;
    self.moneyLabel.centerY = self.leftLabel.centerY;

    self.bottomLine.bottom = self.height;
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSString *money = object;
    self.moneyLabel.text = money;
    [self setNeedsLayout];
}


@end
