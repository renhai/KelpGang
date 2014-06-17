//
//  AppContext.h
//  KelpGang
//
//  Created by Andy on 14-6-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@class KGUserObject;

@interface AppContext : NSObject

@property (nonatomic, strong) KGUserObject *currUser;

+(AppContext *)sharedInstance;

- (BOOL)checkLogin;


@end
