//
//  KGRecentContactObject.h
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGRecentContactObject : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, strong) NSString *headUrl;
@property (nonatomic, strong) NSString *lastMsg;
@property (nonatomic, strong) NSDate * lastMsgTime;
@property (nonatomic, assign) BOOL hasRead;

- (NSString *)lastMsgTime2Str;

@end
