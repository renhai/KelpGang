//
//  KGOrderListController.m
//  KelpGang
//
//  Created by Andy on 14-4-23.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderListController.h"
#import "KGOrderListCell.h"
#import "KGOrderSummaryObject.h"

@interface KGOrderListController ()

@property (nonatomic, strong) NSMutableArray *orderList;

@end

@implementation KGOrderListController

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
    [self setTitle:@"我的订单"];
    self.orderList = [[NSMutableArray alloc]init];
    [self mockData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)mockData {
    for (NSInteger i = 0; i < 20; i ++) {
        KGOrderSummaryObject * obj = [[KGOrderSummaryObject alloc] init];
        obj.orderId = i;
        obj.orderNumber = [NSString stringWithFormat:@"122121212121212%i", i];
        obj.orderDesc = i % 2 == 0 ? @"凯夫拉束带结发拉丝机东方丽景阿斯顿发科技阿什利的客服经理说大家发了卡士大夫" : @"水电费加拉斯的减肥圣";
        obj.orderMoney = 200 + i;
        obj.orderImageUrl = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=5e82a4e40846f21fc9345953c21c6a60/cb8065380cd791231e957e6baf345982b2b780bc.jpg";
        obj.orderStatus = i % 3;
        obj.ownerId = i;
        obj.ownerName = [NSString stringWithFormat:@"用户%i", i];
        obj.ownerAvatar = @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=bd17fb17be315c6043956cefb989ca13/c83d70cf3bc79f3da535b332b8a1cd11738b29df.jpg";
        obj.hasNewNotification = i % 2;
        [self.orderList addObject:obj];
    }
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
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kOrderListCell" forIndexPath:indexPath];
    KGOrderSummaryObject *obj = self.orderList[indexPath.row];
    [cell setObject: obj];
    return cell;
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"买入的订单", @"卖出的订单"]];
    seg.selectedSegmentIndex = 0;
    seg.tintColor = RGBCOLOR(187, 187, 187);
    seg.segmentedControlStyle = UISegmentedControlStyleBordered;
    seg.frame = CGRectMake(20, 10, 280, 29);
    [seg addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    header.backgroundColor = RGBCOLOR(246, 251, 249);
    [header addSubview:seg];
    return header;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 125;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}



#pragma UISegmentedControl

- (void)segmentedControl: (UISegmentedControl *) seg {
    DLog(@"%@", seg);
}


@end
