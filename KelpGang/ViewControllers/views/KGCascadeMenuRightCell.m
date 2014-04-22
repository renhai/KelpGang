//
//  KGCascadeMenuRightCell.m
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCascadeMenuRightCell.h"

@interface KGCascadeMenuRightCell()

@property (strong, nonatomic) UILabel *label;
@property (strong, nonatomic) UIView *bottomLine;

@end

@implementation KGCascadeMenuRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        [self addSubview:self.label];

        UIView *line = [KGUtils seperatorWithFrame:CGRectMake(20, self.height - LINE_HEIGHT, self.width - 20, LINE_HEIGHT)];
        self.bottomLine = line;
        [self addSubview:self.bottomLine];
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect labelFrame = self.label.frame;
    labelFrame.origin.x = 48.0;
    labelFrame.origin.y = (self.height - labelFrame.size.height) / 2;
    self.label.frame = labelFrame;
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
