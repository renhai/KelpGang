//
//  KGCommentListViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentListViewController.h"

@interface KGCommentListViewController ()
@property (weak, nonatomic) IBOutlet UIView *chatView;

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

- (id)initWithCoder:(NSCoder *)coder
{
    self = [super initWithCoder:coder];
    if (self) {
        self.webPath = @"/html/gj_pingjia.htm";
        self.isPullToRefresh = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarbuttonItem];
    self.webView.height = SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT - self.chatView.height;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


@end
