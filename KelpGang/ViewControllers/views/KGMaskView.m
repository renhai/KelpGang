//
//  KGMaskView.m
//  KelpGang
//
//  Created by Andy on 14-3-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMaskView.h"

@implementation KGMaskView

- (void)dealloc
{
    NSLog(@"");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor grayColor];
        self.alpha = 0.5;
        self.opaque = NO;
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
