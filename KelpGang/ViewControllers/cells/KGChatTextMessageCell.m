//
//  KGChatMessageOtherCell.m
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTextMessageCell.h"
#import "KGMessageObject.h"
#import "KGChatObject.h"

static const CGFloat kBackgroundViewMarginTop = 8.0;
static const CGFloat kBackgroundViewMarginLeftOrRight = 5.0;
static const CGFloat kBackgroundViewPaddingLeftOrRight = 10.0;

static const CGFloat kHeaderImageMarginTop = 16.0;
static const CGFloat kHeaderImageMarginLeftOrRight = 14.0;
static const CGFloat kHeaderImageWidth = 25.0;
static const CGFloat kHeaderImageHeight = 25.0;


@implementation KGChatTextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [self.msgLabel.text sizeWithFont:self.msgLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat bgViewPaddingMsgLabelTopOrBottom = 13.0;
    CGFloat headerImageMarginMsgLabelLeftOrRight = 10.0;
    BOOL showTime = self.chatObj.showTime;
    [self.headView setTop:showTime ? kHeaderImageMarginTop + kTimeViewHeight : kHeaderImageMarginTop];
    [self.msgLabel setTop:showTime ? kMessageLabelMarginTop + kTimeViewHeight : kMessageLabelMarginTop];
    [self.bgView setTop:showTime ? kBackgroundViewMarginTop + kTimeViewHeight : kBackgroundViewMarginTop];
    if (self.chatObj.messageObj.type == MessageTypeOther) {
        [self.headView setLeft:kHeaderImageMarginLeftOrRight];

        [self.msgLabel setLeft:self.headView.right + headerImageMarginMsgLabelLeftOrRight];
        [self.msgLabel setSize:labelSize];
        self.msgLabel.textColor = RGBCOLOR(92, 92, 92);

        [self.bgView setLeft:kBackgroundViewMarginLeftOrRight];
        [self.bgView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.bgView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.msgLabel.height];
        self.bgView.backgroundColor = [UIColor whiteColor];
    } else if (self.chatObj.messageObj.type == MessageTypeMe) {
        [self.headView setLeft:SCREEN_WIDTH - kHeaderImageMarginLeftOrRight - kHeaderImageWidth];

        [self.msgLabel setLeft:self.headView.left - headerImageMarginMsgLabelLeftOrRight - labelSize.width];
        [self.msgLabel setSize:labelSize];
        self.msgLabel.textColor = RGBCOLOR(73, 73, 73);

        [self.bgView setLeft:self.msgLabel.left - headerImageMarginMsgLabelLeftOrRight];
        [self.bgView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.bgView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.msgLabel.height];
        self.bgView.backgroundColor = RGBCOLOR(189, 230, 224);

        [self.indicatorView setLeft:self.bgView.left - self.indicatorView.width - 3];
        [self.indicatorView setTop:self.bgView.top + (self.bgView.height - self.indicatorView.height) / 2];
    }
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configCell:(KGChatObject *) chatObj {
    [super configCell:chatObj];
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.layer.cornerRadius = 4;
    self.bgView = bgView;

    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.text = chatObj.messageObj.content;
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.numberOfLines = 0;
    self.msgLabel = msgLabel;

    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeaderImageWidth, kHeaderImageHeight)];
    headView.image = [UIImage imageNamed:@"test-head.jpg"];
    headView.clipsToBounds = YES;
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.layer.cornerRadius = headView.width / 2;
    self.headView = headView;

    [self addSubview:self.bgView];
    [self addSubview:self.msgLabel];
    [self addSubview:self.headView];
    if (chatObj.showTime) {
        UILabel *timeLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        timeLabel.backgroundColor = [UIColor clearColor];
        timeLabel.text = chatObj.time;
        timeLabel.textColor = [UIColor whiteColor];
        timeLabel.font = [UIFont systemFontOfSize:10];
        [timeLabel sizeToFit];
        UIView *timeView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, timeLabel.width + 10, timeLabel.height + 6)];
        timeView.backgroundColor = RGBACOLOR(0, 0, 0, 0.12);
        timeView.layer.cornerRadius = 4;
        timeView.left = (self.width - timeView.width) / 2;
        [timeView addSubview:timeLabel];
        timeLabel.left = (timeView.width - timeLabel.width) / 2;
        timeLabel.top = (timeView.height - timeLabel.height) / 2;
        [self addSubview:timeView];
    }
}

@end
