//
//  KGLocateCell.m
//  KelpGang
//
//  Created by Andy on 14-9-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLocateCell.h"

@implementation KGLocateCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = MAIN_COLOR;

        self.locateLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.locateLbl.text = @"采购地点定位";
        self.locateLbl.textColor = [UIColor whiteColor];
        self.locateLbl.font = [UIFont systemFontOfSize:16];
        self.locateLbl.backgroundColor = [UIColor clearColor];

        [self addSubview:self.locateLbl];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.locateLbl sizeToFit];
    self.locateLbl.left = 15;
    self.locateLbl.centerY = self.height / 2;
}

- (void)setObject:(id)object {
    [super setObject:object];
    [self setNeedsLayout];
}

@end
