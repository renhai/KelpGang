//
//  KGHostTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostViewController.h"
#import "KGBadgeView.h"
#import "KGRecentContactsController.h"
#import "KGBaseWebViewController.h"
#import "KGSettingViewController.h"
#import "KGHostHeadViewCell.h"
#import "KGUserObject.h"
#import "KGHostDetailController.h"
#import "KGLoginController.h"

@interface KGHostViewController ()

@property (nonatomic, strong) KGUserObject *userObj;

@end

@implementation KGHostViewController

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
    [self mockData];
}

- (void)mockData {
    KGUserObject *userObj = [[KGUserObject alloc] init];
    userObj.uid = 12121;
    userObj.uname = @"Andy Ren";
    userObj.gender = MALE;
    userObj.avatarUrl = @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=9d361bfa7b310a55c424d9f4837d43a9/a8014c086e061d95607bb63179f40ad162d9cafe.jpg";
    userObj.vip = YES;
    userObj.level = 7;
    userObj.followCount = 1212121;

    userObj.cellPhone = @"12312341234";
    userObj.email = @"hai.ren@renren-inc.com";
    self.userObj = userObj;
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
    switch (indexPath.section) {
        case 0: {
            KGHostHeadViewCell *hCell = (KGHostHeadViewCell *)cell;
            [hCell configCell:self.userObj];
            break;
        }
        case 1:
            break;
        case 2: {
            if (indexPath.row == 0) {
                for (UIView *subview in [cell.contentView subviews]) {
                    if ([subview isKindOfClass:[KGBadgeView class]]) {
                        KGBadgeView *badgeView = (KGBadgeView *)subview;
                        [badgeView setBadgeValue:99];
                    }
                }
            }
            break;
        }
        case 3:
            break;
        case 4: {
            break;
        }
        default:
            break;
    }

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}

#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destController = segue.destinationViewController;
    destController.hidesBottomBarWhenPushed = YES;

    if ([destController isKindOfClass:[KGHostDetailController class]]) {
        KGHostDetailController *hostDetailController = (KGHostDetailController *) destController;
        hostDetailController.user = self.userObj;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if (![APPCONTEXT checkLogin]) {
        return NO;
    }
//    if ([identifier isEqualToString:@"kHostDetailSegue"]) {
//        return YES;
//    }
    return YES;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    switch (indexPath.section) {
        case 0: {
            if (![APPCONTEXT checkLogin]) {
                KGLoginController *loginController = [UIStoryboard storyboardWithName:@"login" bundle:nil].instantiateInitialViewController;
                UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
                [self presentViewController:nc animated:YES completion:nil];
            }
            break;
        }
        case 1:
            break;
        case 2: {
            if (indexPath.row == 0) {
                UIStoryboard *orderBoard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
                UIViewController *orderController = orderBoard.instantiateInitialViewController;
                orderController.hidesBottomBarWhenPushed = YES;
                [orderController setLeftBarbuttonItem];
                [self.navigationController pushViewController:orderController animated:YES];
            } else if (indexPath.row == 1) {//我的任务
                KGBaseWebViewController *taskController = [[KGBaseWebViewController alloc] initWithWebPath:@"/html/gj_task.htm"];
                taskController.isPullToRefresh = YES;
                taskController.hidesBottomBarWhenPushed = YES;
                [taskController setLeftBarbuttonItem];
                [taskController setTitle:@"我的任务"];
                [self.navigationController pushViewController:taskController animated:YES];
            } else if (indexPath.row == 2) {//我的收藏
                KGBaseWebViewController *collectController = [[KGBaseWebViewController alloc] initWithWebPath:@"/html/gj_collect.htm"];
                collectController.isPullToRefresh = YES;
                collectController.hidesBottomBarWhenPushed = YES;
                [collectController setLeftBarbuttonItem];
                [collectController setTitle:@"我的收藏"];
                [self.navigationController pushViewController:collectController animated:YES];
            }
            break;
        }
        case 3:
            break;
        case 4: {
            KGSettingViewController *settingController = [[KGSettingViewController alloc] initWithWebPath:@"/html/gj_set.htm"];
            [settingController setLeftBarbuttonItem];
            [settingController setTitle:@"设置"];
            settingController.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:settingController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
