//
//  KGCreateOrderController.m
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderController.h"
#import "KGCreateOrderConsigneeCell.h"
#import "KGAddressObject.h"
#import "KGDeliveryAddressController.h"
#import "KGCreateOrderBuyerCell.h"
#import "KGCreateOrderTaskNameCell.h"
#import "KGCreateOrderUploadPhotoCell.h"
#import "IQUIView+Hierarchy.h"
#import "KGCreateOrderPhotoCell.h"
#import "KGCreateOrderTextFieldCell.h"
#import "KGOrderObject.h"
#import "KGGoodsObject.h"
#import "KGGoodsPhotoObject.h"
#import "KGOrderConfirmViewController.h"



@interface KGCreateOrderController () <UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) KGGoodsObject *goodsObj;
@property (nonatomic, strong) KGOrderObject *orderObj;

@end

@implementation KGCreateOrderController

- (void)dealloc
{
    DLog(@"KGCreateOrderController dealloc");
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
    [self setLeftBarbuttonItem];
    [self getTaskAndBuyerInfo];

    if (self.orderId > 0) {
        [self setTitle:@"编辑订单"];
        [self.createButton setTitle:@"更新" forState:UIControlStateNormal];
        [self.createButton addTarget:self action:@selector(updateOrder:) forControlEvents:UIControlEventTouchUpInside];
    } else {
        [self setTitle:@"创建订单"];
        [self.createButton setTitle:@"创建" forState:UIControlStateNormal];
        [self.createButton addTarget:self action:@selector(createOrder:) forControlEvents:UIControlEventTouchUpInside];
    }
}


