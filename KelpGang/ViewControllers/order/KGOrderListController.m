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
#import "KGOrderConfirmViewController.h"
#import "KGOrderPurchaseController.h"
#import "KGConfirmReceiptController.h"


@interface KGOrderListController ()

@property (nonatomic, strong) NSMutableArray *orderList;
@property (nonatomic, assign) NSInteger segType;

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
    self.segType = 0;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self refreshDatasource];
}

- (void)refreshDatasource {
    self.orderList = [[NSMutableArray alloc]init];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    NSString *postUrl = self.segType == 0 ? @"/mobile/order/getBuyOrders" : @"/mobile/order/getSellOrders";
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:postUrl params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSArray *data = responseObject[@"data"];
            for (NSDictionary *one in data) {
                KGOrderSummaryObject * obj = [[KGOrderSummaryObject alloc] init];
                obj.orderId = [one[@"order_id"] integerValue];
                obj.orderNumber = one[@"order_number"];
                obj.orderDesc = one[@"title"];
                obj.orderMoney = [one[@"total_money"] floatValue];
                obj.orderImageUrl = one[@"goods_pic"];
                obj.orderStatus = [one[@"order_status"] integerValue];
                obj.userId = [one[@"user_id"]integerValue];
                obj.userName = one[@"user_name"];
                obj.userAvatar = one[@"head_url"];
                obj.hasNewNotification = NO;
                [self.orderList addObject:obj];
            }
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
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
    return self.orderList.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGOrderListCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kOrderListCell" forIndexPath:indexPath];
    KGOrderSummaryObject *obj = self.orderList[indexPath.row];
    [cell setObject: obj];
    UITapGestureRecognizer *gesture1 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [cell.nameLabel addGestureRecognizer:gesture1];
    UITapGestureRecognizer *gesture2 = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapHeader:)];
    [cell.headImageView addGestureRecognizer:gesture2];
    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49.0;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"买入的订单", @"卖出的订单"]];
    seg.selectedSegmentIndex = self.segType;
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

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    return indexPath;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    KGOrderSummaryObject *obj = self.orderList[indexPath.row];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"order_id": @(obj.orderId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/getOrderStatus" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            obj.orderStatus = [data[@"orderStatus"] integerValue];
            if (obj.orderStatus == WAITING_CONFIRM || obj.orderStatus == WAITING_PAID) {
                KGOrderConfirmViewController *controller = [[KGOrderConfirmViewController alloc]initWithStyle:UITableViewStylePlain];
                controller.orderId = obj.orderId;
                [self.navigationController pushViewController:controller animated:YES];
            } else if (obj.orderStatus == PURCHASING || obj.orderStatus == RETURNING) {
                KGOrderPurchaseController *controller = [[KGOrderPurchaseController alloc]initWithStyle:UITableViewStylePlain];
                controller.orderId = obj.orderId;
                [self.navigationController pushViewController:controller animated:YES];
            } else if (obj.orderStatus == WAITING_RECEIPT || obj.orderStatus == COMPLETED) {
                KGConfirmReceiptController *controller = [[KGConfirmReceiptController alloc] init];
                controller.orderId = obj.orderId;
                [self.navigationController pushViewController:controller animated:YES];
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

#pragma UISegmentedControl

- (void)segmentedControl: (UISegmentedControl *) seg {
    DLog(@"%@", seg);
    self.segType = seg.selectedSegmentIndex;
    [self refreshDatasource];
}


#pragma tap header 

- (void)tapHeader: (UITapGestureRecognizer *)gesture {
    CGPoint point = [gesture.view convertPoint:CGPointZero toView:self.tableView];
    NSIndexPath *indexPath = [self.tableView indexPathForRowAtPoint:point];
    KGOrderListCell *cell = (KGOrderListCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    NSLog(@"%@", cell.orderSummaryObj.userName);
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UIViewController *chatController = [main instantiateViewControllerWithIdentifier:@"kChatViewController"];
    [self.navigationController pushViewController:chatController animated:YES];
}

@end
