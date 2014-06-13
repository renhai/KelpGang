//
//  KGBuyerCommentCell.m
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerCommentCell.h"

@implementation KGBuyerCommentCell

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

    // Configure the view for the selected state
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setcommentInfo: (NSDictionary *)info {
    self.commentLabel.text = info[@"comment_content"];
    NSString *userName = @"未知用户";
    NSString *headUrl = @"";
    NSDictionary *user_info = info[@"user_info"];
    if (user_info) {
        userName = user_info[@"user_name"];
        headUrl = user_info[@"head_url"];
    }
    self.nameLabel.text = userName;
    self.headImgView.layer.cornerRadius = self.headImgView.width / 2;
    [self.headImgView setImageWithURL: [NSURL URLWithString:headUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

}

@end
