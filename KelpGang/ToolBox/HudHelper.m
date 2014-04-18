//
//  RSHudHelper.m
//  RenrenSixin
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 renren. All rights reserved.
//

#import "HudHelper.h"
#import <UIKit/UIApplication.h>
#import "MBProgressHUD.h"

@interface HudHelper (Private)

- (void)setHudCaption:(NSString *)caption image:(UIImage *)image acitivity:(BOOL)bAcitve;
- (void)showHudAutoHideAfter:(NSTimeInterval)time;

- (void)hideHudTime:(NSString *)obj;

@end

@interface HudHelper ()
@property (nonatomic, strong) NSString      *showingCaption;
@property (nonatomic, strong) MBProgressHUD *hud;
@property (nonatomic, strong) UIView        *parentView;
@end

@implementation HudHelper

static HudHelper* hudInstance = nil;

- (id)init
{
    self = [super init];
    return self;
}

#pragma mark - public method
+ (HudHelper*) getInstance{
    @synchronized(self){
        if (!hudInstance) {
            hudInstance = [[HudHelper alloc] init];
        }
        return hudInstance;
    }
}
// 在window上显示hud
- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time
{
    UIView *v = [[UIApplication sharedApplication].delegate window];

    [self showHudOnView:v
                caption:caption
                  image:image
              acitivity:bAcitve
           autoHideTime:time];
}

// 在当前的view上显示hud
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
{
    [self showHudOnView:view
                caption:caption
                  image:image
              acitivity:bAcitve
           autoHideTime:time
               animated:YES];
}

// 在当前的view上显示hud，带动画选项
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
             animated:(BOOL)animated
{
    // 删除此view上原有的hud
    NSArray *array = [MBProgressHUD allHUDsForView:view];

    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:animated];
    hud.detailsLabelText = caption;

    if (!bAcitve) {
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }

    if (image != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }

    if (time > 0.0f) {
        [hud hide:YES afterDelay:time];
    }
}

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
              doBlock:(afterHudDisappearBlock)block
{
    // 删除此view上原有的hud
    NSArray *array = [MBProgressHUD allHUDsForView:view];

    for (MBProgressHUD *obj in array) {
        [obj hide:NO];
    }

    MBProgressHUD *hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
    hud.detailsLabelText = caption;
    hud.completionBlock = block;

    if (!bAcitve) {
        hud.mode = MBProgressHUDModeText;
    } else {
        hud.mode = MBProgressHUDModeIndeterminate;
    }

    if (image != nil) {
        hud.mode = MBProgressHUDModeCustomView;
        hud.customView = [[UIImageView alloc] initWithImage:image];
    }

    if (time > 0.0f) {
        [hud hide:YES afterDelay:time];
    }
}

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
         autoHideTime:(NSTimeInterval)autoHideTimeInterval
{
    [self showHudOnView:view caption:caption image:nil acitivity:NO autoHideTime:autoHideTimeInterval];
}

- (void)showHudOnWindow:(NSString *)caption autoHideTime:(NSTimeInterval)autoHideTimeInterval
{
    UIView *v = [[UIApplication sharedApplication].delegate window];

    [self showHudOnView:v caption:caption image:nil acitivity:NO autoHideTime:autoHideTimeInterval];
}

// 隐藏hud
- (void)hideHudInView:(UIView *)parentView
{
    NSArray *array = [MBProgressHUD allHUDsForView:parentView];

    for (MBProgressHUD *obj in array) {
        [obj hide:YES];
    }
}

- (void)hideHudInView:(UIView *)parentView after:(NSTimeInterval)time
{
    NSArray *array = [MBProgressHUD allHUDsForView:parentView];

    for (MBProgressHUD *obj in array) {
        [obj hide:YES afterDelay:time];
    }
}

- (void)hideHudInWindow {
    UIWindow *v = [[UIApplication sharedApplication].delegate window];
    [self hideHudInView:v];
}

@end
