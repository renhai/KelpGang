//
//  KGJourneyPictureContainerView.h
//  KelpGang
//
//  Created by Andy on 14-3-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

static CGFloat const kImageViewHeight = 94.0;
static CGFloat const kImageViewWidth = 94.0;
static CGFloat const kImageMarginWidth = 8.0;
static CGFloat const kImageContainerViewWidth = kImageViewWidth + kImageMarginWidth;

@interface KGJourneyPictureContainerView : UIView

@property (nonatomic, strong) UIImageView *imgView;
@property (nonatomic, strong) UIButton *delBtn;
@property (nonatomic, assign) NSInteger goodsIndex;
@property (nonatomic, assign) NSInteger imgIndex;


- (id)initWithFrame:(CGRect)frame image: (UIImage *) image;

@end
