//
//  KGCreateOrderPhotoCell.m
//  KelpGang
//
//  Created by Andy on 14-5-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderPhotoCell.h"

@implementation KGCreateOrderPhotoCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.imageView.layer.borderWidth = 3;
    self.imageView.layer.borderColor = RGBCOLOR(213, 232, 232).CGColor;

    self.delButton.right = self.width - 4;
    self.delButton.top = 4;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
