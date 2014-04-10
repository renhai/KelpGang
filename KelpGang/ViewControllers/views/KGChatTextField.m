//
//  KGChatTextField.m
//  KelpGang
//
//  Created by Andy on 14-4-10.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatTextField.h"

static const CGFloat kTextFieldPaddingWidth = 10.0;
static const CGFloat kTextFieldPaddingHeight = 0.0;

@implementation KGChatTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (CGRect)textRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,
                       self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx,
                       self.dy == 0.0f ? kTextFieldPaddingHeight : self.dy);
}

- (CGRect)editingRectForBounds:(CGRect)bounds
{
    return CGRectInset(bounds,
                       self.dx == 0.0f ? kTextFieldPaddingWidth : self.dx,
                       self.dy == 0.0f ? kTextFieldPaddingHeight : self.dy);
}

- (void)setDx:(CGFloat)dx
{
    _dx = dx;
    [self setNeedsDisplay];
}

- (void)setDy:(CGFloat)dy
{
    _dy = dy;
    [self setNeedsDisplay];
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
