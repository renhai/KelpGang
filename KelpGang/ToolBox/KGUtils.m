//
//  KGUtils.m
//  KelpGang
//
//  Created by Andy on 14-3-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGUtils.h"
#import "Reachability.h"
#import "MBProgressHUD.h"
#import "KGMaskView.h"

@implementation KGUtils

+ (BOOL)isHigherIOS7
{
    NSString *requestSysVer = @"7.0";
    NSString *currentSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currentSysVer compare:requestSysVer options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }

    return YES;
}

#pragma mark - Reachability
+ (BOOL)checkIsNetworkConnectionAvailableAndNotify:(UIView*)view
{
    Reachability *reachability = [Reachability reachabilityForInternetConnection];
    if (![reachability isReachable]) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (view) {
                [MBProgressHUD hideAllHUDsForView:view animated:YES];
                MBProgressHUD *hud = [[MBProgressHUD alloc] initWithView:view];
                [view addSubview:hud];
                hud.mode = MBProgressHUDModeText;
                hud.labelText = @"当前网络不给力哦!";
                hud.labelFont = [UIFont boldSystemFontOfSize:16.0f];
                hud.margin = 10.0f;
                hud.yOffset = 0.0f;
                hud.removeFromSuperViewOnHide = YES;
                [hud show:YES];
                [hud hide:YES afterDelay:2.0f];
            }
        });
        return NO;
    }
    return YES;
}

+ (UIView *)seperatorWithFrame: (CGRect) frame {
    UIView *seperator = [[UIView alloc] initWithFrame:frame];
    seperator.backgroundColor = RGBCOLOR(211, 220, 224);
    return seperator;
}

+ (void)removeMaskViewFromWindow {
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    for (UIView *subview in window.subviews) {
        if ([subview isKindOfClass:[KGMaskView class]]) {
            [subview removeFromSuperview];
        }
    }
}
@end
