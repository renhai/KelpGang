//
//  KGMyFollowViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyFollowViewController.h"
#import "KGMyFollowCell.h"
#import "KGUserFollowObject.h"

@interface KGMyFollowViewController ()

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGMyFollowViewController

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
    [self refreshDatasource];
}

- (void)refreshDatasource {
    if (!self.datasource) {
        self.datasource = [[NSMutableArray alloc]init];
    }
    [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/getFollowUsers" params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [[HudHelper getInstance] hideHudInView:self.tableView];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            [self.datasource removeAllObjects];
            NSDictionary *data = responseObject[@"data"];
            NSArray *userArr = data[@"user_info"];
            for (NSDictionary *info in userArr) {
                KGUserFollowObject *userObj = [[KGUserFollowObject alloc]init];
                userObj.uid = [info[@"user_id"] integerValue];
                userObj.uname = info[@"user_name"];
                userObj.avatarUrl = info[@"head_url"];
                userObj.intro = info[@"user_desc"];
                userObj.gender = [KGUtils convertGender:info[@"user_sex"]];
                userObj.isFollowed = YES;
                [self.datasource addObject:userObj];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGMyFollowCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMyFollowViewCell" forIndexPath:indexPath];
    KGUserFollowObject *obj = self.datasource[indexPath.row];
    [cell setObject:obj];
    [cell.followBtn addTarget:self action:@selector(unfollow:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 64.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)unfollow: (UIButton *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
//    if (![KGUtils isHigherIOS7]) {
//        cell = (UITableViewCell *)sender.superview.superview;
//    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    KGUserFollowObject *userObj = self.datasource[indexPath.row];
    NSInteger followId = userObj.uid;
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"follow_id": @(followId),
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    if (userObj.isFollowed) {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/disFollow" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"取消关注成功" dismissAfter:2.0];
                userObj.isFollowed = NO;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    } else {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/follow" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"关注成功" dismissAfter:2.0];
                userObj.isFollowed = YES;
                [self.tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }
}

@end
