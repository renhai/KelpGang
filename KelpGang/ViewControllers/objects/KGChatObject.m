//
//  KGChatObject.m
//  KelpGang
//
//  Created by Andy on 14-4-14.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatObject.h"
#import "KGMessageObject.h"

@implementation KGChatObject

- (id)initWithMessage:(KGMessageObject *) msg {
    self = [super init];
    if (self) {
        self.messageObj = msg;
        NSString *content = msg.content;
        CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
        CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        self.cellHeight = labelSize.height + kMessageLabelMarginTop + kMessageLabelMarginBottom;
    }
    return self;
}

@end
