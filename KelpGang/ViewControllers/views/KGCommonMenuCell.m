//
//  KGCommonMenuCell.m
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommonMenuCell.h"

@interface KGCommonMenuCell ()

@end

@implementation KGCommonMenuCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        UIView *line = [KGUtils seperatorWithFrame:CGRectMake(0, self.height - LINE_HEIGHT, self.width, LINE_HEIGHT)];
        self.bottomLine = line;
        [self addSubview:self.bottomLine];

        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:self.label];
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
    if (selected) {
        self.label.textColor = RGBCOLOR(33, 185, 162);
        self.bottomLine.backgroundColor = RGBCOLOR(33, 185, 162);
    } else {
        self.label.textColor = RGBCOLOR(114, 114, 114);
        self.bottomLine.backgroundColor = RGBCOLOR(211, 220, 224);
    }

}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect labelFrame = self.label.frame;
    labelFrame.origin.x = (self.width - labelFrame.size.width) / 2;
    labelFrame.origin.y = (self.height - labelFrame.size.height) / 2;
    self.label.frame = labelFrame;
}

- (void)setLabelText: (NSString *)text {
    if (!self.label) {
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
    }
    self.label.text = text;
    self.label.textColor = RGBCOLOR(114, 114, 114);
    self.label.font = [UIFont systemFontOfSize:16];
    [self.label sizeToFit];
}

- (NSString *)labelText {
    return self.label.text;
}


@end
