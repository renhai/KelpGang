//
//  KGFindKelpViewController.m
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerListViewController.h"
#import "KGBuyerListViewCell.h"
#import "KGBuyerInfoViewController.h"
#import "XMPPManager.h"
#import "SVPullToRefresh.h"
#import "HudHelper.h"
#import "KGFilterItem.h"
#import "KGBuyerSummaryObject.h"

static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController ()

@property (weak, nonatomic) IBOutlet UIView *conditionBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, assign) BOOL hasmore;

@end

@implementation KGBuyerListViewController

-(void) dealloc {

}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self initFilterBar];

    __weak typeof(self) weakSelf = self;
    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshDatasource];
    }];
    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    self.tableView.showsPullToRefresh = YES;
    self.tableView.showsInfiniteScrolling = NO;

    self.datasource = [[NSMutableArray alloc] init];
    [self.tableView triggerPullToRefresh];
}

- (void)mockData {
    for (NSInteger i = 0; i < 20; i ++) {
        KGBuyerSummaryObject *obj = [[KGBuyerSummaryObject alloc]init];
        obj.userId = i;
        obj.userName = [NSString stringWithFormat:@"用户%i", i];
        obj.avatarUrl = @"http://d.hiphotos.baidu.com/image/pic/item/ac6eddc451da81cb5ab9c2ac5066d01609243177.jpg";
        obj.gender = i % 2;
        obj.level = i % 10;
        obj.routeDuration = @"11.12-3.20";
        obj.fromCountry = @"加拿大";
        obj.toCountry = @"澳大利亚";
        obj.desc = @"是对伐啦圣诞节法拉盛地方时间段飞拉萨京东方流口水";
        [self.datasource addObject:obj];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initFilterBar {
    self.currTapIndex = -1;
    NSArray *timeArr = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻"];

    __weak typeof(self) weakSelf = self;
    SelectDoneBlock doneBlock = ^(NSInteger index, NSString *item) {
        [weakSelf closeItemByIndex:self.currTapIndex];
        NSLog(@"selected index: %d, item : %@", index, item);
        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateStopped) {
            [weakSelf.tableView setContentOffset:CGPointMake(0, 0)];
            [weakSelf.tableView triggerPullToRefresh];
        }
    };

    VoidBlock closeBlock = ^ () {
        weakSelf.currTapIndex = -1;
    };

    OpenBlock openBlock = ^ (NSInteger index) {
        weakSelf.currTapIndex = index;
    };

    CGFloat itemWidth = self.conditionBar.width / 3;
    CGFloat itemHeight = self.conditionBar.height - 1;

    KGFilterItem *item1 = [[KGFilterItem alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight) text:@"目的国家" data:nil];
    item1.canvasView = self.view;
    item1.index = 0;
    item1.type = KGFilterViewCascadeStyle;
    item1.url = @"/mobile/common/getCountryList";
    item1.selectDoneBlock = doneBlock;
    item1.closeBlock = closeBlock;
    item1.openBlock = openBlock;
    [item1 addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];

    KGFilterItem *item2 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth, 0, itemWidth, itemHeight) text:@"回国时间" data: timeArr];
    item2.canvasView = self.view;
    item2.index = 1;
    item2.type = KGFilterViewCommonStyle;
    item2.selectDoneBlock = doneBlock;
    item2.closeBlock = closeBlock;
    item2.openBlock = openBlock;
    [item2 addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];

    KGFilterItem *item3 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth * 2, 0, itemWidth, itemHeight) text:@"所在城市" data:nil];
    item3.canvasView = self.view;
    item3.index = 2;
    item3.type = KGFilterViewCascadeStyle;
    item3.url = @"/mobile/common/getCityList";
    item3.selectDoneBlock = doneBlock;
    item3.closeBlock = closeBlock;
    item3.openBlock = openBlock;
    [item3 addTarget:self action:@selector(didTap:) forControlEvents:UIControlEventTouchUpInside];

    UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(0, self.conditionBar.height - 1, self.conditionBar.width, LINE_HEIGHT)];

    [self.conditionBar addSubview:item1];
    [self.conditionBar addSubview:item2];
    [self.conditionBar addSubview:item3];
    [self.conditionBar addSubview:bottomLine];
    [self.conditionBar sendSubviewToBack:bottomLine];

}

