//
//  KGPayOrderController.m
//  KelpGang
//
//  Created by Andy on 14-9-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGPayOrderController.h"
#import "KGOrderObject.h"
#import "KGOrderListController.h"
#import "KGOrderPurchaseController.h"


@interface KGPayOrderController ()

@end

@implementation KGPayOrderController

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
    [self setTitle:@"支付"];
    [self setLeftBarbuttonItem];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];

    if (indexPath.row == 1) {
        UILabel *totalMoneyLbl = (UILabel *)[cell viewWithTag:100];
        totalMoneyLbl.text = [NSString stringWithFormat:@"￥%0.2f", self.orderObj.totalMoney];
        [totalMoneyLbl sizeToFit];
    }
    return cell;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 65.0)];
    footer.backgroundColor = [UIColor whiteColor];

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 20, 290, 37)];
    button.backgroundColor = MAIN_COLOR;
    button.showsTouchWhenHighlighted = YES;
    [button setTitle:@"去支付付款" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(payOrder:) forControlEvents:UIControlEventTouchUpInside];

    [footer addSubview:button];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 80.0;
}

- (void)payOrder: (UIButton *)sender {
//    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
//                             @"session_key": APPCONTEXT.currUser.sessionKey,
//                             @"order_id": @(self.orderObj.orderId)};
//    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
//    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/receiverPay" params:params success:^(id responseObject) {
//        DLog(@"%@", responseObject);
//        [[HudHelper getInstance] hideHudInView:self.view];
//        if ([KGUtils checkResultWithAlert:responseObject]) {
//            NSDictionary *data = responseObject[@"data"];
//            NSInteger orderStatus = [data[@"order_status"] integerValue];
//            self.orderObj.orderStatus = orderStatus;
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"支付完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
//            [alert show];
//        }
//    } failure:^(NSError *error) {
//        NSLog(@"%@", error);
//    }];

    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"支付完成" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    [alert show];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
//    for (UIViewController *temp in self.navigationController.viewControllers) {
//        if ([temp isKindOfClass:[KGOrderListController class]]) {
//            [self.navigationController popToViewController:temp animated:NO];
//        }
//    }
    KGOrderPurchaseController *destController = [[KGOrderPurchaseController alloc]initWithStyle:UITableViewStylePlain];
    destController.orderId = self.orderObj.orderId;
    [self.navigationController pushViewController:destController animated:YES];

    NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
    [controllers removeObjectsInRange:NSMakeRange(controllers.count - 3, 2)];
    [self.navigationController setViewControllers:controllers];
}

@end
