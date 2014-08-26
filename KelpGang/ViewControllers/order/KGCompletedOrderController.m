//
//  KGCompletedOrderController.m
//  KelpGang
//
//  Created by Andy on 14-5-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderController.h"
#import "KGCompletedOrderInfoCell.h"
#import "KGCompletedOrderConsigneeCell.h"
#import "KGCompletedOrderBuyerCell.h"
#import "KGCompletedOrderPhotoInfoCell.h"
#import "KGCompletedOrderLabelCell.h"
#import "KGCompletedOrderPriceCell.h"
#import "KGAddressObject.h"
#import "KGOrderObject.h"
#import "KGCreateOrderController.h"

@interface KGCompletedOrderController ()
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *actionButton;

@end

@implementation KGCompletedOrderController

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

    if (!self.orderObj) {
        //TODO load order by id
        self.orderObj = [[KGOrderObject alloc]init];
        self.orderObj.orderStatus = WAITING_CONFIRM;
    }

    switch (self.orderObj.orderStatus) {
        case WAITING_CONFIRM:
            self.title = @"等待卖家确认";
            break;

        default:
            break;
    }

    [self.actionButton addTarget:self action:@selector(tapActionButton:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 3;
    } else {
        return 5;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"orderInfoCell" forIndexPath:indexPath];
            KGCompletedOrderInfoCell *iCell = (KGCompletedOrderInfoCell *)cell;
            [iCell setOrderNumber:@"13123232343434" date:[NSDate date]];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"consigneeCell" forIndexPath:indexPath];
            KGCompletedOrderConsigneeCell *cCell = (KGCompletedOrderConsigneeCell *)cell;
            KGAddressObject *obj = [[KGAddressObject alloc] init];
            obj.consignee = @"用户1";
            obj.mobile = @"12112127878";
            obj.province = @"河北省";
            obj.city = @"沧州市";
            obj.district = @"盐山县";
            obj.street = @"圣诞节法拉盛江东父老就撒旦法离开就撒旦法离开家拉屎大富科技圣诞节发牢骚";
            obj.areaCode = @"343899";
            obj.defaultAddr = NO;
            [cCell setObject:obj];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buyerCell" forIndexPath:indexPath];
            KGCompletedOrderBuyerCell *bCell = (KGCompletedOrderBuyerCell *)cell;
            [bCell setBuyerName:@"任海"];
        }
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"photoInfoCell" forIndexPath:indexPath];
            KGCompletedOrderPhotoInfoCell *pCell = (KGCompletedOrderPhotoInfoCell *)cell;
            [pCell setOrderImage:@"http://c.hiphotos.baidu.com/image/pic/item/962bd40735fae6cd495931c40db30f2443a70fa1.jpg" desc:@"SD卡发了啥地方就阿里上课的房间卡洛杉矶的返利卡三季度法律考试分开公司了大管家阿萨德来看过就爱上了的旮旯"];
        } else if (indexPath.row > 0 && indexPath.row < 4) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"labelCell" forIndexPath:indexPath];
            KGCompletedOrderLabelCell *lCell = (KGCompletedOrderLabelCell *)cell;
            NSString *title;
            NSString *value;
            if (indexPath.row == 1) {
                title = @"跑腿费比例：";
                value = @"10%";
            } else if (indexPath.row == 2) {
                title = @"任务金额：";
                value = @"￥100";
            } else {
                title = @"任务描述：";
                value = @"白色榴莲味面霜，2倍浓度";
            }
            [lCell setTitle:title value:value];
        }
        else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            KGCompletedOrderPriceCell *pCell = (KGCompletedOrderPriceCell *)cell;
            [pCell setPrice:@"￥23222323"];
        }
    }
    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                height = 54.0;
                break;
            case 1:
                height = 74.0;
                break;
            default:
                height = 46.0;
                break;
        }
    } else {
        switch (indexPath.row) {
            case 0:
                height = 89.0;
                break;
            default:
                height = 46.0;
                break;
        }
    }
    return height;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10.0)];
        header.backgroundColor = CLEARCOLOR;
        return header;
    }
    return nil;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
}

- (void)tapActionButton: (UIButton *)sender {
    switch (self.orderObj.orderStatus) {
        case WAITING_CONFIRM: {
            KGCreateOrderController *creatController = [self.storyboard instantiateViewControllerWithIdentifier:@"kCreateOrderController"];
            creatController.title = @"编辑订单";
//            [self.navigationController pushViewController:creatController animated:YES];
//
//            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
//            [controllers removeObjectAtIndex:controllers.count - 2];
//            [self.navigationController setViewControllers:controllers];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:creatController];
            [self presentViewController:nc animated:YES completion:nil];
            break;
        }
        default:
            break;
    }
}


@end
