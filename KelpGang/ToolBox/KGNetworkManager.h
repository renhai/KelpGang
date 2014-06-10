//
//  KGNetworkManager.h
//  KelpGang
//
//  Created by Andy on 14-6-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^ResponseBlock)(id responseObject);
typedef void(^FailureBlock)(NSError *error);

@interface KGNetworkManager : NSObject

+ (instancetype)sharedInstance;

- (void)postRequest:(NSString *)path
             params:(NSDictionary *)params
            success:(ResponseBlock) success
            failure:(FailureBlock)failure;

@end
