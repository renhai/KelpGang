//
//  KGUserObject.m
//  KelpGang
//
//  Created by Andy on 14-4-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGUserObject.h"

@implementation KGUserObject

- (BOOL)isLogin{
    if (self.sessionKey && self.sessionKey.length > 0) {
        return YES;
    }
    return NO;
}

@end
