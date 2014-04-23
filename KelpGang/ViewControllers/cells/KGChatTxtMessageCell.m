//
//  KGChatTxtMessageCell.m
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTxtMessageCell.h"
#import "KGChatCellInfo.h"


static const CGFloat kBackgroundViewMarginTop = 8.0;
static const CGFloat kBackgroundViewMarginLeftOrRight = 5.0;
static const CGFloat kBackgroundViewPaddingLeftOrRight = 10.0;

static const CGFloat kHeaderImageMarginTop = 16.0;
static const CGFloat kHeaderImageMarginLeftOrRight = 14.0;

@implementation KGChatTxtMessageCell

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
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [self.messageLabel.text sizeWithFont:self.messageLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat bgViewPaddingMsgLabelTopOrBottom = 13.0;
    CGFloat headerImageMarginMsgLabelLeftOrRight = 10.0;
    BOOL showTime = self.chatCellInfo.showTime;
    [self.headImageView setTop:showTime ? kHeaderImageMarginTop + kTimeViewHeight : kHeaderImageMarginTop];
    [self.messageLabel setTop:showTime ? kMessageLabelMarginTop + kTimeViewHeight : kMessageLabelMarginTop];
    [self.backView setTop:showTime ? kBackgroundViewMarginTop + kTimeViewHeight : kBackgroundViewMarginTop];
    if (self.chatCellInfo.messageType == MessageTypeOther) {
        [self.headImageView setLeft:kHeaderImageMarginLeftOrRight];

        [self.messageLabel setLeft:self.headImageView.right + headerImageMarginMsgLabelLeftOrRight];
        [self.messageLabel setSize:labelSize];
        self.messageLabel.textColor = RGBCOLOR(92, 92, 92);

        [self.backView setLeft:kBackgroundViewMarginLeftOrRight];
        [self.backView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headImageView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.backView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.messageLabel.height];
        self.backView.backgroundColor = [UIColor whiteColor];
    } else if (self.chatCellInfo.messageType == MessageTypeMe) {
        [self.headImageView setLeft:SCREEN_WIDTH - kHeaderImageMarginLeftOrRight - self.headImageView.width];

        [self.messageLabel setLeft:self.headImageView.left - headerImageMarginMsgLabelLeftOrRight - labelSize.width];
        [self.messageLabel setSize:labelSize];
        self.messageLabel.textColor = RGBCOLOR(73, 73, 73);

        [self.backView setLeft:self.messageLabel.left - headerImageMarginMsgLabelLeftOrRight];
        [self.backView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headImageView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.backView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.messageLabel.height];
        self.backView.backgroundColor = RGBCOLOR(189, 230, 224);

//        [self.indicatorView setLeft:self.bgView.left - self.indicatorView.width - 3];
//        [self.indicatorView setTop:self.bgView.top + (self.bgView.height - self.indicatorView.height) / 2];
    }
    if (self.chatCellInfo.showTime) {
        self.timeView.hidden = NO;
        [self.timeLabel sizeToFit];
        self.timeView.width = self.timeLabel.width + 10;
        self.timeView.height = self.timeLabel.height + 6;
        self.timeView.left = (self.width - self.timeView.width) / 2;
        self.timeLabel.left = (self.timeView.width - self.timeLabel.width) / 2;
        self.timeLabel.top = (self.timeView.height - self.timeLabel.height) / 2;
    }

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)configCell:(KGChatCellInfo *)chatCellInfo {
    self.chatCellInfo = chatCellInfo;
    [self.contentView sendSubviewToBack:self.backView];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.backView.layer.cornerRadius = 4;
    self.timeView.layer.cornerRadius = 4;
    self.messageLabel.text = chatCellInfo.messageObj.content;
    self.timeView.hidden = YES;
    self.timeLabel.text = chatCellInfo.time;
}

@end
