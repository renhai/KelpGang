//
//  AppStartup.m
//  KelpGang
//
//  Created by Andy on 14-7-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "AppStartup.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPManager.h"

@implementation AppStartup

+ (void)startup: (AppStartupType)type {
    NSArray *startupBlocks = nil;
    switch (type) {
        case APPSTARTUP_LAUNCH:
            if ([APPCONTEXT checkLogin]) {
                startupBlocks = @[[[AppStartup autoLoginBlock] copy],
                                  [[AppStartup xmppInitBlock] copy],
                                  [[AppStartup moveDBFileToSandboxBlock] copy]];
            }
            break;
        case APPSTARTUP_BACKGROUND:
            if ([APPCONTEXT checkLogin]) {
                startupBlocks = @[[[AppStartup autoLoginBlock] copy],
                                  [[AppStartup xmppConnectBlock] copy],];
            }
            break;
        case APPSTARTUP_AFTER_LOGIN:
            if ([APPCONTEXT checkLogin]) {
                startupBlocks = @[[[AppStartup xmppConnectBlock] copy]];
            }
            break;
        default:
            break;
    }


    dispatch_queue_t startupQueue = dispatch_queue_create("com.renren.kelpgang.startup", NULL);

    for (VoidBlock startupBlock in startupBlocks) {
        dispatch_async(startupQueue, startupBlock);
    }

}

+ (VoidBlock)autoLoginBlock {
    VoidBlock loginBlock = ^{
        NSDictionary *params = @{@"account": APPCONTEXT.currUser.uname, @"password_md5": APPCONTEXT.currUser.password};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/home/login" params:params success:^(id responseObject) {
            if ([KGUtils checkResult:responseObject]) {
                NSDictionary *data = responseObject[@"data"];
                NSInteger userId = [data[@"id"] integerValue];
                NSString *sessionKey = data[@"session_key"];
                NSDictionary *info = data[@"user_info"];

                [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:kCurrentUserId];
                [[NSUserDefaults standardUserDefaults] setObject:sessionKey forKey:kCurrentSessionKey];
                [[NSUserDefaults standardUserDefaults] synchronize];

                if (!APPCONTEXT.currUser) {
                    APPCONTEXT.currUser = [[KGUserObject alloc] init];
                }
                APPCONTEXT.currUser.sessionKey = sessionKey;
                APPCONTEXT.currUser.uid = [[info objectForKey:@"user_id"] integerValue];
                APPCONTEXT.currUser.uname = [info objectForKey:@"account"];
                APPCONTEXT.currUser.nickName = [info objectForKey:@"user_name"];
                APPCONTEXT.currUser.avatarUrl = [info objectForKey:@"head_url"];
                APPCONTEXT.currUser.gender = [KGUtils convertGender:[info objectForKey:@"user_sex"]];
                APPCONTEXT.currUser.vip = [[info objectForKey:@"user_v"] boolValue];
                APPCONTEXT.currUser.level = [[info objectForKey:@"user_star"] integerValue];
                APPCONTEXT.currUser.intro = [info objectForKey:@"user_desc"];
                APPCONTEXT.currUser.cellPhone = [info objectForKey:@"user_phone"];
                APPCONTEXT.currUser.email = [info valueForKeyPath:@"user_email"];

                [APPCONTEXT userPersist];

            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    };
    return loginBlock;
}

+ (VoidBlock)xmppInitBlock {
    VoidBlock xmppBlock = ^{
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        XMPPManager *xmppmgr = [XMPPManager sharedInstance];
        [xmppmgr setupStream];
        [xmppmgr connect];
    };
    return xmppBlock;
}

+ (VoidBlock)xmppConnectBlock {
    VoidBlock xmppBlock = ^{
        [DDLog addLogger:[DDTTYLogger sharedInstance]];
        XMPPManager *xmppmgr = [XMPPManager sharedInstance];
        [xmppmgr connect];
    };
    return xmppBlock;
}

+ (VoidBlock)moveDBFileToSandboxBlock {
    VoidBlock block = ^{
        NSString *sourcesPath = [[NSBundle mainBundle] pathForResource:@"china_province_city_zone"ofType:@"sqlite"];

        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentPath = [paths objectAtIndex:0];
        NSString *desPath = [documentPath stringByAppendingPathComponent:@"china_province_city_zone.sqlite"];

        NSFileManager *fileManager = [NSFileManager defaultManager];
        if (![fileManager fileExistsAtPath:desPath]) {
            NSError *error ;
            if ([fileManager copyItemAtPath:sourcesPath toPath:desPath error:&error]) {
                NSLog(@"数据库移动成功");
            } else {
                NSLog(@"数据库移动失败");
            }
        }
    };
    return block;
}


@end
