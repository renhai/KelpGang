//
//  KGViewController.m
//  KelpGang
//
//  Created by Andy on 14-2-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGViewController.h"

//static NSString * const kTabbarItemSelectedImage = @"tabbar-item-selected.png";

@interface KGViewController ()

@end

@implementation KGViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.delegate = self;
    if (![self isHigherIOS7]) {
        UIImage *tabbarImage = [UIImage imageNamed:@"tab_bar.png"];
        UIColor *imageTintColor = [UIColor colorWithRed:33.0 / 255 green:185.0 / 255 blue:162.0 / 255 alpha:1.0];
        UIColor *tintColor = [UIColor colorWithRed:233.0 / 255 green:243.0 / 255 blue:243.0 / 255 alpha:1.0];
        [[UITabBar appearance] setBackgroundImage:tabbarImage];
//        [[UITabBar appearance] setSelectedImageTintColor: imageTintColor];
        [[UITabBar appearance] setTintColor:tintColor];
        [[self.tabBar.items objectAtIndex:0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:imageTintColor,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        UIImage *selectedImage1 = [UIImage imageNamed:@"search_someone_active.png"];
        UIImage *selectedImage2 = [UIImage imageNamed:@"search_active.png"];
        UIImage *selectedImage3 = [UIImage imageNamed:@"write_active.png"];
        UIImage *selectedImage4 = [UIImage imageNamed:@"me_active.png"];
        UIImage *selectedImage5 = [UIImage imageNamed:@"more_active.png"];
        NSArray *selectedImages = @[selectedImage1, selectedImage2,selectedImage3,selectedImage4,selectedImage5];
        NSInteger index = 0;
        for (UITabBarItem *item in self.tabBar.items) {
            [item setSelectedImage:[selectedImages objectAtIndex: index ++]];
        }
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
    if (![self isHigherIOS7]) {
        [self.selectedViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor colorWithRed:33.0 / 255 green:185.0 / 255 blue:162.0 / 255 alpha:1.0],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        NSInteger index = 0;
        for (UITabBarItem *item in self.tabBar.items) {
            if (self.selectedIndex != index ++) {
                [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
            }
        }
    }

}

- (BOOL)isHigherIOS7 {
    NSString *requestSysVer = @"7.0";
    NSString *currentSysVer = [[UIDevice currentDevice] systemVersion];

    if ([currentSysVer compare:requestSysVer options:NSNumericSearch] == NSOrderedAscending) {
        return NO;
    }

    return YES;
}

@end
