//
//  KGChatObject.m
//  KelpGang
//
//  Created by Andy on 14-4-14.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatCellInfo.h"

@implementation KGChatCellInfo

- (id)initWithMessage:(KGMessageObject *) msg {
    self = [super init];
    if (self) {
        self.messageObj = msg;
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy.MM.dd HH:mm"];
        self.time = [dateFormatter stringFromDate:msg.date];
    }
    return self;
}

- (CGFloat)cellHeight {
    NSString *content = self.messageObj.content;
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGFloat cellHeight = labelSize.height + kMessageLabelMarginTop + kMessageLabelMarginBottom;

    if (self.showTime) {
        cellHeight += kTimeViewHeight;
    }

    return cellHeight;
}

-(MessageType)messageType {
    return self.messageObj.type;
}



@end
