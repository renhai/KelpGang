//
//  KGMyCollectViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyCollectViewController.h"
#import "KGMyCollectViewCell.h"
#import "KGCollectObject.h"
#import "KGPhotoBrowserViewController.h"

@interface KGMyCollectViewController () <SWTableViewCellDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGMyCollectViewController

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
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid)};
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/getUserCollections" params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [[HudHelper getInstance] hideHudInView:self.tableView];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            [self.datasource removeAllObjects];
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *info in data) {
                NSDictionary *collection_info = info[@"collection_info"];
                NSArray *good_arr = info[@"good_info"];
                NSDictionary *good_info = @{};
                if (good_arr && good_arr.count > 0) {
                    good_info = good_arr[0];
                }
                KGCollectObject *collectObj = [[KGCollectObject alloc] init];
                collectObj.goodsId = [collection_info[@"collection_good_id"] integerValue];
                collectObj.photoId = [collection_info[@"collection_photo_id"] integerValue];
                collectObj.travelId = [collection_info[@"collection_travel_id"] integerValue];
                collectObj.popularity = [collection_info[@"collection_popularity"] integerValue];
                collectObj.goodsHeadUrl = collection_info[@"good_head_url"];
                collectObj.goodsOrigUrl = good_info[@"good_default_photo_url"];
                collectObj.goodsName = good_info[@"good_name"];
                [self.datasource addObject:collectObj];
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
    KGMyCollectViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMyCollectCell" forIndexPath:indexPath];
    KGCollectObject *collectObj = self.datasource[indexPath.row];
    [cell setObject:collectObj];
    [cell setRightUtilityButtons: [self rightButtons]];
    cell.delegate = self;

    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    KGCollectObject *collectObj = self.datasource[indexPath.row];

    KGPhotoBrowserViewController *controller = [[KGPhotoBrowserViewController alloc]initWithImgUrls:@[[NSURL URLWithString:collectObj.goodsOrigUrl]] index:0];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
}

- (NSArray *)rightButtons {
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"取消收藏"];

    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    [cell hideUtilityButtonsAnimated:YES];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];

    switch (index) {
        case 0: {
            KGCollectObject *collectObj = self.datasource[indexPath.row];
            NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                     @"session_key": APPCONTEXT.currUser.sessionKey,
                                     @"photo_id": @(collectObj.photoId)};
            [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/good/deleteCollection" params: params success:^(id responseObject) {
                DLog(@"%@", responseObject);
                [[HudHelper getInstance] hideHudInView:self.view];
                if ([KGUtils checkResultWithAlert:responseObject]) {
                    [self.tableView beginUpdates];
                    [self.datasource removeObjectAtIndex:indexPath.row];
                    [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            } failure:^(NSError *error) {
                DLog(@"%@", error);
            }];

            DLog(@"delete button clicked: %@", indexPath);
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell {
    return YES;
}



@end
