//
//  KGTaskToCountryLabel.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskExpectCountryCell.h"

@interface KGTaskExpectCountryCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation KGTaskExpectCountryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.text = @"期望完成国家";
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.backgroundColor = CLEARCOLOR;
        leftLabel.textColor = RGB(187, 187, 187);
        self.leftLabel = leftLabel;

        UILabel *countryLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        countryLabel.font = [UIFont systemFontOfSize:16];
        countryLabel.backgroundColor = CLEARCOLOR;
        countryLabel.textColor = MAIN_COLOR;
        self.countryLabel = countryLabel;

        UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(15, 0, 290, LINE_HEIGHT)];
        self.bottomLine = bottomLine;

        [self addSubview:self.leftLabel];
        [self addSubview:self.countryLabel];
        [self addSubview:self.bottomLine];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftLabel sizeToFit];
    self.leftLabel.left = 15;
    self.leftLabel.centerY = self.height / 2;

    [self.countryLabel sizeToFit];
    self.countryLabel.left = self.leftLabel.right + 10;
    self.countryLabel.centerY = self.leftLabel.centerY;

    self.bottomLine.bottom = self.height;
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSString *country = object;
    if (!country || [@"" isEqualToString:country]) {
        self.countryLabel.text = @"任何国家";
    } else {
        self.countryLabel.text = country;
    }
    [self setNeedsLayout];
}

@end