- (void)refreshDatasource {
    if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
        NSDictionary *params = @{@"user_id": @0, @"endId": @0, @"limit": @20};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/index" params:params success:^(id responseObject) {
//            NSLog(@"%@", responseObject);
            [self.datasource removeAllObjects];
            NSDictionary *dic = (NSDictionary *)responseObject;
            self.hasmore = [dic[@"hasmore"] boolValue];
            NSArray *data = [self convertBuyerSummary:dic];

            [self.datasource addObjectsFromArray:data];
            [self.tableView reloadData];
            [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
            if (self.hasmore) {
                self.tableView.showsInfiniteScrolling = YES;
            }
        } failure:^(NSError *error) {
            NSLog(@"%@", error);
            [[HudHelper getInstance] showHudOnView:self.view caption:@"系统错误,请稍后再试" image:nil acitivity:NO autoHideTime:1.6];
        }];
    }
}

- (void)insertRowAtBottom {
    __weak KGBuyerListViewController *weakSelf = self;
    if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf.tableView beginUpdates];
            NSInteger count = [self.datasource count];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            for (NSInteger i = 0; i < 20; i ++) {
                KGBuyerSummaryObject *obj = [[KGBuyerSummaryObject alloc]init];
                obj.userId = i;
                obj.userName = [NSString stringWithFormat:@"用户%i", i];
                obj.avatarUrl = @"";
                obj.gender = i % 2;
                obj.level = i % 5;
                obj.routeDuration = @"12.12-12.25";
                obj.fromCountry = @"";
                obj.toCountry = @"澳大利亚";
                obj.desc = @"是对伐啦圣诞节法拉盛地方时间段飞拉萨京东方流口水";
                [self.datasource addObject:obj];
                [indexPaths addObject:[NSIndexPath indexPathForRow:count + i  inSection:0]];
            }
            [weakSelf.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [weakSelf.tableView endUpdates];

            [weakSelf.tableView.infiniteScrollingView stopAnimating];
        });
    } else {
        [weakSelf.tableView.infiniteScrollingView stopAnimating];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    NSIndexPath *indexPath = [self.tableView indexPathForSelectedRow];
    KGBuyerSummaryObject *obj = self.datasource[indexPath.row];
    KGBuyerInfoViewController *detailController = segue.destinationViewController;
    detailController.travelId = obj.travelId;
    [detailController setHidesBottomBarWhenPushed:YES];

//    BOOL connect = [[XMPPManager sharedInstance] connect];
//    NSLog(@"prepareForSegue, connect: %d", connect);
//    NSLog(@"prepareForSegue, isXmppConnected: %d", [[XMPPManager sharedInstance] isXmppConnected]);

}

#pragma UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"kBuyerListViewCell";

    KGBuyerListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    KGBuyerSummaryObject *obj = self.datasource[indexPath.row];
    [cell setObject:obj];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (void)didTap: (KGFilterItem *)item {
    if (self.currTapIndex == -1) {
        [self openItem:item];
    } else if (self.currTapIndex == item.index) {
        [item closeFilterView];
    } else {
        [self closeItemByIndex:self.currTapIndex];
        [self openItem:item];
    }
}

