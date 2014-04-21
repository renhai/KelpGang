//
//  KGWebViewController.h
//  KelpGang
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGBaseWebViewController : UIViewController

@property (nonatomic, strong) NSString *webPath;
@property (nonatomic, strong) UIWebView *webView;
@property (nonatomic, assign) BOOL isPullToRefresh;

- (id)initWithWebPath: (NSString *)webPath;

@end
