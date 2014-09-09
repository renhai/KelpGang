//
//  KGConfirmReceiptController.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGConfirmReceiptController.h"
#import "KGOrderObject.h"
#import "KGAddressObject.h"
#import "KGLocationObject.h"
#import "KGOrderImageCell.h"
#import "KGOrderNumberAndLogisticsCell.h"
#import "KGOrderMoneyInfoCell.h"
#import "KGOrderAddressCell.h"
#import "KGLeaveMessageCell.h"
#import "KGOrderLocationCell.h"
#import "KGCommentOrderController.h"


@interface KGConfirmReceiptController ()

@property (nonatomic, strong) KGOrderObject *orderObj;

@end

@implementation KGConfirmReceiptController

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
            self.orderObj.ownerId = [data[@"owner_id"] integerValue];
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
            self.orderObj.leaveMessage = data[@"leaveMessage"];
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

            if (data[@"address_detail"]) {
                KGLocationObject *locaton = [[KGLocationObject alloc]init];
                locaton.addressDictionary = data[@"address_detail"];
                locaton.longitude = [NSNumber numberWithDouble:[data[@"longitude"] doubleValue]] ;
                locaton.latitude = [NSNumber numberWithDouble:[data[@"latitude"] doubleValue]] ;
                self.orderObj.location = locaton;
            }
            self.orderObj.logisticsCompany = data[@"logistics"];
            self.orderObj.logisticsNumber = data[@"logistics_number"];
            self.orderObj.commented = [data[@"hasComment"] boolValue];
            [self refreshViewController];
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
    if (!self.orderObj) {
        return 0;
    }
    return 8;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            NSString *reuseId = @"orderNumberAndDateCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderNumberAndLogisticsCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            NSArray *obj = @[self.orderObj.orderNumber, self.orderObj.orderDate, self.orderObj.logisticsCompany ? self.orderObj.logisticsCompany : @"", self.orderObj.logisticsNumber ? self.orderObj.logisticsNumber : @""];
            [cell setObject:obj];
            break;
        }
        case 1: {
            NSString *reuseId = @"orderLocationCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderLocationCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.orderObj.location];
            break;
        }
        case 2: {
            NSString *reuseId = @"orderImageCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderImageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[self.orderObj.orderImageUrl, self.orderObj.taskTitle];
            [cell setObject:obj];
            break;
        }
        case 3: {
            NSString *reuseId = @"moneyInfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderMoneyInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            NSArray *obj = @[@(self.orderObj.taskMoney), @(self.orderObj.gratuity), @(self.orderObj.totalMoney)];
            [cell setObject:obj];
            break;
        }
        case 4: {
            cell = [[KGTableViewCell alloc]init];
            cell.contentView.backgroundColor = RGB(233, 243, 243);
            break;
        }
        case 5: {
            NSString *reuseId = @"leaveMessageCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGLeaveMessageCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }

            [cell setObject:self.orderObj.leaveMessage];
            break;
        }
        case 6: {
            cell = [[KGTableViewCell alloc]init];
            cell.contentView.backgroundColor = RGB(233, 243, 243);
            break;
        }
        case 7: {
            NSString *reuseId = @"orderAddressCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderAddressCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.orderObj.addr];
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
            height = 78;
            break;
        case 1:
            height = 36;
            break;
        case 2:
            height = 89;
            break;
        case 3:
            height = 44;
            break;
        case 4:
            height = 10;
            break;
        case 5:
            height = 62;
            break;
        case 6:
            height = 10;
            break;
        case 7:
            height = 73;
            break;
        default:
            height = 44;
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 65.0)];
    footer.backgroundColor = RGB(230, 242, 238);

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 290, 37)];
    button.backgroundColor = MAIN_COLOR;
    button.showsTouchWhenHighlighted = YES;

    [button setTitle:@"确认收货" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(confirmBtnClicked:) forControlEvents:UIControlEventTouchUpInside];

    [footer addSubview:button];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.orderObj) {
        return 0;
    }
    if ([self isBuyer]) {
        return 0;
    }
    if (self.orderObj.orderStatus == COMPLETED) {
        return 0;
    }
    return 60.0;
}

- (void)refreshViewController {
    [self.tableView reloadData];
    if (self.orderObj.orderStatus == WAITING_RECEIPT) {
        self.title = @"等待买家确认收货";
    } else if (self.orderObj.orderStatus == COMPLETED) {
        self.title = @"订单完成";
        if (![self isBuyer] && !self.orderObj.commented) {
            [self setRightBarbuttonItemWithText:@"评论" selector:@selector(commentClicked:)];
        } else {
            self.navigationItem.rightBarButtonItem = nil;
        }
    }
}

- (BOOL)isBuyer {
    return self.orderObj.buyerId == APPCONTEXT.currUser.uid;
}

- (void)confirmBtnClicked: (UIButton *)sender {
    if (self.orderObj.ownerId != APPCONTEXT.currUser.uid) {
        return;
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"order_id": @(self.orderObj.orderId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/received" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.orderObj.orderStatus = [data[@"order_status"] integerValue];
            [self refreshViewController];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)commentClicked: (UIButton *)sender {
    KGCommentOrderController *controller = [[KGCommentOrderController alloc]initWithStyle:UITableViewStylePlain];
    controller.orderObj = self.orderObj;
    controller.block = ^ {
        self.orderObj.commented = YES;
        [self refreshViewController];
    };
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
