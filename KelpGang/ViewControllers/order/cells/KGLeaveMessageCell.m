//
//  KGLeaveMessageCell.m
//  KelpGang
//
//  Created by Andy on 14-9-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLeaveMessageCell.h"

@implementation KGLeaveMessageCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        self.messageLeft = [[UILabel alloc] initWithFrame:CGRectZero];
        self.messageLeft.text = @"留言";
        self.messageLeft.textColor = RGB(187, 187, 187);
        self.messageLeft.font = [UIFont systemFontOfSize:13];
        self.messageLeft.backgroundColor = [UIColor clearColor];
        [self addSubview:self.messageLeft];

        self.messageRight = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 260, 40)];
        self.messageRight.textColor = RGB(114, 114, 114);
        self.messageRight.font = [UIFont systemFontOfSize:13];
        self.messageRight.backgroundColor = [UIColor clearColor];
        self.messageRight.lineBreakMode = NSLineBreakByTruncatingTail;
        self.messageRight.numberOfLines = 0;
        [self addSubview:self.messageRight];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];

    [self.messageLeft sizeToFit];
    self.messageLeft.origin = CGPointMake(15, 15);

    [self.messageRight sizeToFit];
    self.messageRight.origin = CGPointMake(self.messageLeft.right + 10, self.messageLeft.top);
    if (self.messageRight.height > 32) {
        self.messageRight.height = 32;
    }

}

- (void)setObject:(id)object {
    [super setObject:object];
    NSString *message = object;
    if (!message) {
        message = @"";
    }
    self.messageRight.text = message;
    [self setNeedsLayout];
}

@end
