//
//  KGTaskTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-4-1.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskTableViewController.h"
#import "HudHelper.h"
#import "KGBaseWebViewController.h"

@interface KGTaskTableViewController ()

@end

@implementation KGTaskTableViewController

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
    UIBarButtonItem *leftBar = [[UIBarButtonItem alloc] initWithTitle:@"修改" style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    leftBar.tintColor = [UIColor whiteColor];
    self.navigationItem.leftBarButtonItem = leftBar;

    UIBarButtonItem *rightBar = [[UIBarButtonItem alloc] initWithTitle:@"确认发布" style:UIBarButtonItemStyleBordered target:self action:@selector(publish:)];
    rightBar.tintColor = [UIColor whiteColor];
    self.navigationItem.rightBarButtonItem = rightBar;

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
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

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return 10.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
//    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)publish: (UIBarButtonItem *)btn {
    __weak typeof(self) weakSelf = self;
    [[HudHelper getInstance] showHudOnWindow:@"正在发布..." image:nil acitivity:YES autoHideTime:0.0];
    int64_t delay = 2.0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delay * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void) {
        [[HudHelper getInstance] hideHudInWindow];
        [[NSNotificationCenter defaultCenter] postNotificationName:kPublishTask object:nil];
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发布成功" delegate:weakSelf cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alertView show];
    });
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *rootViewController = (UITabBarController *)window.rootViewController;
    [rootViewController setSelectedIndex:3];
    UINavigationController *navController = (UINavigationController *)(rootViewController.selectedViewController);
    KGBaseWebViewController *taskController = [[KGBaseWebViewController alloc] initWithWebPath:@"/html/gj_task.htm"];
    taskController.hidesBottomBarWhenPushed = YES;
    taskController.isPullToRefresh = YES;
    [taskController setLeftBarbuttonItem];
    [taskController setTitle:@"我的任务"];
    [navController pushViewController:taskController animated:YES];
}


#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 5;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kTaskCollectionViewCell" forIndexPath:indexPath];
    return cell;
    
}


@end
