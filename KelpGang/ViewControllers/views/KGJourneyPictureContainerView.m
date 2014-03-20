//
//  KGJourneyPictureContainerView.m
//  KelpGang
//
//  Created by Andy on 14-3-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGJourneyPictureContainerView.h"

@implementation KGJourneyPictureContainerView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame image: (UIImage *) image {
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewWidth, kImageViewHeight)];
        imageView.image = image;
        imageView.clipsToBounds = YES;
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.layer.borderWidth = 3;
        imageView.layer.borderColor = RGBCOLOR(213, 232, 232).CGColor;
        self.imgView = imageView;
        [self addSubview:self.imgView];

        UIButton *delbtn = [[UIButton alloc] initWithFrame:CGRectMake(61, 7, 26, 26)];
        [delbtn setBackgroundImage:[UIImage imageNamed:@"delete_img"] forState:UIControlStateNormal];
        self.delBtn = delbtn;
        [self addSubview:delbtn];
    }
    return self;
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
