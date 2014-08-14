//
//  KGJourneyObject.m
//  KelpGang
//
//  Created by Andy on 14-8-14.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGJourneyObject.h"

@implementation KGJourneyObject

- (id)init {
    self = [super init];
    if (self) {
        self.toCountry = @"";
        self.fromCity = @"";
        self.desc = @"";
    }
    return self;
}

@end
