//
//  KGAddressObject.h
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGAddressObject : NSObject

@property(nonatomic,assign) NSInteger uid;
@property(nonatomic,strong) NSString *consignee;
@property(nonatomic,strong) NSString *mobile;

@property(nonatomic,strong) NSString *province;
@property(nonatomic,strong) NSString *city;
@property(nonatomic,strong) NSString *district;

@property(nonatomic,strong) NSString *street;
@property(nonatomic,strong) NSString *areaCode;

@property(nonatomic,assign,getter = isDefaultAddr) BOOL defaultAddr;

@end
