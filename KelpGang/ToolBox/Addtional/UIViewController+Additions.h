//
//  UIViewController+Additions.h
//  KelpGang
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Additions)

- (void)setLeftBarbuttonItem;
- (void)setRightBarbuttonItem: (UIImage *)image selector: (SEL)selector;
- (void)goBack:(UIBarButtonItem *)sender;

@end
