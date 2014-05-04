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
#import "IQ_UIView+Hierarchy.h"
#import "KGCreateOrderPhotoCell.h"
#import "KGCreateOrderTextFieldCell.h"


@interface KGCreateOrderController () <UITextViewDelegate, UITextFieldDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *createButton;

@property (nonatomic, strong) NSMutableArray *photos;

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
    [self setTitle:@"创建订单"];
    [self mockData];
    self.photos = [[NSMutableArray alloc] init];
    [self.photos addObject:@(1)];
    [self.photos addObject:@(1)];
    [self.photos addObject:@(1)];
    [self.photos addObject:@(1)];

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

- (void)mockData {
    KGAddressObject *obj = [[KGAddressObject alloc] init];
    obj.consignee = @"用户1";
    obj.mobile = @"12112127878";
    obj.province = @"河北省";
    obj.city = @"沧州市";
    obj.district = @"盐山县";
    obj.street = @"圣诞节法拉盛江东父老就撒旦法离开就撒旦法离开家拉屎大富科技圣诞节发牢骚";
    obj.areaCode = @"343899";
    obj.defaultAddr = NO;
    self.addrObj = obj;

    self.buyerName = @"sdfsdfj";
    self.taskName = @"教室里的房间爱老师的开发将阿里水电费加拉开始的放假快乐事纠纷的";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UITableViewDataSource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
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
        [cCell setObject:self.addrObj];
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"buyerCell" forIndexPath:indexPath];
            KGCreateOrderBuyerCell *bCell = (KGCreateOrderBuyerCell *)cell;
            [bCell setObject:self.buyerName];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"taskNameCell" forIndexPath:indexPath];
            KGCreateOrderTaskNameCell *tCell = (KGCreateOrderTaskNameCell *)cell;
            [tCell setObject:self.taskName];
            tCell.taskValueTextView.delegate = self;
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"uploadPhotoLabelCell" forIndexPath:indexPath];
        } else if (indexPath.row == 3) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"uploadPhotoCell" forIndexPath:indexPath];
            KGCreateOrderUploadPhotoCell *uCell = (KGCreateOrderUploadPhotoCell *)cell;
            uCell.photoNameTextField.delegate = self;
            uCell.photosView.delegate = self;
            uCell.photosView.dataSource = self;
            [uCell.deleteAllPhotosButton addTarget:self action:@selector(deleteAllPhotos:) forControlEvents:UIControlEventTouchUpInside];
        } else if (indexPath.row > 3 && indexPath.row < 7) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"textFieldCell" forIndexPath:indexPath];
            KGCreateOrderTextFieldCell *tCell = (KGCreateOrderTextFieldCell *)cell;
            tCell.textField.delegate = self;
            NSString *title;
            NSString *text;
            if (indexPath.row == 4) {
                title = @"跑腿费比例：";
                text = @"10%";
            } else if (indexPath.row == 5) {
                title = @"任务金额：";
                text = @"￥100";
            } else {
                title = @"任务描述：";
                text = @"白色榴莲味面霜，2倍浓度";
            }
            [tCell configCell:title text:text];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"priceCell" forIndexPath:indexPath];
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
            return 162;
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
        [self.navigationController pushViewController:addrController animated:YES];
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

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.photos count] + 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell;
    if (indexPath.row == [self.photos count]) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kAddPhotoCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPhotoCell" forIndexPath:indexPath];
        KGCreateOrderPhotoCell *pCell = (KGCreateOrderPhotoCell *)cell;
        [pCell.delButton addTarget:self action:@selector(delPhoto:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;
}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    DLog(@"indexPath: %@", indexPath);
}


- (void)deleteAllPhotos: (UIButton *)sender {
    [self.photos removeAllObjects];
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    KGCreateOrderUploadPhotoCell *uCell = (KGCreateOrderUploadPhotoCell *)cell;
    [uCell.photosView reloadData];
}

- (void)delPhoto: (UIButton *)sender {
    UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:1]];
    KGCreateOrderUploadPhotoCell *uCell = (KGCreateOrderUploadPhotoCell *)cell;
    KGCreateOrderPhotoCell *pCell = (KGCreateOrderPhotoCell *)sender.superview.superview;
    NSIndexPath *indexPath = [uCell.photosView indexPathForCell:pCell];
    NSLog(@"%@", indexPath);
    [self.photos removeObjectAtIndex:indexPath.row];
    [uCell.photosView reloadData];
}

@end
