//
//  KGBuyerDescriptionCell.m
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerDescriptionCell.h"
#import "KGUserObject.h"

@implementation KGBuyerDescriptionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel sizeToFit];
    self.vipImageView.left = self.nameLabel.right + 5;
}

- (void)setUserInfo: (KGUserObject *)userInfo {
    if (!userInfo) {
        userInfo = [[KGUserObject alloc] init];
    }
    self.nameLabel.text = userInfo.nickName;
    self.descLabel.text = userInfo.intro;
    self.vipImageView.hidden = !userInfo.isVip;
    [self configLevelView:userInfo.level];
    [self.headImgView setImageWithURL:[NSURL URLWithString:userInfo.avatarUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImgView.layer.cornerRadius = self.headImgView.width / 2;

}

- (void)configLevelView: (NSInteger) level {
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
