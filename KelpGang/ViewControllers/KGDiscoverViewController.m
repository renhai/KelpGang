//
//  KGDiscoverViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverViewController.h"
#import "KGDiscoverCell.h"
#import "KGDiscoverDetailViewController.h"
#import "KGDiscovery.h"
#import "SVPullToRefresh.h"


@interface KGDiscoverViewController ()

@property(nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGDiscoverViewController

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

    [self reshreshThisView];
    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf reshreshThisView];
        [weakSelf.tableView.pullToRefreshView stopAnimating];
    }];
}

- (void)reshreshThisView {
    if (!self.datasource) {
        self.datasource = [NSMutableArray new];
    }
    NSDictionary *params = @{};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/discovery/getDiscoveryLists" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResult:responseObject]) {
            [self.datasource removeAllObjects];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *item in data) {
                KGDiscovery *obj = [[KGDiscovery alloc]init];
                obj.discoveryId = [item[@"id"]integerValue];
                obj.coverUrl = item[@"main_pic_url"];
                [self.datasource addObject:obj];
            }
            [self.tableView reloadData];
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
    KGDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kDiscoverCell" forIndexPath:indexPath];
    KGDiscovery *obj = self.datasource[indexPath.row];
    NSString *imageUrl = obj.coverUrl ? obj.coverUrl : @"";
    [cell.pictureView setImageWithURL:[NSURL URLWithString:imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    KGDiscoverDetailViewController *destController = segue.destinationViewController;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:sender];
    KGDiscovery *discovery = self.datasource[indexPath.row];
    destController.discoveryId = discovery.discoveryId;
}


@end
