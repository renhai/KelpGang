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
            success:(ResponseBlock)success
            failure:(FailureBlock)failure;

- (void)uploadPhoto:(NSString *)path
             params:(NSDictionary *)params
               name:(NSString *)name
              image:(UIImage *)image
            success: (ResponseBlock)success
            failure:(FailureBlock)failure;

- (void)uploadMultiPhotos:(NSString *)path
                   params:(NSDictionary *)params
                     name:(NSString *)name
                   images:(NSArray *)arrayImage
                  success:(ResponseBlock)success
                  failure:(FailureBlock)failure;

- (void)uploadMultiPhotos2:(NSString *)path
                   params:(NSDictionary *)params
                     name:(NSString *)name
                   images:(NSArray *)arrayImage
                  success:(ResponseBlock)success
                  failure:(FailureBlock)failure;

@end
