//
//  KGRecentContactsCell.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRecentContactsCell.h"
#import "KGRecentContactObject.h"
#import "UIImageView+WebCache.h"

static const CGFloat kCellHeight = 68;

@implementation KGRecentContactsCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier contactInfo: (KGRecentContactObject *)contactInfo {
    self = [self initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 44, kCellHeight)];
        [self addSubview:leftView];
        leftView.backgroundColor = [UIColor whiteColor];
        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(14, 15, 25, 25)];
        headImageView.clipsToBounds = YES;
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.layer.cornerRadius = headImageView.width / 2;
        UIImage *placeHolderImg = contactInfo.gender == MALE ? [UIImage imageNamed:@"avatar-male"] : [UIImage imageNamed:@"avatar-female"];
        [headImageView setImageWithURL:[NSURL URLWithString:contactInfo.headUrl]placeholderImage:placeHolderImg];
        self.headImageView = headImageView;
        [leftView addSubview: headImageView];
        UIImageView *badgeView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"bubble-small"]];
        badgeView.top = 14;
        badgeView.left = 33;
        badgeView.hidden = contactInfo.hasRead;
        self.badgeView = badgeView;
        [leftView addSubview:self.badgeView];

        UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(44, 0, 232, kCellHeight)];
        midView.backgroundColor = [UIColor whiteColor];
        [self addSubview:midView];
        UILabel *nameLabel = [[UILabel alloc] init];
        nameLabel.text = contactInfo.uname;
        nameLabel.textColor = contactInfo.gender == MALE ? MAIN_COLOR : HexRGB(0xff8585);
        nameLabel.font = [UIFont systemFontOfSize:16];
        [nameLabel sizeToFit];
        nameLabel.top = 18;
        nameLabel.left = 0;
        self.nameLabel = nameLabel;
        [midView addSubview:self.nameLabel];

        UILabel *messageLabel = [[UILabel alloc] init];
        messageLabel.text = contactInfo.lastMsg;
        messageLabel.textColor = RGB(137, 137, 137);
        messageLabel.font = [UIFont systemFontOfSize:13];
        [messageLabel sizeToFit];
        messageLabel.top = 41;
        messageLabel.left = 0;
        messageLabel.width = 230;
        self.messageLabel = messageLabel;
        [midView addSubview:self.messageLabel];

        UIView *rightView = [[UIView alloc] initWithFrame:CGRectMake(276, 0, 44, kCellHeight)];
        rightView.backgroundColor = [UIColor whiteColor];
        [self addSubview: rightView];
        UILabel *timeLabel = [[UILabel alloc] init];
        timeLabel.text = [contactInfo lastMsgTime2Str];
        timeLabel.textColor = RGB(187, 187, 187);
        timeLabel.font = [UIFont systemFontOfSize:12];
        [timeLabel sizeToFit];
        timeLabel.top = 23;
        timeLabel.left = 0;
        self.timeLabel = timeLabel;
        [rightView addSubview:self.timeLabel];
    }
    return self;
}


//- (void)layoutSubviews {
//    [super layoutSubviews];
//}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
