//
//  KGCompletedOrderPhotoInfoCell.m
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderPhotoInfoCell.h"

@implementation KGCompletedOrderPhotoInfoCell

- (void)dealloc {
    NSLog(@"i am dead.");
}

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
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.orderImageView.left = 15;
    self.orderImageView.centerY = self.height / 2;

    self.orderDescLabel.left = self.orderImageView.right + 10;
    self.orderDescLabel.top = self.orderImageView.top;
    self.orderDescLabel.width = 225;
    self.orderDescLabel.numberOfLines = 3;
    [self.orderDescLabel sizeToFit];
}

- (void)setOrderImage: (NSString *)url desc: (NSString *)desc {
    [self.orderImageView setImageWithURL:[NSURL URLWithString:url] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.orderImageView.layer.borderColor = RGBCOLOR(187, 187, 187).CGColor;
    self.orderImageView.layer.borderWidth = 1;
    self.orderDescLabel.text = desc;
}


@end
