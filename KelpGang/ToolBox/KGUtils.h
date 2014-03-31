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

#define NAVIGATIONBAR_ADD_DEFAULT_BACKBUTTON_WITH_CALLBACK(callbackFunction) \
{ \
    UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];\
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(callbackFunction)];\
    buttonItem.tintColor = [UIColor whiteColor];\
    self.navigationItem.leftBarButtonItem = buttonItem;\
}

+ (BOOL)checkIsNetworkConnectionAvailableAndNotify:(UIView*)view;

+ (UIView *)seperatorWithFrame: (CGRect) frame;

@end
