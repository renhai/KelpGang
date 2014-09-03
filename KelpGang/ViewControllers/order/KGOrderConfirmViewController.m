//
//  KGOrderConfirmViewController.m
//  KelpGang
//
//  Created by Andy on 14-9-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGOrderConfirmViewController.h"
#import "KGOrderNumberAndDateCell.h"
#import "KGOrderObject.h"
#import "KGAddressObject.h"
#import "KGOrderAddressCell.h"
#import "KGOrderLeftRightCell.h"
#import "KGOrderTotalMoneyCell.h"
#import "KGOrderImageCell.h"
#import "KGCreateOrderController.h"


@interface KGOrderConfirmViewController ()

@property (nonatomic, strong) KGOrderObject *orderObj;

@end

@implementation KGOrderConfirmViewController

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
    [self setTitle:@"等待卖家确认"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self getOrderInfo];
}

- (void)getOrderInfo {
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"order_id": @(self.orderId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/getOrdersDetail" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.orderObj = [[KGOrderObject alloc]init];
            self.orderObj.orderId = self.orderId;
            self.orderObj.orderNumber = data[@"orderNumber"];
            self.orderObj.orderImageUrl = data[@"goodPic"];
            self.orderObj.orderStatus = [data[@"orderStatus"] integerValue];
            self.orderObj.taskId = [data[@"taskId"] integerValue];
            self.orderObj.taskTitle = data[@"taskTitle"];
            self.orderObj.taskMessage = data[@"taskMessage"];
            self.orderObj.orderDate = [NSDate dateWithTimeIntervalSince1970:[data[@"orderCreateTime"] doubleValue]];
            self.orderObj.taskMoney = [data[@"money"] floatValue];
            self.orderObj.totalMoney = [data[@"totalMoney"] floatValue];
            self.orderObj.gratuity = [data[@"gratuity"] floatValue];
            self.orderObj.buyerId = [data[@"buyerId"] integerValue];
            self.orderObj.buyerName = data[@"buyerName"];
            KGAddressObject *addrObj = [[KGAddressObject alloc] init];
            addrObj.addressId = [data[@"addressId"] integerValue];
            addrObj.consignee = data[@"receiverName"];
            addrObj.mobile = data[@"receiverTel"];
            NSDictionary *addressDetail = data[@"addressDetail"];
            addrObj.province = addressDetail[@"province"];
            addrObj.city = addressDetail[@"city"];
            addrObj.district = addressDetail[@"county"];
            addrObj.street = addressDetail[@"street"];
            self.orderObj.addr = addrObj;
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

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.orderObj) {
        return 0;
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
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
            NSString *reuseId = @"orderAddressCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.orderObj.addr];
            break;
        }
        case 2: {
            NSString *reuseId = @"buyerNameCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[@"买手：", self.orderObj.buyerName];
            [cell setObject:obj];
            break;
        }
        case 3: {
            cell = [[KGTableViewCell alloc]init];
            cell.contentView.backgroundColor = RGB(233, 243, 243);
            break;
        }
        case 4: {
            NSString *reuseId = @"orderImageCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[self.orderObj.orderImageUrl, self.orderObj.taskTitle];
            [cell setObject:obj];
            break;
        }
        case 5: {
            NSString *reuseId = @"gratuityCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[@"跑腿费比例：", [NSString stringWithFormat:@"%0.1f%%", self.orderObj.gratuity]];
            [cell setObject:obj];
            [cell performSelector:@selector(setRightLblTextColor:) withObject: MAIN_COLOR];
            break;
        }
        case 6: {
            NSString *reuseId = @"taskMoneyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[@"任务金额：", [NSString stringWithFormat:@"￥%0.1f", self.orderObj.taskMoney]];
            [cell setObject:obj];
            [cell performSelector:@selector(setRightLblTextColor:) withObject: MAIN_COLOR];
            break;
        }
        case 7: {
            NSString *reuseId = @"taskMessageCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderLeftRightCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[@"任务描述：", self.orderObj.taskMessage];
            [cell setObject:obj];
            [cell performSelector:@selector(setRightLblTextColor:) withObject: MAIN_COLOR];
            break;
        }
        case 8: {
            NSString *reuseId = @"totalMoneyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderTotalMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSString *obj = [NSString stringWithFormat:@"￥%0.2f", self.orderObj.totalMoney];
            [cell setObject:obj];
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
            height = 54.0;
            break;
        case 1:
            height = 74.0;
            break;
        case 3:
            height = 10.0;
            break;
        case 4:
            height = 89.0;
            break;
        default:
            height = 44.0;
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 65.0)];
    footer.backgroundColor = RGB(230, 242, 238);

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 290, 37)];
    button.backgroundColor = MAIN_COLOR;
    [button setTitle:@"编辑" forState:UIControlStateNormal];
    button.showsTouchWhenHighlighted = YES;
    [button addTarget:self action:@selector(tapActionButton:) forControlEvents:UIControlEventTouchUpInside];
    [footer addSubview:button];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 60.0;
}

- (void)tapActionButton: (UIButton *)sender {
    switch (self.orderObj.orderStatus) {
        case WAITING_CONFIRM: {
            UIStoryboard *sb = [UIStoryboard storyboardWithName:@"order" bundle:nil];
            KGCreateOrderController *creatController = [sb instantiateViewControllerWithIdentifier:@"kCreateOrderController"];
            creatController.title = @"编辑订单";
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:creatController];
            [self presentViewController:nc animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}

@end
