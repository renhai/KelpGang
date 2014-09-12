//
//  KGTaskGoodsPhotoCollectionViewCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskGoodsPhotoCollectionViewCell.h"

@implementation KGTaskGoodsPhotoCollectionViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImageView *imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        imageView.clipsToBounds = YES;
        self.photoView = imageView;
        [self addSubview:self.photoView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}


@end
