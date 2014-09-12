//
//  KGTaskListViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskListViewController.h"
#import "KGTaskListViewCell.h"
#import "KGFilterItem.h"
#import "KGTaskObject.h"
#import "KGTaskDetailController.h"

@interface KGTaskListViewController ()
@property (weak, nonatomic) IBOutlet UIView *conditionBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGTaskListViewController

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
    [self setLeftBarbuttonItem];
    [self setRightBarButtonItems];
    [self initFilterBar];

    [self refreshDatasource];
}

- (void)refreshDatasource {
    if (!self.datasource) {
        self.datasource = [[NSMutableArray alloc] init];
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"end_id": @(0),
                             @"limit":@(100),
                             @"goodCountry": @"",
                             @"liveCity": @"",
                             @"gratuity": @""};
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/task/index2" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResultWithAlert:responseObject]) {
            [self.datasource removeAllObjects];
            NSArray *taskArr = responseObject[@"data"];
            for (NSDictionary *info in taskArr) {
                NSArray *goodsArr = info[@"good_info"];
                NSDictionary *goodsInfo = @{};
                if (goodsArr && [goodsArr count] > 0) {
                    goodsInfo = goodsArr[0];
                }
                NSDictionary *task_info = info[@"task_info"];
                NSDictionary *user_info = info[@"user_info"];
                KGTaskObject *taskObj = [[KGTaskObject alloc] init];
                taskObj.taskId = [task_info[@"task_id"] integerValue];
                taskObj.title = task_info[@"task_title"];
                taskObj.gratuity = [task_info[@"task_gratuity"] floatValue];
                taskObj.deadline = [NSDate dateWithTimeIntervalSince1970:[task_info[@"task_deadline"] doubleValue]];
                taskObj.message = task_info[@"task_message"];
                taskObj.expectCountry = task_info[@"task_good_country"];
                taskObj.maxMoney = [task_info[@"task_money"] floatValue];
                taskObj.defaultImageUrl = goodsInfo[@"good_default_head_url"];
                if (!taskObj.defaultImageUrl) {
                    taskObj.defaultImageUrl = @"";
                }
                taskObj.ownerId = [user_info[@"user_id"] integerValue];
                taskObj.ownerName = user_info[@"user_name"];
                taskObj.ownerCity = task_info[@"task_live_city"];
                if (!taskObj.ownerCity) {
                    taskObj.ownerCity = @"";
                }
                taskObj.ownerHeadUrl = user_info[@"head_url"];
                taskObj.ownerGender = [KGUtils convertGender:user_info[@"user_sex"]];
                [self.datasource addObject:taskObj];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"error: %@", error);
    }];
}

- (void)initFilterBar {
    self.currTapIndex = -1;

    __weak typeof(self) weakSelf = self;
    SelectDoneBlock doneBlock = ^(NSInteger index, NSString *item) {
        [weakSelf closeItemByIndex:self.currTapIndex];
        NSLog(@"selected index: %d, item : %@", index, item);
//        if (weakSelf.tableView.pullToRefreshView.state == SVPullToRefreshStateStopped) {
//            [weakSelf.tableView setContentOffset:CGPointMake(0, 0)];
//            [weakSelf.tableView triggerPullToRefresh];
//        }
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

    KGFilterItem *item2 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth, 0, itemWidth, itemHeight) text:@"跑腿费" data: @[@"升序", @"降序"]];
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


- (void)setRightBarButtonItems {
//    if (![KGUtils isHigherIOS7]) {
//        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
//        negativeSpacer.width = 15;
//        self.navigationItem.rightBarButtonItems = @[negativeSpacer, self.rightBarButtonItem];
//    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self closeItemByIndex:self.currTapIndex];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [self.datasource count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"kTaskListTableViewCell";
    KGTaskObject *obj = self.datasource[indexPath.row];
    KGTaskListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    [cell setObject:obj];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    KGTaskObject *taskObj = self.datasource[indexPath.row];
    KGTaskDetailController *controller = [[KGTaskDetailController alloc]initWithStyle:UITableViewStylePlain];
    controller.taskId = taskObj.taskId;
    [self.navigationController pushViewController:controller animated:YES];

}


#pragma filterbar

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
            NSDictionary *dic = (NSDictionary *)responseObject;
            if (item.index == 0) {
                item.data = [self convertCountryData:dic];
            } else if (item.index == 2) {
                item.data = [self convertCityData:dic];
            }
            [item openFilterView];
            [[HudHelper getInstance] hideHudInView:self.view];
        } failure:^(NSError *error) {
            NSLog(@"Error: %@", error);
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


@end
