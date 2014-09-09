//
//  KGLocationObject.m
//  KelpGang
//
//  Created by Andy on 14-9-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLocationObject.h"

@implementation KGLocationObject

- (NSString *)locationString {
    if (!self.addressDictionary[@"Name"]) {
        NSString *location = [NSString stringWithFormat:@"经度 %@, 纬度 %@", [self.longitude stringValue], [self.latitude stringValue] ];
        return location;
    } else {
        return self.addressDictionary[@"Name"];
    }
}

@end
