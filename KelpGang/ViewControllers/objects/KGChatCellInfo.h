//
//  KGChatObject.h
//  KelpGang
//
//  Created by Andy on 14-4-14.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "KGMessageObject.h"

typedef enum {
    Me = 0,
    Other = 1
} ChatCellType;

static const CGFloat kMessageLableMaxWidth = 240.0;
static const CGFloat kMessageLabelMarginTop = 21.0;
static const CGFloat kMessageLabelMarginBottom = 21.0;
static const CGFloat kTimeViewHeight = 28.0;

@interface KGChatCellInfo : NSObject

@property (nonatomic, strong) KGMessageObject *messageObj;
@property (nonatomic, assign) BOOL showTime;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL showIndicator;

- (id)initWithMessage: (KGMessageObject *) msg;

- (CGFloat)cellHeight;

-(ChatCellType)cellType;

@end
