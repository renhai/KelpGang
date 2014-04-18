//
//  RSHudHelper.h
//  RenrenSixin
//
//  Created by  on 12-2-24.
//  Copyright (c) 2012年 renren. All rights reserved.
//
#define RS_HUD_ICON_OK      [UIImage imageForKey:@"hud_icon_ok"]
#define RS_HUD_ICON_WARNING [UIImage imageForKey:@"hud_icon_error"]

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define HUD_DEFAULT_HIDE_TIME_LENGTH 2.0f // 用于atmhud统一autohidetime
typedef void (^ afterHudDisappearBlock) (void);
@interface HudHelper : NSObject

// 单例
+ (HudHelper*) getInstance;

// 在window上显示hud
// 参数：
// caption:标题
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失

- (void)showHudOnWindow:(NSString *)caption
                  image:(UIImage *)image
              acitivity:(BOOL)bAcitve
           autoHideTime:(NSTimeInterval)time;
// 在当前的view上显示hud
// 参数：
// view：要添加hud的view
// caption:标题
// image:图片
// bActive：是否显示转圈动画
// time：自动消失时间，如果为0，则不自动消失
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time;

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
             animated:(BOOL)animated;

- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
         autoHideTime:(NSTimeInterval)time;

- (void)showHudOnWindow:(NSString *)caption autoHideTime:(NSTimeInterval)autoHideTimeInterval;
- (void)showHudOnView:(UIView *)view
              caption:(NSString *)caption
                image:(UIImage *)image
            acitivity:(BOOL)bAcitve
         autoHideTime:(NSTimeInterval)time
              doBlock:(afterHudDisappearBlock)block;

// 隐藏hud
- (void)hideHudInView:(UIView *)parentView;
- (void)hideHudInView:(UIView *)parentView after:(NSTimeInterval)time;
- (void)hideHudInWindow;


@end