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
        self.time = [dateFormatter stringFromDate:msg.createTime];
    }
    return self;
}

- (CGFloat)cellHeight {
    NSString *content = self.messageObj.message;
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
//    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    CGRect newRect = [content boundingRectWithSize:constraint options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:16]} context:nil];
    CGSize labelSize = newRect.size;
    CGFloat cellHeight = labelSize.height + kMessageLabelMarginTop + kMessageLabelMarginBottom;

    if (self.showTime) {
        cellHeight += kTimeViewHeight;
    }

    return cellHeight;
}

-(ChatCellType)cellType {
    if (APPCONTEXT.currUser.uid == self.messageObj.fromUID) {
        return Me;
    } else {
        return Other;
    }
}



@end