- (void)getTaskAndBuyerInfo{
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"task_id": @(self.taskId),
                             @"buyer_id": @(self.buyerId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/getTaskAndBuyerInfo" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.orderObj = [[KGOrderObject alloc]init];
            self.orderObj.taskTitle = data[@"taskTitle"];
            self.orderObj.taskId = [data[@"taskId"] integerValue];
            self.orderObj.taskMessage = data[@"taskMessage"];
            self.orderObj.taskMoney = [data[@"money"] floatValue];
            self.orderObj.totalMoney = [data[@"totalMoney"] floatValue];
            self.orderObj.gratuity = [data[@"gratuity"] floatValue];
            self.orderObj.buyerId = [data[@"buyerId"] integerValue];
            self.orderObj.buyerName = data[@"buyerName"];

            KGAddressObject *addrObj = [[KGAddressObject alloc] init];
            addrObj.addressId = [data[@"addressId"] integerValue];
            if (addrObj.addressId > 0) {
                addrObj.consignee = data[@"receiverName"];
                addrObj.mobile = data[@"receiverTel"];
                NSDictionary *addressDetail = data[@"addressDetail"];
                addrObj.province = addressDetail[@"province"];
                addrObj.city = addressDetail[@"city"];
                addrObj.district = addressDetail[@"county"];
                addrObj.street = addressDetail[@"street"];
            }
            self.orderObj.addr = addrObj;

            self.goodsObj = [[KGGoodsObject alloc] init];
            self.goodsObj.goods_id = [data[@"goodsId"] integerValue];
            NSArray *photoArr = data[@"goodsPhotos"];
            NSMutableArray *photos = [[NSMutableArray alloc]init];
            for (NSDictionary *photoDic in photoArr) {
                KGGoodsPhotoObject *photoObj = [[KGGoodsPhotoObject alloc]init];
                photoObj.good_photo_id = [photoDic[@"good_photo_id"] integerValue];
                photoObj.good_head_url = photoDic[@"good_head_url"];
                photoObj.good_main_url = photoDic[@"good_main_url"];
                photoObj.good_photo_url = photoDic[@"good_photo_url"];
                photoObj.good_tiny_url = photoDic[@"good_tiny_url"];
                [photos addObject:photoObj];
            }
            self.goodsObj.good_photos = photos;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];

    NSArray *textFields = [self.tableView deepResponderViews];
    if (textFields) {
        for (UIView *view in textFields) {
            [view resignFirstResponder];
        }
    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if (!self.orderObj) {
        return 0;
    }
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (!self.orderObj) {
        return 0;
    }
    if (section == 0) {
        return 1;
    } else {
        return 8;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"consigneeCell" forIndexPath:indexPath];
        KGCreateOrderConsigneeCell *cCell = (KGCreateOrderConsigneeCell *)cell;
        [cCell setObject:self.orderObj.addr];
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buyerCell" forIndexPath:indexPath];
            KGCreateOrderBuyerCell *bCell = (KGCreateOrderBuyerCell *)cell;
            [bCell setObject:self.orderObj.buyerName];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"taskNameCell" forIndexPath:indexPath];
            KGCreateOrderTaskNameCell *tCell = (KGCreateOrderTaskNameCell *)cell;
            [tCell setObject:self.orderObj.taskTitle];
            tCell.taskValueTextView.delegate = self;
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"uploadPhotoLabelCell" forIndexPath:indexPath];
        } else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"uploadPhotoCell" forIndexPath:indexPath];
            KGCreateOrderUploadPhotoCell *uCell = (KGCreateOrderUploadPhotoCell *)cell;
            uCell.photosView.delegate = self;
            uCell.photosView.dataSource = self;
            [uCell.photosView reloadData];
        } else if (indexPath.row > 3 && indexPath.row < 7) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            KGCreateOrderTextFieldCell *tCell = (KGCreateOrderTextFieldCell *)cell;
            tCell.textField.delegate = self;
            [tCell.textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            NSString *title;
            NSString *text;
            if (indexPath.row == 4) {
                tCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                title = @"跑腿费比例：";
                text = [NSString stringWithFormat:@"%0.1f", self.orderObj.gratuity];
            } else if (indexPath.row == 5) {
                tCell.textField.keyboardType = UIKeyboardTypeDecimalPad;
                title = @"任务金额：";
                text = [NSString stringWithFormat:@"%0.1f", self.orderObj.taskMoney];
            } else {
                tCell.textField.keyboardType = UIKeyboardTypeDefault;
                title = @"任务描述：";
                text = self.orderObj.taskMessage;
            }
            [tCell configCell:title text:text];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
            UILabel *priceLbl = (UILabel *)[cell viewWithTag:100];
            CGFloat price = self.orderObj.taskMoney * (1.0 + self.orderObj.gratuity / 100);
            priceLbl.text = [NSString stringWithFormat:@"￥%0.1f", price];
            [priceLbl sizeToFit];
            priceLbl.right = cell.width - 10;
        }
    }
    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 97;
    } else {
        if (indexPath.row == 0) {
            return 45;
        } else if (indexPath.row == 1) {
            return 65;
        } else if (indexPath.row == 2) {
            return 47;
        } else if (indexPath.row == 3) {
            return 120;
        }
    }
    return 46;
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

    if (indexPath.section == 0) {
        KGDeliveryAddressController *addrController = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"kDeliveryAddressController"];
        addrController.selectBlock = ^ (KGAddressObject *obj) {
            self.orderObj.addr = obj;
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
        };
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:addrController];
        [self presentViewController:nc animated:YES completion:nil];
    }
}


#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (void)textViewDidChange:(UITextView *)textView {
    self.orderObj.taskTitle = textView.text;
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:7 inSection:1]] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.goodsObj.good_photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPhotoCell" forIndexPath:indexPath];
    KGCreateOrderPhotoCell *pCell = (KGCreateOrderPhotoCell *)cell;
    KGGoodsPhotoObject *photo = self.goodsObj.good_photos[indexPath.row];
    [pCell.photoView setImageWithURL:[NSURL URLWithString:photo.good_head_url]usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath: %@", indexPath);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(93, 93);
}

