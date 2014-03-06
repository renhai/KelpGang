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
//    UITabBar *tabbar = [self tabBar];
//    UITabBarItem * tabbarItem = [[tabbar items] objectAtIndex:0];
//    UIImage *selectedImage = [UIImage imageNamed:kTabbarItemSelectedImage];
//    [tabbarItem setSelectedImage:selectedImage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)tabBarController:(UITabBarController *)tabBarController didSelectViewController:(UIViewController *)viewController {
//    UITabBar *tabbar = [tabBarController tabBar];
//    UITabBarItem * tabbarItem = [tabbar selectedItem];
//    UIImage *selectedImage = [UIImage imageNamed:kTabbarItemSelectedImage];
//    [tabbarItem setSelectedImage:selectedImage];

}

@end
