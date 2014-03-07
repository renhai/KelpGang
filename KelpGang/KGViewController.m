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
    if (![KGUtils isHigherIOS7]) {
        UIImage *tabbarImage = [UIImage imageNamed:@"tab-bar"];
        UIImage *selectedImage = [UIImage imageNamed:@"tab_bar_selected"];
        UIColor *textColor = RGBCOLOR(33, 185, 162);
        UIColor *tintColor = RGBCOLOR(233, 243, 243);

        [[UITabBar appearance] setBackgroundImage:tabbarImage];
        [[UITabBar appearance] setSelectionIndicatorImage:selectedImage];
        [[UITabBar appearance] setSelectedImageTintColor:[UIColor clearColor]];
        [[UITabBar appearance] setTintColor:tintColor];
        [[self.tabBar.items objectAtIndex:0] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:textColor,UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        UIImage *selectedImage1 = [UIImage imageNamed:@"search_someone_active"];
        UIImage *selectedImage2 = [UIImage imageNamed:@"search_active"];
        UIImage *selectedImage3 = [UIImage imageNamed:@"write_active"];
        UIImage *selectedImage4 = [UIImage imageNamed:@"me_active"];
        UIImage *selectedImage5 = [UIImage imageNamed:@"more_active"];
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
    if (![KGUtils isHigherIOS7]) {
        [self.selectedViewController.tabBarItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:RGBCOLOR(33, 185, 162),UITextAttributeTextColor,nil] forState:UIControlStateNormal];
        NSInteger index = 0;
        for (UITabBarItem *item in self.tabBar.items) {
            if (self.selectedIndex != index ++) {
                [item setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor lightGrayColor],UITextAttributeTextColor,nil] forState:UIControlStateNormal];
            }
        }
    }

}


@end
