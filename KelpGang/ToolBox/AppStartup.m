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
            NSDictionary *params = @{@"account": APPCONTEXT.currUser.cellPhone, @"password_md5": APPCONTEXT.currUser.password};
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/home/login" params:params success:^(id responseObject) {
                DLog(@"%@", responseObject);
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
                    APPCONTEXT.currUser.uname = [info objectForKey:@"user_name"];
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

        });
    }

}


@end
