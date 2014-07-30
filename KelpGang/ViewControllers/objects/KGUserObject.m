//
//  KGUserObject.m
//  KelpGang
//
//  Created by Andy on 14-4-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGUserObject.h"

@implementation KGUserObject

- (id)initWithCoder:(NSCoder *)aDecoder {
	if (self = [self init]) {
        self.uid = [[aDecoder decodeObjectForKey:@"uid"] integerValue];
        self.uname = [aDecoder decodeObjectForKey:@"uname"];
        self.gender = [[aDecoder decodeObjectForKey:@"gender"] integerValue];
        self.avatarUrl = [aDecoder decodeObjectForKey:@"avatarUrl"];
        self.sessionKey = [aDecoder decodeObjectForKey:@"sessionKey"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.uid] forKey:@"uid"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.sessionKey forKey:@"sessionKey"];
}

- (BOOL)isLogin{
    if (self.sessionKey && self.sessionKey.length > 0) {
        return YES;
    }
    return NO;
}

@end
