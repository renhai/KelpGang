//
//  KGRecentContactObject.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRecentContactObject.h"

@implementation KGRecentContactObject

- (NSString *)lastMsgTime2Str {
    if (!self.lastMsgTime) {
        return @"";
    }
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"MM.dd"];
    return [formatter stringFromDate:self.lastMsgTime];
}


@end
