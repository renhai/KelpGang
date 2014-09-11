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
#import "SVPullToRefresh.h"
#import "KGFilterItem.h"
#import "KGBuyerSummaryObject.h"

static const NSInteger kLimit = 10;

@interface KGBuyerListViewController ()

@property (weak, nonatomic) IBOutlet UIView *conditionBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, assign) BOOL hasmore;

@property (nonatomic, strong) NSString *toCountry;
@property (nonatomic, strong) NSString *city;
@property (nonatomic, strong) NSString *backTime;

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

    self.toCountry = @"";
    self.city = @"";
    self.backTime = @"";

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

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)initFilterBar {
    self.currTapIndex = -1;
    NSArray *timeArr = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻", @"回国时间"];

    __weak typeof(self) weakSelf = self;
    SelectDoneBlock doneBlock = ^(NSInteger index, NSString *item) {
        [weakSelf closeItemByIndex:self.currTapIndex];
        DLog(@"selected index: %d, item : %@", index, item);
        switch (index) {
            case 0: {
                self.toCountry = item;
                if ([@"目的国家" isEqualToString:self.toCountry]) {
                    self.toCountry = @"";
                }
                break;
            }
            case 1:
                self.backTime = [self getBackTimeType:item];
                break;
            case 2: {
                self.city = item;
                if ([@"所在城市" isEqualToString:self.city]) {
                    self.city = @"";
                }
                break;
            }
            default:
                break;
        }
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
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"end_id": @0,
                             @"limit": @(kLimit),
                             @"toCountry": self.toCountry,
                             @"departure_city": self.city,
                             @"type": self.backTime};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/index2" params:params success:^(id responseObject) {
        if ([KGUtils checkResultWithAlert:responseObject]) {
            [self.datasource removeAllObjects];
            self.hasmore = [responseObject[@"hasmore"] boolValue];
            NSArray *data = [self convertBuyerSummary:responseObject];

            [self.datasource addObjectsFromArray:data];
            [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.5];
            [self.tableView reloadData];
            if (self.hasmore) {
                self.tableView.showsInfiniteScrolling = YES;
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self.tableView.pullToRefreshView performSelector:@selector(stopAnimating) withObject:nil afterDelay:0.2];
    }];
}

- (void)insertRowAtBottom {
    KGBuyerSummaryObject *lastObj = self.datasource.lastObject;
    NSInteger endId = lastObj.travelId;
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"end_id": @(endId),
                             @"limit": @(kLimit),
                             @"toCountry": self.toCountry,
                             @"departure_city": self.city,
                             @"type": self.backTime};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/index2" params:params success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        if ([KGUtils checkResultWithAlert:responseObject]) {
            self.hasmore = [responseObject[@"hasmore"] boolValue];
            NSArray *data = [self convertBuyerSummary:responseObject];
            NSMutableArray *indexPaths = [[NSMutableArray alloc] init];
            NSInteger count = [self.datasource count];
            for (NSInteger i = 0; i < data.count; i ++) {
                [indexPaths addObject:[NSIndexPath indexPathForRow:count + i  inSection:0]];
            }
            [self.datasource addObjectsFromArray:data];

            [self.tableView beginUpdates];
            [self.tableView insertRowsAtIndexPaths:indexPaths withRowAnimation:UITableViewRowAnimationFade];
            [self.tableView endUpdates];
            [self.tableView.infiniteScrollingView stopAnimating];
            self.tableView.showsInfiniteScrolling = data.count > 0;
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
        [self.tableView.pullToRefreshView stopAnimating];
        [self.tableView.infiniteScrollingView stopAnimating];
    }];
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
        [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:item.url params:nil success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.view];
            if ([KGUtils checkResultWithAlert:responseObject]) {
                if (item.index == 0) {
                    item.data = [self convertCountryData:responseObject];
                } else if (item.index == 2) {
                    item.data = [self convertCityData:responseObject];
                }
                [item openFilterView];
            }
        } failure:^(NSError *error) {
            DLog(@"error: %@", error);
            [[HudHelper getInstance] hideHudInView:self.view];
        }];
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
        if ([@"热门国家" isEqualToString: continentName]) {
            [countryArr addObject:@"目的国家"];
        }
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
        if ([@"热门城市" isEqualToString: continentName]) {
            [countryArr addObject:@"所在城市"];
        }
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

- (NSString *)getBackTimeType: (NSString *) backTime {
    NSString *type = @"";
    if ([@"常驻" isEqualToString: backTime]) {
        type = @"1";
    } else if ([@"3天内" isEqualToString: backTime]) {
        type = @"2";
    } else if ([@"1周内" isEqualToString: backTime]) {
        type = @"3";
    } else if ([@"2周内" isEqualToString: backTime]) {
        type = @"4";
    } else if ([@"1月内" isEqualToString: backTime]) {
        type = @"5";
    } else if ([@"回国时间" isEqualToString: backTime]) {
        type = @"";
    }
    return type;
}

@end
