//
//  KGPicBottomView.m
//  KelpGang
//
//  Created by Andy on 14-3-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGPicBottomView.h"

static CGFloat const kBottomViewHeight = 100.0;

@implementation KGPicBottomView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithPhoto:(id<MWPhoto>)photo index: (NSInteger) index count: (NSInteger) count title: (NSString*) title{
    self = [super initWithPhoto:photo];
    if (self) {
        UILabel* titleLabel = (UILabel*)[self.bottomView viewWithTag:1];
        titleLabel.text = title;
        UILabel* indexLable = (UILabel*)[self.bottomView viewWithTag:2];
        indexLable.text = [NSString stringWithFormat:@"%d/%d", index + 1, count];

        UIButton *chatBtn = (UIButton *)[self.bottomView viewWithTag:3];
        self.userInteractionEnabled = YES;
        [chatBtn addTarget:self action:@selector(tapChat:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void) tapChat:(UIButton *)sender {
    NSLog(@"tab chat");
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(SCREEN_WIDTH, kBottomViewHeight);
}

- (void)setupCaption {
    self.backgroundColor = [UIColor clearColor];
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"KGPicBottom" owner:self options:nil];
    self.bottomView = nibs[0];
    self.bottomView.backgroundColor = [UIColor clearColor];
    [self addSubview:self.bottomView];
}

@end
