//
//  AppContext.m
//  KelpGang
//
//  Created by Andy on 14-6-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "AppContext.h"
#import "KGUserObject.h"

@implementation AppContext

+(AppContext *)sharedInstance {
    static AppContext *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AppContext alloc] init];
    });
    return _instance;
}

- (BOOL)checkLogin
{
    if (APPCONTEXT.currUser && [APPCONTEXT.currUser isLogin]) {
        return YES;
    }

    return NO;
}

@end
