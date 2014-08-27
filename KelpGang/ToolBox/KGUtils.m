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
#import<CommonCrypto/CommonDigest.h>


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

+ (void)setExtraCellLineHidden: (UITableView *)tableView {
    UIView *view = [[UIView alloc] init];
    view.backgroundColor = [UIColor clearColor];
    [tableView setTableFooterView:view];
}

+ (NSString *)md5HexDigest:(NSString *)orig {
    const char *original_str = [orig UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}

+ (BOOL)checkResultWithAlert: (NSDictionary *)info {
    NSInteger code = [info[@"code"] integerValue];
    NSString *msg = info[@"msg"];
    if (code != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}

+ (BOOL)checkResult: (NSDictionary *)info {
    NSInteger code = [info[@"code"] integerValue];
    if (code != 0) {
        return NO;
    } else {
        return YES;
    }
}

+ (Gender)convertGender: (id)sex {
    if ([@"F" isEqualToString:sex]) {
        return FEMALE;
    } else {
        return MALE;
    }
}

@end
