//
//  KGBuyerDetailViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerDetailViewController.h"

@interface KGBuyerDetailViewController ()
- (IBAction)goBack:(UIBarButtonItem *)sender;

@end

@implementation KGBuyerDetailViewController

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

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
