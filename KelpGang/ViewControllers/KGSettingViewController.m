//
//  KGSettingViewController.m
//  KelpGang
//
//  Created by Andy on 14-4-22.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGSettingViewController.h"

@interface KGSettingViewController ()

@end

@implementation KGSettingViewController

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
    // Do any additional setup after loading the view.
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
    NSString *qaSuffix = @"/html/gj_qa.htm";
    NSString *aboutSuffix = @"/html/gj_about.htm";
    if ([url hasSuffix:qaSuffix]) {
        KGBaseWebViewController *webController = [[KGBaseWebViewController alloc] initWithWebPath:qaSuffix];
        [webController setLeftBarbuttonItem];
        [webController setTitle:@"常见问题解答"];
        [self.navigationController pushViewController:webController animated:YES];
        return NO;
    } else if ([url hasSuffix:aboutSuffix]){
        KGBaseWebViewController *webController = [[KGBaseWebViewController alloc] initWithWebPath:qaSuffix];
        [webController setLeftBarbuttonItem];
        [webController setTitle:@"关于帮帮"];
        [self.navigationController pushViewController:webController animated:YES];
        return NO;
    }
    return YES;
}

@end
