//
//  KGCascadeMenuLeftCell.m
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCascadeMenuLeftCell.h"

@interface KGCascadeMenuLeftCell()

@property (strong, nonatomic) UILabel *label;

@end

@implementation KGCascadeMenuLeftCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        self.label = [[UILabel alloc]initWithFrame:CGRectZero];
        self.label.backgroundColor = [UIColor clearColor];
        [self addSubview:self.label];
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
    labelFrame.origin.x = 38.0;
    labelFrame.origin.y = (self.height - labelFrame.size.height) / 2;
    self.label.frame = labelFrame;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        self.backgroundColor = [UIColor whiteColor];
        self.label.textColor = RGBCOLOR(33, 185, 162);
    } else {
        self.backgroundColor = RGBCOLOR(233, 243, 243);
        self.label.textColor = RGBCOLOR(114, 114, 114);
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
