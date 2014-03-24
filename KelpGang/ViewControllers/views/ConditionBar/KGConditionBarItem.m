//
//  KGConditionBarItem.m
//  KelpGang
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGConditionBarItem.h"

static CGFloat const kMaxTextLabelWidth = 90.0;
static CGFloat const kArrowMarginLeft = 4.0;

@implementation KGConditionBarItem

- (void)dealloc
{
    
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (void) relayout {
    CGFloat width = self.frame.size.width;
    CGFloat height = self.frame.size.height;
    CGSize textSize = [self.textLabel.text sizeWithFont:[UIFont systemFontOfSize:15.0] constrainedToSize:CGSizeMake(MAXFLOAT, 30)];
    textSize.width = (textSize.width < kMaxTextLabelWidth) ? textSize.width : kMaxTextLabelWidth;
    CGFloat textX = (width - textSize.width) / 2;
    CGFloat textY = (height - textSize.height) / 2;
    CGRect textFrame = self.textLabel.frame;
    textFrame.origin = CGPointMake(textX, textY);
    textFrame.size = textSize;
    self.textLabel.frame = textFrame;

    CGRect arrowFrame = self.arrowImgView.frame;
    CGFloat arrowX = textX + textSize.width + kArrowMarginLeft;
    CGFloat arrowY = (height - arrowFrame.size.height) / 2;
    arrowFrame.origin = CGPointMake(arrowX, arrowY);
    self.arrowImgView.frame = arrowFrame;
}

- (void)openItem {
    UIImage *arrowUpImg = [UIImage imageNamed:@"arrow-up"];
    [self.arrowImgView setImage:arrowUpImg];
    [self.indImgView setHidden:NO];
}
- (void)closeItem {
    UIImage *arrowDownImg = [UIImage imageNamed:@"arrow-down"];
    [self.arrowImgView setImage:arrowDownImg];
    [self.indImgView setHidden:YES];
}


@end
