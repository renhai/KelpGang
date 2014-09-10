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
#import "FMDB.h"

@implementation AppStartup

+ (void)startup: (AppStartupType)type {
    NSArray *startupBlocks = nil;
    switch (type) {
        case APPSTARTUP_LAUNCH:
            if ([APPCONTEXT checkLogin]) {
                startupBlocks = @[[[AppStartup autoLoginBlock] copy],
                                  [[AppStartup xmppInitBlock] copy],
                                  [[AppStartup moveDBFileToSandboxBlock] copy],
                                  [[AppStartup createChatTableBlock] copy]];
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
                startupBlocks = @[[[AppStartup xmppInitBlock] copy],
                                  [[AppStartup moveDBFileToSandboxBlock] copy],
                                  [[AppStartup createChatTableBlock] copy]];
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
            if ([KGUtils checkResultWithAlert:responseObject]) {
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

+ (VoidBlock) createChatTableBlock {
    VoidBlock block = ^{

        NSString *dbFilePath = [KGUtils databaseFilePath];

        FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];

        //判断数据库是否已经打开，如果没有打开，提示失败
        if (![db open]) {
            NSLog(@"数据库打开失败");
            return;
        }

        //为数据库设置缓存，提高查询效率
        [db setShouldCacheStatements:YES];

        //判断数据库中是否已经存在这个表，如果不存在则创建该表
        if(![db tableExists:@"message"])
        {
            [db beginTransaction];

            [db executeUpdate:@"CREATE TABLE IF NOT EXISTS message (msg_id INTEGER PRIMARY KEY AUTOINCREMENT, uuid  TEXT, from_uid INTEGER, to_uid INTEGER, msg TEXT, msg_type INTEGER, create_time NUMERIC, has_read INTEGER);"];

            [db executeUpdate:@"CREATE INDEX from_id_time_idx ON message(from_uid ASC, create_time DESC);"];

            [db executeUpdate:@"CREATE INDEX to_id_time_idx ON message(to_uid ASC, create_time DESC);"];

            [db executeUpdate:@"CREATE INDEX uuid_idx ON message(uuid);"];

            if([db hadError])
            {
                NSLog(@"Error %d : %@",[db lastErrorCode],[db lastErrorMessage]);
            }
            
            [db commit];
            [db close];
            NSLog(@"创建完成");
        }

    };
    return block;
}


@end
