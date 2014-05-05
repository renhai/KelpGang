//
//  KGAppDelegate.m
//  KelpGang
//
//  Created by Andy on 14-2-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAppDelegate.h"
#import "DDLog.h"
#import "DDTTYLogger.h"
#import "XMPPManager.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

@implementation KGAppDelegate

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    [[UITabBar appearance] setTintColor:MAIN_COLOR];
    [[UINavigationBar appearance] setBackgroundImage:[UIImage imageWithColor:MAIN_COLOR] forBarMetrics:UIBarMetricsDefault];
    if (SYSTEM_VERSION_LESS_THAN(@"7.0")) {
        [[UIBarButtonItem appearance] setBackgroundImage:[UIImage new]
                                                forState:UIControlStateNormal
                                              barMetrics:UIBarMetricsDefault];
        [application setStatusBarStyle:UIStatusBarStyleLightContent];
    }

    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    XMPPManager *xmppmgr = [XMPPManager sharedInstance];
    [xmppmgr setupStream];
    BOOL connect = [xmppmgr connect];
    NSLog(@"connect: %d", connect);
    [[IQKeyboardManager sharedManager] setShouldResignOnTouchOutside:YES];
    [[IQKeyboardManager sharedManager] setShouldShowTextFieldPlaceholder:NO];
    [[IQKeyboardManager sharedManager] setEnableAutoToolbar:NO];
    [[IQKeyboardManager sharedManager] setEnable:YES];
    return YES;
}
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}


- (void)applicationDidEnterBackground:(UIApplication *)application
{
	// Use this method to release shared resources, save user data, invalidate timers, and store
	// enough application state information to restore your application to its current state in case
	// it is terminated later.
	//
	// If your application supports background execution,
	// called instead of applicationWillTerminate: when the user quits.

	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

#if TARGET_IPHONE_SIMULATOR
	DDLogError(@"The iPhone simulator does not process background network traffic. "
			   @"Inbound traffic is queued until the keepAliveTimeout:handler: fires.");
#endif

	if ([application respondsToSelector:@selector(setKeepAliveTimeout:handler:)])
	{
		[application setKeepAliveTimeout:600 handler:^{

			DDLogVerbose(@"KeepAliveHandler");

			// Do other keep alive stuff here.
		}];
	}
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    DDLogVerbose(@"%@", notification);
    UITabBarController *rootViewController = (UITabBarController *)self.window.rootViewController;
    UIViewController *chatViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
    UIViewController *selectViewController = rootViewController.selectedViewController;
    if ([selectViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *) selectViewController;
        chatViewController.hidesBottomBarWhenPushed = YES;
        [navController popToRootViewControllerAnimated:NO];
        [navController pushViewController: chatViewController animated:YES];
    } else {
        UINavigationController *navController = [[UINavigationController alloc] initWithRootViewController:chatViewController];
        [selectViewController presentViewController:navController animated:YES completion:nil];
    }

    [[UIApplication sharedApplication] cancelLocalNotification:notification];
}

@end
