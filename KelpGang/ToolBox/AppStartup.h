//
//  AppStartup.h
//  KelpGang
//
//  Created by Andy on 14-7-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum _AppStartupType{
    APPSTARTUP_LAUNCH,  // 正常启动
    APPSTARTUP_BACKGROUND,  // 后台启动
    APPSTARTUP_AFTER_LOGIN,   // 登录后
}AppStartupType;

@interface AppStartup : NSObject

+ (void)startup: (AppStartupType) type;

@end
