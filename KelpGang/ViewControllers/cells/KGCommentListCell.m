//
//  KGCommentListCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentListCell.h"
#import "KGCommentObject.h"


@implementation KGCommentListCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.headImageView.origin = CGPointMake(15, 15);

    [self.nameLabel sizeToFit];
    self.nameLabel.left = self.headImageView.right + 5;
    self.nameLabel.centerY = self.headImageView.centerY - 3;

    self.levelView.height = 10;
    self.levelView.right = self.width - 45;
    self.levelView.centerY = self.nameLabel.centerY;

    [self.timeLabel sizeToFit];
    self.timeLabel.left = self.levelView.right + 5;
    self.timeLabel.top = self.nameLabel.top;

    [self.commentLabel sizeToFit];
    self.commentLabel.top = self.headImageView.bottom;
    self.commentLabel.left = self.nameLabel.left;
    if (self.commentLabel.height > 32) {
        self.commentLabel.height = 32;
    }
}

- (void)setObject:(id)object {
    [super setObject:object];
    KGCommentObject *commentObj = object;
    [self.headImageView setImageWithURL:[NSURL URLWithString:commentObj.fromUserHeadUrl] placeholderImage:[UIImage imageNamed:kAvatarMale] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    self.nameLabel.text = commentObj.fromUserName;
    self.commentLabel.text = commentObj.content;
    [self configLevelView:commentObj.star];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M.d"];
    self.timeLabel.text = [formatter stringFromDate:commentObj.createTime];
}

- (void)configLevelView: (NSInteger) level {
    for (UIView *subView in self.levelView.subviews) {
        [subView removeFromSuperview];
    }
    self.levelView.clipsToBounds = NO;
    self.levelView.backgroundColor = CLEARCOLOR;
    if (level > 5) {
        level = 5;
    }
    CGFloat margin = 2.0;
    CGFloat totalWidth = 0;
    for (NSInteger i = 0; i < level; i ++) {
        UIImageView *heartView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:kFullHeart]];
        heartView.left = (heartView.width + margin) * i;
        totalWidth = heartView.right;
        [self.levelView addSubview:heartView];
    }
    self.levelView.width = totalWidth;
}

@end
