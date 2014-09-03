//
//  KGLeftRightCell.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderLeftRightCell.h"

@implementation KGOrderLeftRightCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.leftLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.rightLbl = [[UILabel alloc] initWithFrame:CGRectZero];

        self.leftLbl.textColor = RGB(187, 187, 187);
        self.leftLbl.font = [UIFont systemFontOfSize:16];
        self.leftLbl.backgroundColor = [UIColor clearColor];

        self.rightLbl.textColor = RGB(114, 114, 114);
        self.rightLbl.font = [UIFont systemFontOfSize:16];
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
    self.rightLbl.origin = CGPointMake(self.leftLbl.right + 5, self.leftLbl.top);
    if (self.rightLbl.width > 220) {
        self.rightLbl.width = 220;
    }
}

- (void)setObject:(id)object {
    [super setObject:object];
    NSArray *arr = object;
    NSString *key = arr[0];
    NSString *value = arr[1];
    self.leftLbl.text = key;
    self.rightLbl.text = value;

    [self setNeedsLayout];
}

- (void)setRightLblTextColor: (UIColor *)color {
    self.rightLbl.textColor = color;
}



@end
