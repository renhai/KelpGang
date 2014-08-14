//
//  KGJourneyGoods.m
//  KelpGang
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGJourneyGoods.h"

@implementation KGJourneyGoods

- (id) init {
    self = [super init];
    if (self) {
        self.name = @"";
        self.localImgUrls = [[NSMutableArray alloc] init];
        self.thumbs = [[NSMutableArray alloc] init];
        self.imgArr = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
