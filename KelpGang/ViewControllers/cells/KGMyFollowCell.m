//
//  KGMyFollowCell.m
//  KelpGang
//
//  Created by Andy on 14-8-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyFollowCell.h"
#import "KGUserFollowObject.h"

@implementation KGMyFollowCell

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
    self.headImageView.origin = CGPointMake(15, 15);
    [self.nameLabel sizeToFit];
    self.nameLabel.left = self.headImageView.right + 5;
    self.nameLabel.top = 17;
    [self.descLabel sizeToFit];
    self.descLabel.width = 200;
    self.descLabel.left = self.nameLabel.left;
    self.descLabel.top = self.headImageView.bottom;
    self.followBtn.centerY = self.height / 2;
    self.followBtn.right = self.width - 15;
}

- (void)setObject:(KGUserFollowObject *)obj {
    [self.headImageView setImageWithURL:[NSURL URLWithString:obj.avatarUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.nameLabel.text = obj.uname;
    if (obj.gender == FEMALE) {
        self.nameLabel.textColor = RGB(255, 133, 133);
    } else {
        self.nameLabel.textColor = MAIN_COLOR;
    }
    self.descLabel.text = obj.intro;
    [self.followBtn setTitle:obj.isFollowed ? @"取消关注" : @"关注" forState:UIControlStateNormal];
}

@end
