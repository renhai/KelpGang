//
//  KGChatMessageOtherCell.m
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTextMessageCell.h"
#import "KGMessageObject.h"

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
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [self.msgLabel.text sizeWithFont:self.msgLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat bgViewPaddingMsgLabelTopOrBottom = 13.0;
    CGFloat headerImageMarginMsgLabelLeftOrRight = 10.0;
    if (self.msgObj.type == MessageTypeOther) {
        [self.headView setLeft:kHeaderImageMarginLeftOrRight];
        [self.headView setTop:kHeaderImageMarginTop];

        [self.msgLabel setLeft:self.headView.right + headerImageMarginMsgLabelLeftOrRight];
        [self.msgLabel setTop:kMessageLabelMarginTop];
        [self.msgLabel setSize:labelSize];
        self.msgLabel.textColor = RGBCOLOR(92, 92, 92);

        [self.bgView setTop:kBackgroundViewMarginTop];
        [self.bgView setLeft:kBackgroundViewMarginLeftOrRight];
        [self.bgView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.bgView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.msgLabel.height];
        self.bgView.backgroundColor = [UIColor whiteColor];
    } else if (self.msgObj.type == MessageTypeMe) {
        [self.headView setLeft:SCREEN_WIDTH - kHeaderImageMarginLeftOrRight - kHeaderImageWidth];
        [self.headView setTop:kHeaderImageMarginTop];

        [self.msgLabel setLeft:self.headView.left - headerImageMarginMsgLabelLeftOrRight - labelSize.width];
        [self.msgLabel setTop:kMessageLabelMarginTop];
        [self.msgLabel setSize:labelSize];
        self.msgLabel.textColor = RGBCOLOR(73, 73, 73);

        [self.bgView setTop:kBackgroundViewMarginTop];
        [self.bgView setLeft:self.msgLabel.left - headerImageMarginMsgLabelLeftOrRight];
        [self.bgView setWidth:kBackgroundViewPaddingLeftOrRight * 2 + self.headView.width + headerImageMarginMsgLabelLeftOrRight + labelSize.width];
        [self.bgView setHeight:bgViewPaddingMsgLabelTopOrBottom * 2 + self.msgLabel.height];
        self.bgView.backgroundColor = RGBCOLOR(189, 230, 224);
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

- (void)configCell:(KGMessageObject *)msgObj {
    self.msgObj = msgObj;
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.layer.cornerRadius = 4;
    self.bgView = bgView;
    [self addSubview:self.bgView];

    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
    msgLabel.backgroundColor = [UIColor clearColor];
    msgLabel.text = msgObj.content;
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.numberOfLines = 0;
    self.msgLabel = msgLabel;
    [self addSubview:msgLabel];

    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kHeaderImageWidth, kHeaderImageHeight)];
    headView.image = [UIImage imageNamed:@"test-head.jpg"];
    headView.clipsToBounds = YES;
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.layer.cornerRadius = headView.width / 2;
    self.headView = headView;
    [self addSubview:self.headView];
}


@end
