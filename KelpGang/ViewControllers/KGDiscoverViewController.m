//
//  KGDiscoverViewController.m
//  KelpGang
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverViewController.h"
#import "HudHelper.h"
#import "SVPullToRefresh.h"

static const NSString * kWebPath = @"/html/gj_saohuo.htm";

@interface KGDiscoverViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;
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

- (void)viewDidLoad
{
    [super viewDidLoad];
    [[HudHelper getInstance] showHudOnView:self.view caption:@"Loading" image:nil acitivity:YES autoHideTime:0.0];
    [self loadRequest];
    [self addPullToRefresh];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    DLog(@"%@", url);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HudHelper getInstance] hideHudInView:self.view];
    [self.webView.scrollView.pullToRefreshView stopAnimating];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"didFailLoadWithError: %@", error);
    [[HudHelper getInstance] showHudOnView:self.view caption:@"加载失败" autoHideTime:2];
    [self.webView.scrollView.pullToRefreshView stopAnimating];

}

- (void)addPullToRefresh {
    __weak typeof(self) weakSelf = self;
    [self.webView.scrollView addPullToRefreshWithActionHandler:^{
        [weakSelf handleRefresh];
    }];
}

- (void)handleRefresh {
    [self loadRequest];
}

- (void)loadRequest {
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@%@", kWebHTML5Url, kWebPath]];
    NSURLRequest *request = [NSURLRequest requestWithURL:url cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:5.0];
    [self.webView loadRequest:request];
}

@end
