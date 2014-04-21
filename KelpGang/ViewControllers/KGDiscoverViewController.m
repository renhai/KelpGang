//
//  KGDiscoverViewController.m
//  KelpGang
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverViewController.h"

@interface KGDiscoverViewController ()
@end

@implementation KGDiscoverViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.webPath = @"/html/gj_saohuo.htm";
        self.isPullToRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.webView.height = SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT - TABBAR_HEIGHT;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    DLog(@"%@", url);
    NSString *suffix = @"/html/gj_saohuo2_1.htm";
    if ([url hasSuffix:suffix]) {
        KGBaseWebViewController *webController = [[KGBaseWebViewController alloc] initWithWebPath:suffix];
        webController.isPullToRefresh = YES;
        webController.hidesBottomBarWhenPushed = YES;
        [webController setLeftBarbuttonItem];
        [webController setTitle:@"英国海淘指南"];
        [self.navigationController pushViewController:webController animated:YES];
        return NO;
    }
    return YES;
}


@end
