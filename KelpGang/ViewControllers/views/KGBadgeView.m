//
//  KGBadgeView.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBadgeView.h"

@interface KGBadgeView()

@property(nonatomic, strong) UIImageView *badgeImageView;
@property(nonatomic, strong) UILabel *badgeLabel;

@end

@implementation KGBadgeView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self initSubView];
    }
    return self;
}

- (void)initSubView {
    self.backgroundColor = [UIColor clearColor];
    self.badgeImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.badgeImageView.image = [UIImage imageNamed:@"bubble-big"];
    [self addSubview:self.badgeImageView];

    self.badgeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
    self.badgeLabel.backgroundColor = [UIColor clearColor];
    self.badgeLabel.textAlignment = NSTextAlignmentCenter;
    self.badgeLabel.textColor = [UIColor whiteColor];
    self.badgeLabel.font = [UIFont systemFontOfSize:16];
    self.badgeLabel.text = @"0";
    [self addSubview:self.badgeLabel];
}

- (void)setBadgeValue: (NSInteger) value {
    self.badgeLabel.text = [NSString stringWithFormat:@"%d", value];
}

- (void)hidebadgeView {
    self.hidden = YES;
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
