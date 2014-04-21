//
//  KGWebViewController.m
//  KelpGang
//
//  Created by Andy on 14-4-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBaseWebViewController.h"
#import "HudHelper.h"
#import "SVPullToRefresh.h"

@interface KGBaseWebViewController () <UIWebViewDelegate>

@end

@implementation KGBaseWebViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id)initWithWebPath: (NSString *)webPath {
    self = [super init];
    if (self) {
        self.webPath = webPath;
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT)];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    if (!self.webView) {
        self.webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT)];
    }
    [[HudHelper getInstance] showHudOnView:self.webView caption:@"Loading" image:nil acitivity:YES autoHideTime:0.0];
    self.webView.backgroundColor = [UIColor whiteColor];
    self.webView.scalesPageToFit = YES;
    self.webView.delegate = self;
    [self.view addSubview:self.webView];
    [self loadRequest];
    if (self.isPullToRefresh) {
        [self addPullToRefresh];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

- (void)loadRequest {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebHTML5Url, self.webPath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [self.webView loadRequest:request];
}
- (void)stopRequest {
    [self.webView stopLoading];
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    DLog(@"%@", url);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HudHelper getInstance] hideHudInView:self.webView];
    [self.webView.scrollView.pullToRefreshView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"didFailLoadWithError: %@", error);
    [[HudHelper getInstance] showHudOnView:self.webView caption:@"加载失败" autoHideTime:2];
    [self.webView.scrollView.pullToRefreshView stopAnimating];

}

- (void)addPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.webView.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf loadRequest];
    }];
}


@end
