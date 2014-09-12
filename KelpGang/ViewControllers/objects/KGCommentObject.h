//
//  KGCommentObject.h
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGCommentObject : NSObject

@property (nonatomic, assign) NSInteger commentId;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSDate *createTime;
@property (nonatomic, assign) NSInteger toUserId;
@property (nonatomic, assign) NSInteger fromUserId;
@property (nonatomic, strong) NSString *fromUserName;
@property (nonatomic, strong) NSString *fromUserHeadUrl;
@property (nonatomic, assign) Gender fromUserGender;
@property (nonatomic, assign) NSInteger star;


@end