- (void)createOrder: (UIButton *)sender {
    if (![self preCheck]) {
        return;
    }
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"addressId": @(self.orderObj.addr.addressId),
                             @"buyer_id": @(self.orderObj.buyerId),
                             @"task_id": @(self.orderObj.taskId),
                             @"title": self.orderObj.taskTitle,
                             @"gratuity": [NSString stringWithFormat:@"%0.1f", self.orderObj.gratuity],
                             @"message": self.orderObj.taskMessage,
                             @"money": [NSString stringWithFormat:@"%0.1f", self.orderObj.taskMoney]};
    [[HudHelper getInstance] showHudOnView:self.view caption:@"正在创建" image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/order/addOrders" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            NSInteger orderId = [data[@"order_id"] integerValue];
            KGOrderConfirmViewController *destController = [[KGOrderConfirmViewController alloc] initWithStyle:UITableViewStylePlain];
            destController.orderId = orderId;
            [self.navigationController pushViewController:destController animated:YES];

            NSMutableArray *controllers = [NSMutableArray arrayWithArray:self.navigationController.viewControllers];
            [controllers removeObjectAtIndex:controllers.count - 2];
            [self.navigationController setViewControllers:controllers];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)updateOrder: (UIButton *)sender {
    if (![self preCheck]) {
        return;
    }
    [self goBack:nil];
//    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
//                             @"session_key": APPCONTEXT.currUser.sessionKey,
//                             @"addressId": @(self.orderObj.addr.addressId),
//                             @"buyer_id": @(self.orderObj.buyerId),
//                             @"task_id": @(self.orderObj.taskId),
//                             @"title": self.orderObj.taskTitle,
//                             @"gratuity": [NSString stringWithFormat:@"%0.1f", self.orderObj.gratuity],
//                             @"message": self.orderObj.taskMessage,
//                             @"money": [NSString stringWithFormat:@"%0.1f", self.orderObj.taskMoney]};
//    [[HudHelper getInstance] showHudOnView:self.view caption:@"正在创建" image:nil acitivity:YES autoHideTime:0.0];
//    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/order/updateOrders" params:params success:^(id responseObject) {
//        DLog(@"%@", responseObject);
//        [[HudHelper getInstance] hideHudInView:self.view];
//        if ([KGUtils checkResultWithAlert:responseObject]) {
//            NSDictionary *data = responseObject[@"data"];
//            NSInteger orderId = [data[@"order_id"] integerValue];
//            [self goBack:nil];
//        }
//    } failure:^(NSError *error) {
//        DLog(@"%@", error);
//    }];
}


- (void)textFieldChanged: (UITextField *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 1) {
        switch (indexPath.row) {
            case 4: {
                self.orderObj.gratuity = [sender.text floatValue];
                break;
            }
            case 5: {
                self.orderObj.taskMoney = [sender.text floatValue];
                break;
            }
            case 6: {
                self.orderObj.taskMessage = sender.text;
                break;
            }
            default:
                break;
        }
    }
}

- (BOOL)preCheck {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (![APPCONTEXT checkLogin]) {
        alert.message = @"请先登录";
        [alert show];
        return NO;
    }
    if (!self.orderObj) {
        alert.message = @"创建订单失败";
        [alert show];
        return NO;
    }
    if (self.orderObj.addr.addressId <= 0) {
        alert.message = @"收货地址不能为空";
        [alert show];
        return NO;
    }
    if (!self.orderObj.taskTitle || [@"" isEqualToString:self.orderObj.taskTitle]) {
        alert.message = @"任务名称不能为空";
        [alert show];
        return NO;
    }
    if (!self.orderObj.taskMessage || [@"" isEqualToString:self.orderObj.taskMessage]) {
        alert.message = @"任务描述不能为空";
        [alert show];
        return NO;
    }
    if (self.orderObj.buyerId <= 0) {
        alert.message = @"买手信息有误";
        [alert show];
        return NO;
    }
    return YES;

}

@end
