//
//  UIViewController+Additions.m
//  KelpGang
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "UIViewController+Additions.h"

@implementation UIViewController (Additions)

- (void)setLeftBarbuttonItem {
    UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    buttonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = buttonItem;
}

- (void)setRightBarbuttonItem: (UIImage *)image selector: (SEL)selector {
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:image style:UIBarButtonItemStyleBordered target:self action:selector];
    buttonItem.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = buttonItem;
}

- (void)setRightBarbuttonItemWithText:(NSString *)text selector:(SEL)selector {
    UIBarButtonItem *rightItem = [[UIBarButtonItem alloc] initWithTitle:text style:UIBarButtonItemStyleBordered target:self action:selector];
//    if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
        [rightItem setTitleTextAttributes: [NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], NSForegroundColorAttributeName,nil] forState:UIControlStateNormal];

//    } else {
//        [rightItem setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor], UITextAttributeTextColor,[UIFont systemFontOfSize:16], UITextAttributeFont, nil] forState:UIControlStateNormal];
//    }
    self.navigationItem.rightBarButtonItem = rightItem;
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
