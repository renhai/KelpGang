//
//  KGRatingAndCommentCell.h
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTableViewCell.h"

@class AMRatingControl;

@interface KGRatingCell : KGTableViewCell

@property (nonatomic, strong) AMRatingControl *ratingControl;

@end
