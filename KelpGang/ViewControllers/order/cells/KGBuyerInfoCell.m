//
//  KGBuyerInfoCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerInfoCell.h"
#import "KGUserObject.h"

@implementation KGBuyerInfoCell


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);

        self.headImgView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        self.headImgView.layer.cornerRadius = self.headImgView.width / 2;
        self.headImgView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImgView.clipsToBounds = YES;

        self.nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel.backgroundColor = CLEARCOLOR;

        self.vipImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"v-user-icon"]];

        self.levelView = [[UIView alloc] initWithFrame:CGRectZero];

        self.descLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        self.descLabel.font = [UIFont systemFontOfSize:12];
        self.descLabel.textColor = RGB(149, 148, 148);
        self.descLabel.backgroundColor = CLEARCOLOR;
        self.descLabel.numberOfLines = 2;
        self.descLabel.width = 210;

        self.followButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 55, 20)];
        [self.followButton setBackgroundImage:[UIImage imageNamed:@"follow-btn-bg"] forState:UIControlStateNormal];
        [self.followButton.titleLabel setFont:[UIFont systemFontOfSize:12]];
        [self.followButton setTitleColor:MAIN_COLOR forState:UIControlStateNormal];

        [self addSubview:self.headImgView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.vipImageView];
        [self addSubview:self.levelView];
        [self addSubview:self.descLabel];
        [self addSubview:self.followButton];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel sizeToFit];
    self.nameLabel.top = self.headImgView.top;
    self.nameLabel.left = self.headImgView.right + 15;

    self.vipImageView.left = self.nameLabel.right + 5;
    self.vipImageView.centerY = self.nameLabel.centerY;

    self.levelView.left = self.nameLabel.left;
    self.levelView.top = self.nameLabel.bottom + 10;

    [self.descLabel sizeToFit];
    self.descLabel.top = self.levelView.bottom + 10;
    self.descLabel.left = self.nameLabel.left;

    self.followButton.centerX = self.headImgView.centerX;
    self.followButton.top = self.headImgView.bottom + 5;
}

- (void)setObject:(id)object {
    [super setObject:object];

    KGUserObject *buyer = object;
    [self.headImgView setImageWithURL:[NSURL URLWithString:buyer.avatarUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nameLabel.text = buyer.nickName;
    self.nameLabel.textColor = buyer.gender == MALE ? MAIN_COLOR : RGB(255, 133, 133);
    self.descLabel.text = buyer.intro;
    self.vipImageView.hidden = !buyer.isVip;
    [self configLevelView:buyer.level];
    [self setNeedsLayout];
}

- (void)configLevelView: (NSInteger) level {
    if (level > 10) {
        level = 10;
    }
    for (UIView *subView in self.levelView.subviews) {
        [subView removeFromSuperview];
    }
    self.levelView.clipsToBounds = NO;
    self.levelView.height = 10;
    NSInteger heartCount = ceil(level / 2.0);
    CGFloat margin = 2.0;
    BOOL isLastHeartFull = level % 2 == 0;
    for (NSInteger i = 0; i < heartCount; i ++) {
        UIImageView *heartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFullHeart]];
        if (i == heartCount - 1 && !isLastHeartFull) {
            heartView.image = [UIImage imageNamed:kHarfHeart];
        }
        heartView.left = (heartView.width + margin) * i;
        [self.levelView addSubview:heartView];
    }
}

@end
