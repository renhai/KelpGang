//
//  KGNetworkManager.m
//  KelpGang
//
//  Created by Andy on 14-6-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGNetworkManager.h"
#import "AFHTTPRequestOperationManager+Timeout.h"

@implementation KGNetworkManager

+ (instancetype)sharedInstance {
    static KGNetworkManager *_instance = nil;
    static dispatch_once_t oncePredicate;
    dispatch_once(&oncePredicate, ^{
        _instance = [[self alloc] init];
    });

    return _instance;
}

- (void)postRequest:(NSString *)path
             params:(NSDictionary *)params
            success: (ResponseBlock) success
            failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
    [mgr POST:path parameters:params timeoutInterval: 5.0
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

- (void)uploadPhoto:(NSString *)path
             params:(NSDictionary *)params
               name:(NSString *)name
           filename:(NSString *)filename
              image:(NSData *)imageData
            success: (ResponseBlock)success
            failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
    [mgr POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        [formData appendPartWithFileData:imageData name:name fileName:filename mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
    [mgr POST:path parameters:params
      success:^(AFHTTPRequestOperation *operation, id responseObject) {
          if (success) {
              success(responseObject);
          }
      } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
          if (failure) {
              failure(error);
          }
      }];
}

@end
