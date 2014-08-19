//
//  KGGoodsObject.h
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGoodsObject : NSObject

@property (nonatomic, assign) NSInteger goods_id;
@property (nonatomic, strong) NSString *good_default_head_url;
@property (nonatomic, strong) NSString *good_default_main_url;
@property (nonatomic, strong) NSString *good_default_photo_url;
@property (nonatomic, strong) NSString *good_default_tiny_url;
@property (nonatomic, assign) BOOL good_is_collection;
@property (nonatomic, strong) NSString *good_name;
@property (nonatomic, strong) NSArray *good_photos;


@end
