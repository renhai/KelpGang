//
//  KGChatMessageOtherCell.m
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatMessageOtherCell.h"

@implementation KGChatMessageOtherCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *bgView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 150, 50)];
        bgView.layer.cornerRadius = 4;
        bgView.backgroundColor = [UIColor whiteColor];
        self.bgView = bgView;
        [self addSubview:self.bgView];

        UILabel *msgLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        msgLabel.text = @"要32G的还是16G的";
        msgLabel.textColor = RGBCOLOR(92, 92, 92);
        msgLabel.font = [UIFont systemFontOfSize:16];
        [msgLabel sizeToFit];
        self.msgLabel = msgLabel;
        [self addSubview:msgLabel];
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

    // Configure the view for the selected state
}

@end
