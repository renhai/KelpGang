//
//  KGHostHeadViewCell.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostHeadViewCell.h"
#import "UIImageView+WebCache.h"

@implementation KGHostHeadViewCell

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
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

}

- (void)configCell {
    [self.headImageView setImageWithURL:[NSURL URLWithString:@"http://c.hiphotos.baidu.com/image/w%3D2048/sign=9d361bfa7b310a55c424d9f4837d43a9/a8014c086e061d95607bb63179f40ad162d9cafe.jpg"] placeholderImage: [UIImage imageNamed:@"avatar-male"]];
}


@end
