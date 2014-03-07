//
//  KGUtils.m
//  KelpGang
//
//  Created by Andy on 14-3-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGUtils.h"

@implementation KGUtils

+ (BOOL)isHigherIOS7
{
    NSString *requestSysVer = @"7.0";
    NSString *currentSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currentSysVer compare:requestSysVer options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }

    return YES;
}

@end
