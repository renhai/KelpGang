//
//  KGRecentContactsCell.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRecentContactsCell.h"
#import "KGRecentContactObject.h"

static const CGFloat kCellHeight = 68;

@implementation KGRecentContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, kCellHeight)];
        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(44, 0, 232, kCellHeight)];
        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(276, 0, 44, kCellHeight)];

        leftView.backgroundColor = [UIColor whiteColor];
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectZero];
        headImageView.clipsToBounds = YES;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.headImageView = headImageView;
        [leftView addSubview: self.headImageView];
        UIImageView *badgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble-small"]];
        self.badgeView = badgeView;
        [leftView addSubview:self.badgeView];

        midView.backgroundColor = [UIColor whiteColor];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.font = [UIFont systemFontOfSize:16];
        self.nameLabel = nameLabel;
        [midView addSubview:self.nameLabel];
        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.textColor = RGB(137, 137, 137);
        messageLabel.font = [UIFont systemFontOfSize:13];
        self.messageLabel = messageLabel;
        [midView addSubview:self.messageLabel];

        rightView.backgroundColor = [UIColor whiteColor];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.textColor = RGB(187, 187, 187);
        timeLabel.font = [UIFont systemFontOfSize:12];
        self.timeLabel = timeLabel;
        [rightView addSubview:self.timeLabel];

        [self addSubview:leftView];
        [self addSubview:midView];
        [self addSubview: rightView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headImageView.frame = CGRectMake(14, 15, 25, 25);
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.badgeView.top = 14;
    self.badgeView.left = 33;

    [self.nameLabel sizeToFit];
    self.nameLabel.top = 18;
    self.nameLabel.left = 0;

    [self.messageLabel sizeToFit];
    self.messageLabel.top = 41;
    self.messageLabel.left = 0;
    self.messageLabel.width = 230;

    [self.timeLabel sizeToFit];
    self.timeLabel.top = 23;
    self.timeLabel.left = 0;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configCell: (KGRecentContactObject *)contactObj {
    self.contactObj = contactObj;
    UIImage *placeHolderImg = self.contactObj.gender == MALE ? [UIImage imageNamed:kAvatarMale] : [UIImage imageNamed:kAvatarFemale];
    [self.headImageView sd_setImageWithURL:[NSURL URLWithString:self.contactObj.headUrl]placeholderImage:placeHolderImg];

    self.badgeView.hidden = self.contactObj.hasRead;

    self.nameLabel.text = contactObj.uname;
    self.nameLabel.textColor = contactObj.gender == MALE ? MAIN_COLOR : HexRGB(0xff8585);
    self.messageLabel.text = contactObj.lastMsg;
    self.timeLabel.text = [contactObj lastMsgTime2Str];
}


@end
