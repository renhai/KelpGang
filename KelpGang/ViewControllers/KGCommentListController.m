//
//  KGCommentListController.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentListController.h"
#import "KGCommentListCell.h"
#import "KGCommentObject.h"

@interface KGCommentListController ()

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGCommentListController

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
    self.datasource = [NSMutableArray new];
    NSDictionary *params = @{@"to_id": @(self.userId),
                             @"start": @0,
                             @"limit": @50};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/getCommentList" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *one in data) {
                KGCommentObject *obj = [[KGCommentObject alloc]init];
                obj.toUserId = self.userId;
                obj.content = one[@"content"];
                obj.fromUserId = [one[@"user_id"] integerValue];
                obj.fromUserName = one[@"user_name"] ;
                obj.fromUserHeadUrl = one[@"head_url"] ;
                obj.fromUserGender = [KGUtils convertGender:one[@"gender"]];
                obj.star = [one[@"star"] integerValue];
                obj.createTime = [NSDate dateWithTimeIntervalSince1970:[one[@"create_time"] doubleValue]];
                [self.datasource addObject:obj];
            }

            [self.tableView reloadData];
            [self setTitle:[NSString stringWithFormat:@"评论(%d)", self.datasource.count]];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
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
    KGCommentListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kCommentListCell" forIndexPath:indexPath];
    KGCommentObject *obj = self.datasource[indexPath.row];
    [cell setObject:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 84.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



@end
