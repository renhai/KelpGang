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
#import "KGHostHeadViewCell.h"
#import "KGUserObject.h"
#import "KGHostDetailController.h"
#import "KGLoginController.h"

@interface KGHostViewController ()

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
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self.tableView reloadData];
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
            [hCell configCell:APPCONTEXT.currUser];
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
                        badgeView.hidden = YES;
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

    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"kSettingsSegue" isEqualToString:identifier]) {
        return YES;
    }
    if ([@"kTaskListSegue" isEqualToString:identifier]) {
        return YES;
    }
    if (![APPCONTEXT checkLogin]) {
        return NO;
    }

    return YES;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    switch (indexPath.section) {
        case 0: {//用户信息
            [self checkIfNeedLogin];
            break;
        }
        case 1: {//最近联系人
            [self checkIfNeedLogin];
            break;
        }
        case 2: {
            if (indexPath.row == 0) {//我的订单
                if (![self checkIfNeedLogin]) {
                    UIStoryboard *orderBoard = [UIStoryboard storyboardWithName:@"order" bundle:nil];
                    UIViewController *orderController = orderBoard.instantiateInitialViewController;
                    orderController.hidesBottomBarWhenPushed = YES;
                    [orderController setLeftBarbuttonItem];
                    [self.navigationController pushViewController:orderController animated:YES];
                }
            } else if (indexPath.row == 1) {//我的任务
                [self checkIfNeedLogin];
            } else if (indexPath.row == 2) {//我的收藏
                [self checkIfNeedLogin];
            } else if (indexPath.row == 3) {//我的关注
                [self checkIfNeedLogin];
            }

            break;
        }
        case 3: {//我是买手
            break;
        }
        case 4: {//设置
            break;
        }
        default:
            break;
    }
}

- (BOOL)checkIfNeedLogin {
    if (![APPCONTEXT checkLogin]) {
        KGLoginController *loginController = [UIStoryboard storyboardWithName:@"login" bundle:nil].instantiateInitialViewController;
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:loginController];
        [self presentViewController:nc animated:YES completion:nil];
        return YES;
    } else {
        return NO;
    }
}

@end
