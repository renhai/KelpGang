//
//  KGMyCollectViewCell.m
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyCollectViewCell.h"
#import "KGCollectObject.h"

@implementation KGMyCollectViewCell

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
    self.goodsImageView.frame = CGRectMake(20, 15, 93, 93);

    [self.descLabel sizeToFit];
    self.descLabel.origin = CGPointMake(self.goodsImageView.right + 10, 30);

    [self.hotLabel sizeToFit];
    self.hotLabel.origin = CGPointMake(self.goodsImageView.right + 10, self.descLabel.bottom + 15);

    [self.hotValueLabel sizeToFit];
    self.hotValueLabel.left = self.hotLabel.right + 10;
    self.hotValueLabel.centerY = self.hotLabel.centerY;
}

- (void)setObject:(KGCollectObject *)obj {
    [self.goodsImageView setImageWithURL:[NSURL URLWithString:obj.goodsHeadUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.goodsImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.goodsImageView.clipsToBounds = YES;
    self.descLabel.text = obj.goodsName;
    self.descLabel.numberOfLines = 2;
    self.descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descLabel.width = 190;

    self.descLabel.font = [UIFont systemFontOfSize:16];
    self.descLabel.textColor = RGB(114, 114, 114);

    self.hotValueLabel.text = [NSString stringWithFormat:@"%d", obj.popularity];
    self.hotValueLabel.font = [UIFont systemFontOfSize:13];
    self.hotValueLabel.textColor = RGB(187, 187, 187);

    self.hotLabel.font = [UIFont systemFontOfSize:13];
    self.hotLabel.textColor = RGB(187, 187, 187);
    [self setNeedsLayout];
}

@end
