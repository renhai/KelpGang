//
//  KGTaskDescCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskDescCell.h"

@interface KGTaskDescCell ()

@property (nonatomic, strong) UILabel *leftLabel;
@property (nonatomic, strong) UIView *bottomLine;

@end

@implementation KGTaskDescCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UILabel *leftLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        leftLabel.text = @"任务描述";
        leftLabel.font = [UIFont systemFontOfSize:16];
        leftLabel.backgroundColor = CLEARCOLOR;
        leftLabel.textColor = RGB(187, 187, 187);
        self.leftLabel = leftLabel;

        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 40)];
        descLabel.font = [UIFont systemFontOfSize:16];
        descLabel.backgroundColor = CLEARCOLOR;
        descLabel.textColor = MAIN_COLOR;
        descLabel.numberOfLines = 0;
        self.descLabel = descLabel;

        UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(0, 0, self.width, LINE_HEIGHT)];
        self.bottomLine = bottomLine;

        [self addSubview:self.leftLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.bottomLine];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.leftLabel sizeToFit];
    self.leftLabel.left = 15;
    self.leftLabel.top = 8;

    [self.descLabel sizeToFit];
    self.descLabel.left = self.leftLabel.right + 10;
    self.descLabel.top = self.leftLabel.top;
    if (self.descLabel.height > 40) {
        self.descLabel.height = 40;
    }

    self.bottomLine.bottom = self.height;
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSString *desc = object;
    self.descLabel.text = desc;
    [self setNeedsLayout];
}


@end
