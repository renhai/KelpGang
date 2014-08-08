//
//  KGDiscoverDetailCell.m
//  KelpGang
//
//  Created by Andy on 14-8-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverDetailCell.h"

@implementation KGDiscoverDetailCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = CLEARCOLOR;
        self.headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 25, 25)];
        self.nameLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        self.headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView.clipsToBounds = YES;
        self.headImageView.layer.cornerRadius = self.headImageView.width / 2;

        self.nameLabel.textColor = RGB(33, 185, 162);
        self.nameLabel.font = [UIFont systemFontOfSize:10];
        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
    }
    return self;
}

- (void)setObject: (id)info {
    [self.headImageView setImageWithURL:[NSURL URLWithString:info[@"imageUrl"]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImageView.centerX = self.width / 2;

    self.nameLabel.text = info[@"userName"];
    [self.nameLabel sizeToFit];
    self.nameLabel.centerX = self.headImageView.centerX;
    self.nameLabel.top = self.headImageView.bottom + 5;
}


@end
