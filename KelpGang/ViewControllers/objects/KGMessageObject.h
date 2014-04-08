//
//  KGMessageObject.h
//  KelpGang
//
//  Created by Andy on 14-4-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    MessageTypeMe = 0,
    MessageTypeOther = 1
} MessageType;

@interface KGMessageObject : NSObject

@property (nonatomic,assign) NSInteger messageId;
@property (nonatomic,strong) NSString *from;
@property (nonatomic,strong) NSString *to;
@property (nonatomic,strong) NSString *content;
@property (nonatomic,strong) NSDate *date;
@property (nonatomic,assign) MessageType type;

@end
