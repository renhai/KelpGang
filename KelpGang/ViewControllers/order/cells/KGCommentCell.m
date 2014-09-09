//
//  KGCommentCell.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentCell.h"

@implementation KGCommentCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UILabel *commentLbl = [[UILabel alloc] initWithFrame:CGRectZero];
        commentLbl.text = @"评价:";
        commentLbl.backgroundColor = CLEARCOLOR;
        commentLbl.textColor = RGB(197, 197, 197);
        commentLbl.font = [UIFont systemFontOfSize:16];
        [commentLbl sizeToFit];
        commentLbl.origin = CGPointMake(15, 10);

        self.commentTV = [[GCPlaceholderTextView alloc] initWithFrame:CGRectMake(commentLbl.right + 5, commentLbl.top, 250, 80)];
        self.commentTV.layer.borderWidth = 1;
        self.commentTV.layer.borderColor = RGB(214, 222, 226).CGColor;
        self.commentTV.layer.cornerRadius = 5;
        self.commentTV.textColor = MAIN_COLOR;
        self.commentTV.font = [UIFont systemFontOfSize:16];
        self.commentTV.placeholder = kDefaultComment;

        [self addSubview:commentLbl];
        [self addSubview:self.commentTV];
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
