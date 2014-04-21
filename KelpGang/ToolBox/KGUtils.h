//
//  KGUtils.h
//  KelpGang
//
//  Created by Andy on 14-3-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGUtils : NSObject

+ (BOOL)isHigherIOS7;

+ (BOOL)checkIsNetworkConnectionAvailableAndNotify:(UIView*)view;

+ (UIView *)seperatorWithFrame: (CGRect) frame;

+ (void)removeMaskViewFromWindow;

@end
