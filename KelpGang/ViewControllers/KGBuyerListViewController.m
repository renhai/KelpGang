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
#import "UIImageView+WebCache.h"
#import "KGConditionBar.h"
#import "SVPullToRefresh.h"
#import "HudHelper.h"


static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController () <KGConditionDelegate>

@property (weak, nonatomic) IBOutlet KGConditionBar *conditionBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *datasource;

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
    self.conditionBar.canvasView = self.view;
    self.conditionBar.delegate = self;
    self.conditionBar.countryArr = @[@{@"continent": @"热门国家",@"country": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]},
                        @{@"continent": @"亚洲",@"country": @[@"日本",@"韩国",@"泰国"]},
                        @{@"continent": @"欧洲",@"country": @[@"英国",@"法国",@"意大利",@"德国"]},
                        @{@"continent": @"非洲",@"country": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                        @{@"continent": @"北美洲",@"country": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                        @{@"continent": @"南美洲",@"country": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]},
                        @{@"continent": @"大洋洲",@"country": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊", @"八个字的国家啊哈"]}];
    self.conditionBar.cityArr = @[@{@"region": @"热门城市",@"city": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                     @{@"region": @"华东",@"city": @[@"石家庄",@"邯郸",@"北京"]},
                     @{@"region": @"华北",@"city": @[@"英国",@"法国",@"意大利",@"德国"]},
                     @{@"region": @"华南",@"city": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                     @{@"region": @"西部",@"city": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                     @{@"region": @"其他",@"city": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
    self.conditionBar.timeArr = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻"];
    self.conditionBar.titles = @[@"目的国家", @"回国时间", @"所在城市"];
    [self.conditionBar initBarItems];

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

- (void)initDatasource {
    self.datasource = [[NSMutableArray alloc] init];

    if ([KGUtils checkIsNetworkConnectionAvailableAndNotify:self.view]) {
        [[HudHelper getInstance] showHudOnView:self.view caption:@"Loading" image:nil acitivity:YES autoHideTime:0.0];
        //TODO
        __weak KGBuyerListViewController *weakSelf = self;
        int64_t delayInSeconds = 1.0;
        dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
        dispatch_after(popTime, dispatch_get_main_queue(), ^(void){
            for (NSInteger i = 0; i < 5; i ++) {
                [weakSelf.datasource addObject: [NSString stringWithFormat:@"%d", i]];
            }
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
            for (NSInteger i = 0; i < 5; i ++) {
                [weakSelf.datasource addObject: [NSString stringWithFormat:@"%d", i]];
            }
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
            [weakSelf.datasource addObject: [NSString stringWithFormat:@"%d", 0]];
            [weakSelf.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:weakSelf.datasource.count-1 inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
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
    if (cell == nil) {
        cell = [[KGBuyerListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.headImageView.clipsToBounds = YES;
    cell.headImageView.ContentMode = UIViewContentModeScaleAspectFill;
    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=828c8a708544ebf86d71633fedc1d62a/5882b2b7d0a20cf4d8414dac74094b36adaf99f4.jpg"] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}


@end
