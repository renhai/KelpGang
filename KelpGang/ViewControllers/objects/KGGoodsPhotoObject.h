//
//  KGGoodsPhotoObject.h
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGGoodsPhotoObject : NSObject

@property (nonatomic, assign) NSInteger good_photo_id;
@property (nonatomic, strong) NSString *good_head_url;
@property (nonatomic, strong) NSString *good_main_url;
@property (nonatomic, strong) NSString *good_photo_url;
@property (nonatomic, strong) NSString *good_tiny_url;


@end
