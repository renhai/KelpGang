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
        self.vip = [[aDecoder decodeObjectForKey:@"isVip"] boolValue];
        self.level = [[aDecoder decodeObjectForKey:@"level"] integerValue];
        self.followCount = [[aDecoder decodeObjectForKey:@"followCount"] integerValue];
        self.nickName = [aDecoder decodeObjectForKey:@"nickName"];
        self.intro = [aDecoder decodeObjectForKey:@"intro"];
        self.cellPhone = [aDecoder decodeObjectForKey:@"cellPhone"];
        self.email = [aDecoder decodeObjectForKey:@"email"];
        self.password = [aDecoder decodeObjectForKey:@"password"];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder {
    [aCoder encodeObject:[NSNumber numberWithInteger:self.uid] forKey:@"uid"];
    [aCoder encodeObject:self.uname forKey:@"uname"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.gender] forKey:@"gender"];
    [aCoder encodeObject:self.avatarUrl forKey:@"avatarUrl"];
    [aCoder encodeObject:self.sessionKey forKey:@"sessionKey"];
    [aCoder encodeObject:[NSNumber numberWithBool:self.isVip] forKey:@"isVip"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.level] forKey:@"level"];
    [aCoder encodeObject:[NSNumber numberWithInteger:self.followCount] forKey:@"followCount"];
    [aCoder encodeObject:self.nickName forKey:@"nickName"];
    [aCoder encodeObject:self.intro forKey:@"intro"];
    [aCoder encodeObject:self.cellPhone forKey:@"cellPhone"];
    [aCoder encodeObject:self.email forKey:@"email"];
    [aCoder encodeObject:self.password forKey:@"password"];
}

- (id)init {
    self = [super init];
    if (self) {
        self.uname = @"";
        self.avatarUrl = @"";
        self.nickName = @"";
        self.intro = @"";
        self.cellPhone = @"";
        self.email = @"";
        self.password = @"";
        self.sessionKey = @"";
    }
    return self;
}

- (BOOL)isLogin{
    if (self.sessionKey && self.sessionKey.length > 0) {
        return YES;
    }
    return NO;
}

@end
