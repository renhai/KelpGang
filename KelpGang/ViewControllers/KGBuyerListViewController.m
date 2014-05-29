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
#import "KGFilterBar.h"
#import "KGBuyerSummaryObject.h"
#import "AFHTTPRequestOperationManager.h"


static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController () <KGFilterBarDelegate>

@property (weak, nonatomic) IBOutlet UIView *conditionBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datasource;

@property (nonatomic, strong) NSArray *countryArr;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) KGFilterBar *filterBar;


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

    [self initDatasource];

    __weak KGBuyerListViewController *weakSelf = self;

    [self.tableView addPullToRefreshWithActionHandler:^{
        [weakSelf refreshDatasource];
    }];

    [self.tableView addInfiniteScrollingWithActionHandler:^{
        [weakSelf insertRowAtBottom];
    }];
    self.tableView.showsPullToRefresh = YES;
    self.tableView.showsInfiniteScrolling = NO;
}

- (void)mockData {
    for (NSInteger i = 0; i < 20; i ++) {
        KGBuyerSummaryObject *obj = [[KGBuyerSummaryObject alloc]init];
        obj.userId = i;
        obj.userName = [NSString stringWithFormat:@"用户%i", i];
        obj.avatarUrl = @"http://d.hiphotos.baidu.com/image/pic/item/ac6eddc451da81cb5ab9c2ac5066d01609243177.jpg";
        obj.gender = i % 2;
        obj.level = i % 10;
        obj.country = @"台湾";
        obj.routeDuration = @"11.12-3.20";
        obj.fromCountry = @"加拿大";
        obj.toCountry = @"澳大利亚";
        obj.desc = @"是对伐啦圣诞节法拉盛地方时间段飞拉萨京东方流口水";
        [self.datasource addObject:obj];
    }

//    AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
//    [manager POST:@"/mobile/common/getCountryList" parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        NSDictionary *dic = (NSDictionary *)responseObject;
//        NSLog(@"Result: %@", dic);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"Error: %@", error);
//    }];

    NSMutableArray *mutableOperations = [NSMutableArray array];
    NSArray *requestUrls = @[@"/mobile/common/getCountryList",
                             @"/mobile/common/getCityList"];
    for (NSString *path in requestUrls) {
        NSMutableURLRequest *req = [[AFHTTPRequestSerializer serializer] requestWithMethod:@"POST" URLString:[NSString stringWithFormat:@"%@%@", kWebServerBaseURL, path] parameters:nil error:nil];
        AFHTTPRequestOperation *op = [[AFHTTPRequestOperation alloc] initWithRequest:req];
        op.responseSerializer = [AFJSONResponseSerializer serializer];
        [op setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            NSLog(@"%@", responseObject);
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            NSLog(@"%@", error);
        }];
        [mutableOperations addObject:op];
    }

    NSArray *operations = [AFURLConnectionOperation batchOfRequestOperations:mutableOperations progressBlock:^(NSUInteger numberOfFinishedOperations, NSUInteger totalNumberOfOperations) {
        NSLog(@"%i of %i complete", numberOfFinishedOperations, totalNumberOfOperations);
    } completionBlock:^(NSArray *operations) {
        NSLog(@"All operations in batch complete");
    }];

    [[NSOperationQueue mainQueue] addOperations:operations waitUntilFinished:NO];

}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterBar closeCurrFilterView];
}

- (void)initFilterBar {
    self.countryArr = @[@{@"firstLevel": @"热门国家",@"secondLevel": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]},
                        @{@"firstLevel": @"亚洲",@"secondLevel": @[@"日本",@"韩国",@"泰国"]},
                        @{@"firstLevel": @"欧洲",@"secondLevel": @[@"英国",@"法国",@"意大利",@"德国"]},
                        @{@"firstLevel": @"非洲",@"secondLevel": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                        @{@"firstLevel": @"北美洲",@"secondLevel": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                        @{@"firstLevel": @"南美洲",@"secondLevel": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]},
                        @{@"firstLevel": @"大洋洲",@"secondLevel": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊", @"八个字的国家啊哈"]}];
    self.cityArr = @[@{@"firstLevel": @"热门城市",@"secondLevel": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                     @{@"firstLevel": @"华东",@"secondLevel": @[@"石家庄",@"邯郸",@"北京"]},
                     @{@"firstLevel": @"华北",@"secondLevel": @[@"英国",@"法国",@"意大利",@"德国"]},
                     @{@"firstLevel": @"华南",@"secondLevel": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                     @{@"firstLevel": @"西部",@"secondLevel": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                     @{@"firstLevel": @"其他",@"secondLevel": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
    self.timeArr = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻"];


    CGFloat itemWidth = 320.0 / 3;
    CGFloat itemHeight = self.conditionBar.height - 1;
    KGFilterItem *item1 = [[KGFilterItem alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight) text:@"目的国家" data:self.countryArr];
    item1.canvasView = self.view;
    item1.index = 0;
    item1.type = KGFilterViewCascadeStyle;

    KGFilterItem *item2 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth, 0, itemWidth, itemHeight) text:@"回国时间" data: self.timeArr];
    item2.canvasView = self.view;
    item2.index = 1;
    item2.type = KGFilterViewCommonStyle;

    KGFilterItem *item3 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth * 2, 0, itemWidth, itemHeight) text:@"所在城市" data:self.cityArr];
    item3.canvasView = self.view;
    item3.index = 2;
    item3.type = KGFilterViewCascadeStyle;

    KGFilterBar *filterBar = [[KGFilterBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37) items:@[item1, item2, item3]];
    filterBar.delegate = self;
    self.filterBar = filterBar;
    [self.conditionBar addSubview:self.filterBar];
}

- (void)initDatasource {
    self.datasource = [[NSMutableArray alloc] init];

    if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
        [[HudHelper getInstance] showHudOnView:self.view caption:@"Loading" image:nil acitivity:YES autoHideTime:0.0];
        //TODO
        __weak KGBuyerListViewController *weakSelf = self;
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [weakSelf mockData];
            [weakSelf.tableView reloadData];
            [[HudHelper getInstance] hideHudInView:self.view];
            if (weakSelf.datasource.count >= 5) {
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
        });
    }
}

- (void)refreshDatasource {
    __weak KGBuyerListViewController *weakSelf = self;
    if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
        int64_t delayInSeconds = 2.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            [self.datasource removeAllObjects];
            [self mockData];
            [weakSelf.tableView reloadData];
            [weakSelf.tableView.pullToRefreshView stopAnimating];
            if (weakSelf.datasource.count >= 5) {
                weakSelf.tableView.showsInfiniteScrolling = YES;
            }
        });
    } else {
        [weakSelf.tableView.pullToRefreshView stopAnimating];
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
                obj.country = @"澳大利亚";
                obj.routeDuration = @"12.12-12.25";
                obj.fromCountry = @"";
                obj.toCountry = @"常驻澳大利亚";
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
    KGBuyerInfoViewController *detailController = segue.destinationViewController;
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

#pragma KGFilterBarDelegate

- (void) didSelectFilter:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
    if (self.tableView.pullToRefreshView.state == SVPullToRefreshStateStopped) {
        [self.tableView setContentOffset:CGPointMake(0, 0)];
        [self.tableView triggerPullToRefresh];
    }
}



@end
