//
//  KGAddressObject.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddressObject.h"

@implementation KGAddressObject

- (id)init {
    self = [super init];
    if (self) {
        self.province = @"";
        self.city = @"";
        self.district = @"";
        self.consignee = @"";
        self.mobile = @"";
        self.street = @"";
        self.areaCode = @"";
    }
    return self;
}

@end
