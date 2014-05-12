//
//  KGHostHeadViewCell.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostHeadViewCell.h"
#import "KGUserObject.h"

@interface KGHostHeadViewCell()

@property (nonatomic, strong) KGUserObject *user;

@end

@implementation KGHostHeadViewCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel sizeToFit];
    self.vipImageView.left = self.nameLabel.right + 10;
    [self.followLabel sizeToFit];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configCell: (KGUserObject *)user {
    self.user = user;
    [self.headImageView setImageWithURL:[NSURL URLWithString:user.avatarUrl] placeholderImage: [UIImage imageNamed:user.gender == MALE ? kAvatarMale : kAvatarFemale]];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.nameLabel.text = user.uname;
    self.vipImageView.hidden = !user.isVip;
    [self configLevelView];
    NSString *followText = [NSString stringWithFormat:@"关注%i人", user.followCount];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: followText];
    [attrString addAttribute: NSForegroundColorAttributeName value: MAIN_COLOR range: [followText rangeOfString:I2S(user.followCount)]];
    self.followLabel.attributedText = attrString;
}

- (void)configLevelView {
    for (UIView *subView in self.levelView.subviews) {
        [subView removeFromSuperview];
    }
    self.levelView.clipsToBounds = NO;
    NSInteger level = self.user.level;
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
