//
//  KGDiscovery.h
//  KelpGang
//
//  Created by Andy on 14-9-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGDiscovery : NSObject

@property (nonatomic, assign) NSInteger discoveryId;
@property (nonatomic, strong) NSString *coverUrl;
@property (nonatomic, strong) NSString *topImageUrl;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *article;


@end
