//
//  KGHostTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-21.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostTableViewController.h"
#import "KGBadgeView.h"
#import "KGRecentContactsController.h"
#import "KGBaseWebViewController.h"
#import "KGSettingViewController.h"
#import "KGHostHeadViewCell.h"

@interface KGHostTableViewController ()

@end

@implementation KGHostTableViewController

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
    switch (indexPath.section) {
        case 0: {
            if ([cell respondsToSelector:@selector(configCell)]) {
                [cell performSelector:@selector(configCell) withObject:nil];
            }
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
    if ([destController isKindOfClass:[KGRecentContactsController class]]) {
        destController.hidesBottomBarWhenPushed = YES;
    }
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    switch (indexPath.section) {
        case 0:
            break;
        case 1:
            break;
        case 2: {
            if (indexPath.row == 1) {//我的任务
                KGBaseWebViewController *taskController = [[KGBaseWebViewController alloc] initWithWebPath:@"/html/gj_task.htm"];
                taskController.hidesBottomBarWhenPushed = YES;
                taskController.isPullToRefresh = YES;
                [taskController setLeftBarbuttonItem];
                [taskController setTitle:@"我的任务"];
                [self.navigationController pushViewController:taskController animated:YES];
            } else if (indexPath.row == 2) {//我的收藏
                KGBaseWebViewController *collectController = [[KGBaseWebViewController alloc] initWithWebPath:@"/html/gj_collect.htm"];
                collectController.hidesBottomBarWhenPushed = YES;
                collectController.isPullToRefresh = YES;
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
            settingController.hidesBottomBarWhenPushed = YES;
            [settingController setLeftBarbuttonItem];
            [settingController setTitle:@"设置"];
            [self.navigationController pushViewController:settingController animated:YES];
            break;
        }
        default:
            break;
    }
}

@end
