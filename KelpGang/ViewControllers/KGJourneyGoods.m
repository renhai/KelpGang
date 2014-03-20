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
        self.pictures = [[NSMutableArray alloc] init];
    }
    return self;
}

@end
