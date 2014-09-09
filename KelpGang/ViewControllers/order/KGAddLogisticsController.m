//
//  KGAddLogisticsController.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddLogisticsController.h"
#import "KGOrderNumberAndDateCell.h"
#import "KGOrderObject.h"
#import "KGLogisticsCell.h"
#import "KGConfirmReceiptController.h"


@interface KGAddLogisticsController ()

@property (nonatomic, strong) NSString *logisticsCompany;
@property (nonatomic, strong) NSString *logisticsNumber;


@end

@implementation KGAddLogisticsController

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
    [self setTitle:@"物流信息"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }

    self.tableView.tableFooterView = [self renderFooterView];
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
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            NSString *reuseId = @"orderNumberAndDateCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderNumberAndDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            NSArray *obj = @[self.orderObj.orderNumber, self.orderObj.orderDate];
            [cell setObject:obj];
            break;
        }
        case 1: {
            NSString *reuseId = @"logisticsCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGLogisticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            [cell setObject:nil];

            KGLogisticsCell *lCell = (KGLogisticsCell *) cell;
            [lCell.logisticsCompanyTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            [lCell.logisticsNumberTF addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            break;
        }
        default:
            cell = [[KGTableViewCell alloc]init];
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;

}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case 0:
            height = 54;
            break;
        case 1:
            height = 106;
            break;
        default:
            height = 44;
            break;
    }
    return height;
}

- (UIView *)renderFooterView {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 120)];
    footer.backgroundColor = [UIColor whiteColor];

    UIButton *button1 = [[UIButton alloc] initWithFrame:CGRectMake(15, 60, 130, 37)];
    button1.backgroundColor = MAIN_COLOR;
    button1.showsTouchWhenHighlighted = YES;
    [button1 setTitle:@"确认" forState:UIControlStateNormal];
    [button1 addTarget:self action:@selector(confirmLogistics:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button1];

    UIButton *button2 = [[UIButton alloc] initWithFrame:CGRectMake(button1.right + 20, button1.top, button1.width, button1.height)];
    button2.backgroundColor = MAIN_COLOR;
    button2.showsTouchWhenHighlighted = YES;
    [button2 setTitle:@"跳过" forState:UIControlStateNormal];
    [button2 addTarget:self action:@selector(skipLogistics:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button2];

    return footer;
}

- (BOOL)isBuyer {
    return self.orderObj.buyerId == APPCONTEXT.currUser.uid;
}

- (void)textFieldChanged: (UITextField *)sender {
    if (sender.tag == 1001) {
        self.logisticsCompany = sender.text;
    } else if (sender.tag == 1002) {
        self.logisticsNumber = sender.text;
    }
}

- (void)confirmLogistics: (UIButton *) sender {
    if ((!self.logisticsCompany || [@"" isEqualToString:self.logisticsCompany])
        || (!self.logisticsNumber || [@"" isEqualToString:self.logisticsNumber])) {

        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"物流信息不完整" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"orderId": @(self.orderObj.orderId),
                             @"company": self.logisticsCompany,
                             @"logistics_number": self.logisticsNumber};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/addLogistics" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            KGConfirmReceiptController *destController = [[KGConfirmReceiptController alloc] initWithStyle:UITableViewStylePlain];
            destController.orderId = self.orderObj.orderId;
            [self.navigationController pushViewController:destController animated:YES];

            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [controllers removeObjectsInRange:NSMakeRange(controllers.count - 3, 2)];
            [self.navigationController setViewControllers:controllers];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];

}

- (void)skipLogistics: (UIButton *) sender {
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"orderId": @(self.orderObj.orderId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/skip" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            KGConfirmReceiptController *destController = [[KGConfirmReceiptController alloc] initWithStyle:UITableViewStylePlain];
            destController.orderId = self.orderObj.orderId;
            [self.navigationController pushViewController:destController animated:YES];

            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [controllers removeObjectsInRange:NSMakeRange(controllers.count - 3, 2)];
            [self.navigationController setViewControllers:controllers];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


@end
