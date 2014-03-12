//
//  KGChatViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatViewController.h"

@interface KGChatViewController ()

@end

@implementation KGChatViewController

- (void)dealloc
{
    NSLog(@"KGChatViewController dealloc");
}

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
//    if ([KGUtils isHigherIOS7]) {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_64"] forBarMetrics:UIBarMetricsDefault];
//    } else {
//        [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"nav_bar_44"] forBarMetrics:UIBarMetricsDefault];
//    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
