//
//  KGOrderImageCell.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderImageCell.h"

@implementation KGOrderImageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);

        self.defaultImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 60, 60)];
        self.descLbl = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 230, 60)];

        self.defaultImageView.contentMode = UIViewContentModeScaleAspectFill;
        self.defaultImageView.clipsToBounds = YES;
        self.defaultImageView.layer.borderWidth = 1;
        self.defaultImageView.layer.borderColor = RGB(199, 199, 200).CGColor;

        self.descLbl.textColor = RGB(114, 114, 114);
        self.descLbl.font = [UIFont systemFontOfSize:16];
        self.descLbl.backgroundColor = [UIColor clearColor];
        self.descLbl.lineBreakMode = NSLineBreakByTruncatingTail;
        self.descLbl.numberOfLines = 0;

        [self addSubview:self.defaultImageView];
        [self addSubview:self.descLbl];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    self.defaultImageView.left = 15;
    self.defaultImageView.centerY = self.height / 2;

    [self.descLbl sizeToFit];
    self.descLbl.origin = CGPointMake(self.defaultImageView.right + 5, self.defaultImageView.top);
    if (self.descLbl.height > 60) {
        self.descLbl.height = 60;
    }

}

- (void)setObject:(id)object {
    [super setObject:object];
    NSArray *arr = object;
    NSString *imageUrl = arr[0];
    if (!imageUrl) {
        imageUrl = @"";
    }
    NSString *taskTitle = arr[1];

    [self.defaultImageView setImageWithURL:[NSURL URLWithString:imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.descLbl.text = taskTitle;

    [self setNeedsLayout];
}

@end
