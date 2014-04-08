//
//  KGCommentListViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentListViewController.h"
#import "HudHelper.h"

@interface KGCommentListViewController ()
@property (weak, nonatomic) IBOutlet UIWebView *webView;

@end

@implementation KGCommentListViewController

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
    NAVIGATIONBAR_ADD_DEFAULT_BACKBUTTON_WITH_CALLBACK(goBack:);

    [[HudHelper getInstance] showHudOnView:self.view caption:@"Loading" image:nil acitivity:YES autoHideTime:0.0];
    NSURLRequest *reqest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://10.2.24.140/html/guangjieapp.htm"]];//TODO
    [self.webView loadRequest:reqest];
}

- (void)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = request.URL.absoluteString;
    NSLog(@"%@", url);
    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [[HudHelper getInstance] hideHudInView:self.view];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    NSLog(@"didFailLoadWithError: %@", error);
    [[HudHelper getInstance] hideHudInView:self.view];
}


@end
