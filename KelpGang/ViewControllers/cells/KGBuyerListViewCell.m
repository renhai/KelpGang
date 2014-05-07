//
//  KGFindKelpViewCell.m
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerListViewCell.h"
#import "KGBuyerSummaryObject.h"
#import "UIImageView+WebCache.h"

@interface KGBuyerListViewCell ()

@property (nonatomic, strong) KGBuyerSummaryObject* summaryObj;

@end

@implementation KGBuyerListViewCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        
    }
    return  self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headImageView.top = 10;
    self.headImageView.left = 5;

    self.levelView.top = self.headImageView.bottom + 5;
    self.levelView.centerX = self.headImageView.centerX;

    [self.nameLabel sizeToFit];
    self.nameLabel.left = 5;
    self.nameLabel.top = self.headImageView.top;

    if ([@"" isEqualToString:self.summaryObj.fromCountry]) {
        self.fromCityLabel.hidden = YES;
        self.planeImgView.hidden = YES;
        [self.toCityLabel sizeToFit];
        self.toCityLabel.top = self.fromCityLabel.top;
        self.toCityLabel.left = self.nameLabel.left;
    } else {
        self.fromCityLabel.hidden = NO;
        self.planeImgView.hidden = NO;
        [self.fromCityLabel sizeToFit];
        self.fromCityLabel.left = self.nameLabel.left;
        self.fromCityLabel.top = self.headImageView.centerY - 3;

        self.planeImgView.left = self.fromCityLabel.right + 3;
        self.planeImgView.centerY = self.fromCityLabel.centerY;

        [self.toCityLabel sizeToFit];
        self.toCityLabel.top = self.fromCityLabel.top;
        self.toCityLabel.left = self.planeImgView.right + 3;
    }

    [self.descLabel sizeToFit];
    self.descLabel.width = 155;
    self.descLabel.left = self.nameLabel.left;
    self.descLabel.top = self.toCityLabel.bottom + 5;

    [self.durationLabel sizeToFit];
    self.durationLabel.left = 0;
    self.durationLabel.top = self.nameLabel.top;
}


- (void)setObject: (KGBuyerSummaryObject *)obj {
    self.summaryObj = obj;
    self.countryImgView.image = [UIImage imageNamed:obj.country];
    [self.headImageView setImageWithURL:[NSURL URLWithString:obj.avatarUrl] placeholderImage:[UIImage imageNamed:obj.gender == MALE ? kAvatarMale : kAvatarFemale]];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.nameLabel.text = obj.userName;
    self.nameLabel.textColor = obj.gender == FEMALE ? RGB(255, 133, 133) : RGB(114, 114, 114);
    [self configLevelView:obj.level];
    self.fromCityLabel.text = obj.fromCountry;
    self.toCityLabel.text = obj.toCountry;
    self.descLabel.text = obj.desc;
    self.durationLabel.text = obj.routeDuration;
}

- (void)configLevelView: (NSInteger)level {
    for (UIView *subView in self.levelView.subviews) {
        [subView removeFromSuperview];
    }
    self.levelView.height = 10;
    self.levelView.clipsToBounds = NO;
    NSInteger heartCount = ceil(level / 2.0);
    CGFloat margin = 1.0;
    BOOL isLastHeartFull = level % 2 == 0;
    CGFloat levelViewWidth = 0;
    for (NSInteger i = 0; i < heartCount; i ++) {
        UIImageView *heartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFullHeart]];
        if (i == heartCount - 1 && !isLastHeartFull) {
            heartView.image = [UIImage imageNamed:kHarfHeart];
        }
        heartView.left = (heartView.width + margin) * i;
        levelViewWidth = heartView.right;
        [self.levelView addSubview:heartView];
    }
    self.levelView.width = levelViewWidth;
}


@end
