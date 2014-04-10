//
//  KGChatTipCell.m
//  KelpGang
//
//  Created by Andy on 14-4-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTipCell.h"

@implementation KGChatTipCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        UIView *view = [[UIView alloc] initWithFrame:CGRectMake(81, 15, 158, 30)];
        view.backgroundColor = RGBACOLOR(0, 0, 0, 0.12);
        view.layer.cornerRadius = 4;

        UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        topLabel.backgroundColor = [UIColor clearColor];
        topLabel.text = @"可以开始聊天了";
        topLabel.textColor = [UIColor whiteColor];
        topLabel.font = [UIFont systemFontOfSize:10];
        [topLabel sizeToFit];
        [topLabel setTop:2];
        [topLabel setLeft:(view.width - topLabel.width) / 2.0];
        [view addSubview:topLabel];

        UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        bottomLabel.backgroundColor = [UIColor clearColor];
        bottomLabel.text = @"别忘了填写商品信息生成订单哦";
        bottomLabel.textColor = [UIColor whiteColor];
        bottomLabel.font = [UIFont systemFontOfSize:10];
        [bottomLabel sizeToFit];
        [bottomLabel setTop:topLabel.bottom + 2];
        [bottomLabel setLeft:(view.width - bottomLabel.width) / 2.0];
        [view addSubview:bottomLabel];
        [self addSubview:view];

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
