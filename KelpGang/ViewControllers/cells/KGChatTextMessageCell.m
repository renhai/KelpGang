//
//  KGChatMessageOtherCell.m
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTextMessageCell.h"
#import "KGMessageObject.h"

@implementation KGChatTextMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {

    }
    return self;
}

- (void)layoutSubviews {
    [self.msgLabel setLeft:self.headView.right + kHeaderImageMarginRight];
    [self.msgLabel setTop:kMessageLabelMarginTop];

    [self.bgView setTop:kBackgroundViewMarginTop];
    [self.bgView setLeft:kBackgroundViewMarginLeft];
    [self.bgView setWidth:self.msgLabel.right + kMessageLabelMarginRight - kBackgroundViewMarginLeft];
    [self.bgView setHeight:kBackgroundViewPaddingTop + self.msgLabel.height + kBackgroundViewPaddingBottom];
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
    UIView *bgView = [[UIView alloc] initWithFrame:CGRectZero];
    bgView.layer.cornerRadius = 4;
    bgView.backgroundColor = [UIColor whiteColor];
    self.bgView = bgView;
    [self addSubview:self.bgView];

    UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
//    msgLabel.backgroundColor = [UIColor redColor];
    msgLabel.text = msgObj.content;
    msgLabel.textColor = RGBCOLOR(92, 92, 92);
    msgLabel.font = [UIFont systemFontOfSize:16];
    msgLabel.numberOfLines = 0;
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [msgLabel.text sizeWithFont:msgLabel.font constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    msgLabel.frame = CGRectMake(0, 0, labelSize.width, labelSize.height);
    self.msgLabel = msgLabel;
    [self addSubview:msgLabel];

    UIImageView *headView = [[UIImageView alloc]initWithFrame:CGRectMake(kHeaderImageMarginLeft, kHeaderImageMarginTop, kHeaderImageWidth, kHeaderImageHeight)];
    headView.image = [UIImage imageNamed:@"test-head.jpg"];
    headView.clipsToBounds = YES;
    headView.contentMode = UIViewContentModeScaleAspectFill;
    headView.layer.cornerRadius = headView.width / 2;
    self.headView = headView;
    [self addSubview:self.headView];
}


@end