- (void)openItem:(KGFilterItem *) item {
    if (item.data) {
        [item openFilterView];
    } else {
        if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
            [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
            [[KGNetworkManager sharedInstance] postRequest:item.url params:nil success:^(id responseObject) {
                NSDictionary *dic = (NSDictionary *)responseObject;
//                NSLog(@"%@", dic);
                if (item.index == 0) {
                    item.data = [self convertCountryData:dic];
                } else if (item.index == 2) {
                    item.data = [self convertCityData:dic];
                }
                [item openFilterView];
                [[HudHelper getInstance] hideHudInView:self.view];
            } failure:^(NSError *error) {
//                NSLog(@"Error: %@", error);
                [[HudHelper getInstance] showHudOnView:self.view caption:@"系统错误,请稍后再试" image:nil acitivity:NO autoHideTime:1.6];
            }];
        }
    }
}

- (NSArray *)convertCountryData: (NSDictionary *)dic {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *data = dic[@"data"];
    for (NSDictionary *one in data) {
        NSMutableDictionary *oneDic = [NSMutableDictionary dictionary];
        NSString *continentName = one[@"continent_name"];
        if (!continentName) {
            continue;
        }
        NSArray *countryInfo = one[@"country_info"];
        NSMutableArray *countryArr = [NSMutableArray array];
        for (NSDictionary *country in countryInfo) {
            NSString *countryName = country[@"country_name"];
            [countryArr addObject:countryName];
        }

        [oneDic setObject:continentName forKey:@"firstLevel"];
        [oneDic setObject:countryArr forKey:@"secondLevel"];
        [result addObject:oneDic];
    }
    return result;
}

- (NSArray *)convertCityData: (NSDictionary *)dic {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *data = dic[@"data"];
    for (NSDictionary *one in data) {
        NSMutableDictionary *oneDic = [NSMutableDictionary dictionary];
        NSString *continentName = one[@"province_name"];
        if (!continentName) {
            continue;
        }
        NSArray *countryInfo = one[@"city_info"];
        NSMutableArray *countryArr = [NSMutableArray array];
        for (NSDictionary *country in countryInfo) {
            NSString *countryName = country[@"city_name"];
            [countryArr addObject:countryName];
        }

        [oneDic setObject:continentName forKey:@"firstLevel"];
        [oneDic setObject:countryArr forKey:@"secondLevel"];
        [result addObject:oneDic];
    }
    return result;
}

- (void)closeItemByIndex:(NSInteger) index {
    for (UIView *view in self.conditionBar.subviews) {
        if ([view isKindOfClass:[KGFilterItem class]]) {
            KGFilterItem *fItem = (KGFilterItem *)view;
            if (fItem.index == index) {
                [fItem closeFilterView];
                break;
            }
        }
    }
}

- (NSArray *)convertBuyerSummary: (NSDictionary *)dic {
    NSMutableArray *result = [NSMutableArray array];
    NSArray *data = dic[@"data"];
    if (data) {
        for (NSDictionary *one in data) {
            KGBuyerSummaryObject *obj = [[KGBuyerSummaryObject alloc]init];
            NSDictionary *travelInfo = one[@"travel_info"];
            if (travelInfo) {
                obj.travelId = [travelInfo[@"travel_id"] integerValue];
                obj.fromCountry = travelInfo[@"from"];
                obj.toCountry = travelInfo[@"to"];
                obj.desc = travelInfo[@"travel_desc"];
                double startTime = [travelInfo[@"travel_start_time"] doubleValue];
                double endTime = [travelInfo[@"travel_back_time"] doubleValue];
                obj.routeDuration = [self routeDuration:startTime endTime:endTime];
            }
            NSDictionary *userInfo = one[@"user_info"];
            if (userInfo) {
                obj.userId = [userInfo[@"user_id"] integerValue];
                obj.userName = userInfo[@"user_name"];
                obj.avatarUrl = userInfo[@"head_url"];
                obj.gender = [@"M" isEqualToString:userInfo[@"user_sex"]] ? MALE : FEMALE;
                obj.level = [userInfo[@"user_star"] integerValue];
            }
            [result addObject:obj];
        }
    }
    return result;
}

- (NSString *)routeDuration: (double) startTime endTime: (double)endTime {
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M.d"];
    NSString *result = [NSString stringWithFormat:@"%@-%@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    return result;
}



@end
