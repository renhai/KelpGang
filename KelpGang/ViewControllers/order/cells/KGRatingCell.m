//
//  KGRatingAndCommentCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRatingCell.h"
#import "AMRatingControl.h"

@implementation KGRatingCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UILabel *ratingLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        ratingLbl.text = @"评分:";
        ratingLbl.backgroundColor = CLEARCOLOR;
        ratingLbl.textColor = RGB(197, 197, 197);
        ratingLbl.font = [UIFont systemFontOfSize:16];
        [ratingLbl sizeToFit];
        ratingLbl.origin = CGPointMake(15, 15);

        self.ratingControl = [[AMRatingControl alloc] initWithLocation:CGPointZero emptyImage:[UIImage imageNamed: @"big-empty-heart"] solidImage:[UIImage imageNamed: @"big-full-heart"] andMaxRating:5];
        self.ratingControl.starSpacing = 5;
        self.ratingControl.left = ratingLbl.right + 10;
        self.ratingControl.centerY = ratingLbl.centerY;
        self.ratingControl.starWidthAndHeight = 27;
        self.ratingControl.rating = kDefaultRate;

        [self addSubview:ratingLbl];
        [self addSubview:self.ratingControl];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

}

- (void)setObject:(id)object {
    [super setObject:object];

    [self setNeedsLayout];
}


@end
