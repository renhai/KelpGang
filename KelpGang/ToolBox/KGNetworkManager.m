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
          [JDStatusBarNotification showWithStatus:kNetworkError dismissAfter:1.6    styleName:JDStatusBarStyleDark];
          if (failure) {
              failure(error);
          }
      }];
}

- (void)uploadPhoto:(NSString *)path
             params:(NSDictionary *)params
               name:(NSString *)name
              image:(UIImage *)image
            success: (ResponseBlock)success
            failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
    [mgr POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        NSData *imageData = UIImageJPEGRepresentation(image, 0.5);
        [formData appendPartWithFileData:imageData name:name fileName:[NSString stringWithFormat:@"%@.jpg", fileName] mimeType:@"image/jpeg"];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [JDStatusBarNotification showWithStatus:kNetworkError dismissAfter:1.6    styleName:JDStatusBarStyleDark];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadMultiPhotos:(NSString *)path
                   params:(NSDictionary *)params
                     name:(NSString *)name
                   images:(NSArray *)arrayImage
                  success:(ResponseBlock)success
                  failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
    [mgr POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        for (int i = 0; i < arrayImage.count; i++) {
            UIImage *uploadImage = arrayImage[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadImage, 0.5) name:name fileName:[NSString stringWithFormat:@"%@%d.jpg",fileName,i+1] mimeType:@"image/jpeg"];
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [JDStatusBarNotification showWithStatus:kNetworkError dismissAfter:1.6    styleName:JDStatusBarStyleDark];
        if (failure) {
            failure(error);
        }
    }];
}

- (void)uploadMultiPhotos2:(NSString *)path
                   params:(NSDictionary *)params
                     name:(NSString *)name
                   images:(NSArray *)arrayImage
                  success:(ResponseBlock)success
                  failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [AFHTTPRequestOperationManager manager];
    NSMutableURLRequest *request = [mgr.requestSerializer multipartFormRequestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@",kWebServerBaseURL,path] parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];
        for (int i = 0; i < arrayImage.count; i++) {
            UIImage *uploadImage = arrayImage[i];
            [formData appendPartWithFileData:UIImageJPEGRepresentation(uploadImage, 0.5) name:name fileName:[NSString stringWithFormat:@"%@%d.jpg",fileName,i+1] mimeType:@"image/jpeg"];
        }
    } error:nil];

    AFHTTPRequestOperation *opration = [[AFHTTPRequestOperation alloc]initWithRequest:request];
    opration.responseSerializer = [AFJSONResponseSerializer serializer];
    [opration setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        [JDStatusBarNotification showWithStatus:kNetworkError dismissAfter:1.6    styleName:JDStatusBarStyleDark];
        if (failure) {
            failure(error);
        }
    }];
    [mgr.operationQueue addOperation:opration];
}


@end
