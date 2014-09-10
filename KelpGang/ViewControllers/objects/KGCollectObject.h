//
//  KGCollectObject.h
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGCollectObject : NSObject

@property (nonatomic, assign) NSInteger goodsId;
@property (nonatomic, assign) NSInteger photoId;
@property (nonatomic, assign) NSInteger travelId;
@property (nonatomic, strong) NSString *goodsHeadUrl;
@property (nonatomic, strong) NSString *goodsOrigUrl;
@property (nonatomic, strong) NSString *goodsName;
@property (nonatomic, assign) NSInteger popularity;

@end
