//
//  AppContext.m
//  KelpGang
//
//  Created by Andy on 14-6-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "AppContext.h"

@implementation AppContext

+(AppContext *)sharedInstance {
    static AppContext *_instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _instance = [[AppContext alloc] init];
    });
    return _instance;
}

- (BOOL)checkLogin {
    if (APPCONTEXT.currUser && [APPCONTEXT.currUser isLogin]) {
        return YES;
    }

    return NO;
}

- (KGUserObject *)currUser {
    NSInteger currentUserId = [[NSUserDefaults standardUserDefaults] integerForKey:kCurrentUserId];
    if (!_currUser && currentUserId > 0){
        _currUser = (KGUserObject *)[self objectForKey:kLoginUserKey userId:currentUserId];
    }
    return _currUser;
}

- (void)userPersist {
    if ([self checkLogin]) {
        [self setObject:APPCONTEXT.currUser forKey:kLoginUserKey userId:APPCONTEXT.currUser.uid];
    }
}

- (NSObject *)objectForKey:(NSString *)key userId:(long long)userId {
    return [NSKeyedUnarchiver unarchiveObjectWithFile:[self dataFilePathForKey:key userId:userId]];
}

- (BOOL)setObject:(NSObject *)value forKey:(NSString *)key userId:(long long)userId {

    NSError *error = nil;

    if (![[NSFileManager defaultManager] createDirectoryAtPath:[self persistFileDir] withIntermediateDirectories:YES attributes:nil error:&error]) {
        return NO;
    }
    return [NSKeyedArchiver archiveRootObject:value toFile:[self dataFilePathForKey:key userId:userId]];
}

- (NSString *)dataFilePathForKey:(NSString *)key userId:(long long)userId {
    NSString *documentDirectory = [self documentsDir];
    NSString *dir = [NSString stringWithFormat:@"%@/%@/X2_persistence_%@_object_%@", documentDirectory, kPersistDir,
                     [NSString stringWithFormat:@"%lld",userId], key];
    return dir;
}

- (NSString *)documentsDir {
    NSArray *searchPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    if ([searchPaths count] > 0) {
        return [searchPaths objectAtIndex:0];
    }
    else {
        return nil;
    }
}

- (NSString *)persistFileDir {
    NSString *documentDirectory = [self documentsDir];
    NSString *dir = [documentDirectory stringByAppendingPathComponent:kPersistDir];
    return dir;
}

@end
