//
//  KGMessageObject.h
//  KelpGang
//
//  Created by Andy on 14-4-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum {
    TEXT = 0,
    PICTURE = 1,
    VOICE = 2
} MessageType;

@interface KGMessageObject : NSObject

@property (nonatomic,assign) NSInteger msgId;
@property (nonatomic,strong) NSString *uuid;
@property (nonatomic,assign) NSInteger fromUID;
@property (nonatomic,assign) NSInteger toUID;
@property (nonatomic,strong) NSString *fromName;
@property (nonatomic,strong) NSString *toName;
@property (nonatomic,strong) NSString *message;
@property (nonatomic,strong) NSDate *createTime;
@property (nonatomic,assign) MessageType msgType;
@property (nonatomic,assign) NSInteger hasRead;

@end
