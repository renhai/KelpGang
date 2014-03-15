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

- (void)dealloc {
    NSLog(@"KGPicBottomView deallloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithPhoto:(id<MWPhoto>)photo index: (NSInteger) index count: (NSInteger) count title: (NSString*) title chatBlock: (ChatBlock) chatBlock collectBlock: (CollectBlock) collectBlock{
    self = [super initWithPhoto:photo];
    if (self) {
        self.chatBlock = chatBlock;
        self.collectBlock = collectBlock;
        self.userInteractionEnabled = YES;
        UILabel* titleLabel = (UILabel*)[self.bottomView viewWithTag:1];
        titleLabel.text = title;
        UILabel* indexLable = (UILabel*)[self.bottomView viewWithTag:2];
        indexLable.text = [NSString stringWithFormat:@"%d/%d", index + 1, count];

        UIButton *chatBtn = (UIButton *)[self.bottomView viewWithTag:3];
        [chatBtn addTarget:self action:@selector(tapChat:) forControlEvents:UIControlEventTouchUpInside];

        UIButton *collectBtn = (UIButton *)[self.bottomView viewWithTag:4];
        [collectBtn addTarget:self action:@selector(tapCollect:) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)tapChat:(UIButton *)sender {
    if (self.chatBlock) {
        self.chatBlock(sender);
    }
}

- (void)tapCollect:(UIButton *)sender {
    if (self.collectBlock) {
        self.collectBlock(sender);
    }
}

- (CGSize)sizeThatFits:(CGSize)size {
    return CGSizeMake(SCREEN_WIDTH, kBottomViewHeight);
}

- (void)setupCaption {
    NSArray *nibs = [[NSBundle mainBundle] loadNibNamed:@"KGPicBottom" owner:self options:nil];
    self.bottomView = nibs[0];
    [self addSubview:self.bottomView];
}

@end
