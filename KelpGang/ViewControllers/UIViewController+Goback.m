//
//  UIViewController+Goback.m
//  KelpGang
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "UIViewController+Goback.h"

@implementation UIViewController (Goback)

- (void)setLeftBarbuttonItem {
    UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    buttonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)goBack:(UIBarButtonItem *)sender {
    NSArray *controllers = self.navigationController.viewControllers;
    if (controllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    } else {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

@end
