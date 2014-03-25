//
//  KGBadgeView.h
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

static const CGFloat kBadgeViewWidth = 22.0;
static const CGFloat kBadgeViewHeight = 22.0;

@interface KGBadgeView : UIView

- (void)setBadgeValue: (NSInteger) value;
- (void)hidebadgeView;

@end
