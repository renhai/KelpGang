//
//  KGUserObject.h
//  KelpGang
//
//  Created by Andy on 14-4-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGUserObject : NSObject

@property (nonatomic, assign) NSInteger uid;
@property (nonatomic, strong) NSString *uname;
@property (nonatomic, assign) Gender gender;
@property (nonatomic, strong) NSString *avatarUrl;
@property (nonatomic, assign, getter = isVip) BOOL vip;
@property (nonatomic, assign) NSInteger level;
@property (nonatomic, assign) NSInteger followCount;

@property (nonatomic, strong) NSString *nickName;
@property (nonatomic, strong) NSString *intro;
@property (nonatomic, strong) NSString *cellPhone;
@property (nonatomic, strong) NSString *email;
@property (nonatomic, strong) NSString *password;

@property (nonatomic, strong) NSString *sessionKey;

- (BOOL)isLogin;

@end
