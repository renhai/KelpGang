//
//  KGSettingsViewController.m
//  KelpGang
//
//  Created by Andy on 14-7-30.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGSettingsViewController.h"
#import "XMPPManager.h"

@interface KGSettingsViewController ()
@property (weak, nonatomic) IBOutlet UIButton *logoutBtn;

@end

@implementation KGSettingsViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarbuttonItem];
    [self.logoutBtn addTarget:self action:@selector(confirmLogout:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([APPCONTEXT checkLogin]) {
        return [super numberOfSectionsInTableView:tableView];
    } else {
        return 1;
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10)];
    view.backgroundColor = RGB(233, 243, 243);
    return view;
}

- (void)confirmLogout: (UIButton *)sender {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"确定退出登录？" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"确定", nil];
    [alert show];
}

- (void)logout {
    APPCONTEXT.currUser.sessionKey = nil;
    APPCONTEXT.currUser.uid = 0;
    APPCONTEXT.currUser = nil;
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentUserId];
    [[NSUserDefaults standardUserDefaults] removeObjectForKey:kCurrentSessionKey];
    [[NSUserDefaults standardUserDefaults] synchronize];

    [[SDImageCache sharedImageCache] clearMemory];
    [[XMPPManager sharedInstance] disconnect];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

#pragma marks -- UIAlertViewDelegate --
-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 1) {
        [self logout];
    }
}


@end
