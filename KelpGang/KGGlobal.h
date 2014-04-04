//
//  KGGlobal.h
//  KelpGang
//
//  Created by Andy on 14-3-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#define RGBCOLOR(r,g,b) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:1]
#define RGBACOLOR(r,g,b,a) [UIColor colorWithRed:(r)/255.0f green:(g)/255.0f blue:(b)/255.0f alpha:(a)]

/*
 *屏幕宽度
 */
#define SCREEN_WIDTH ([[UIScreen mainScreen]bounds].size.width)

/*
 *屏幕高度
 */
#define SCREEN_HEIGHT ([[UIScreen mainScreen]bounds].size.height)

/*
 * iPhone 屏幕尺寸
 */
#define SCREEN_SIZE (CGSizeMake(SCREEN_WIDTH, SCREEN_HEIGHT - PHONE_STATUSBAR_HEIGHT))

/*
 * iPhone statusbar 高度
 */
#define STATUSBAR_HEIGHT 20

/*
 * iPhone 默认导航条高度
 */
#define NAVIGATIONBAR_HEIGHT 44.0f
#define NAVIGATIONBAR_IOS7_HEIGHT 64.0f
// tabBar高度
#define TABBAR_HEIGHT 50.0f
#define ENGISH_KEYBOARD_HEIGHT 216.0


//判断是否为iPhone5
#define iPhone5 ([UIScreen instancesRespondToSelector:@selector(currentMode)] ? CGSizeEqualToSize(CGSizeMake(640, 1136), [[UIScreen mainScreen] currentMode].size) : NO)

#define kPublishTask @"kPublishTask"
#define kSelectFilterViewCell @"kSelectFilterViewCell"
