//
//  KGOrderLocationCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderLocationCell.h"
#import "KGLocationObject.h"

@implementation KGOrderLocationCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.locationImageView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"location"]];

        self.locationLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        self.locationLbl.textColor = RGB(114, 114, 114);
        self.locationLbl.font = [UIFont systemFontOfSize:13];
        self.locationLbl.backgroundColor = CLEARCOLOR;

        [self addSubview:self.locationImageView];
        [self addSubview:self.locationLbl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.locationImageView.left = 15;
    self.locationImageView.centerY = self.height / 2;

    [self.locationLbl sizeToFit];
    self.locationLbl.left = self.locationImageView.right + 5;;
    self.locationLbl.centerY = self.height / 2;
    if (self.locationLbl.width > 280) {
        self.locationLbl.width = 280;
    }
}

- (void)setObject:(id)object {
    [super setObject:object];
    KGLocationObject *location = object;
    if (!location) {
        self.locationLbl.text = @"未进行采购地点定位";
    } else {
        self.locationLbl.text = [location locationString];
    }
    [self setNeedsLayout];
}

@end
