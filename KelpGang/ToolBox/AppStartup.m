//
//  AppStartup.m
//  KelpGang
//
//  Created by Andy on 14-7-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "AppStartup.h"

@implementation AppStartup

+ (void)startup {
    if ([APPCONTEXT checkLogin]) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        });
    }

}

@end
