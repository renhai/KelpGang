//
//  KGDeliveryAddressTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDeliveryAddressController.h"
#import "KGDeliveryAddressCell.h"
#import "KGAddressObject.h"
#import "KGAddAddressController.h"

@interface KGDeliveryAddressController () </*SWTableViewCellDelegate, */UIActionSheetDelegate>

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger currEditCellIndex;

@end

@implementation KGDeliveryAddressController

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(refreshTableView:) name:kUpdateAddress object:nil];
    [self setLeftBarbuttonItem];
    self.datasource = [[NSMutableArray alloc] init];
    [self refeshAddrList];
}

- (void)refeshAddrList {
    [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"session_key": APPCONTEXT.currUser.sessionKey};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getAddressList" params:params success:^(id responseObject) {
        [[HudHelper getInstance] hideHudInView:self.tableView];
        if ([KGUtils checkResult:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *addressArr = data[@"address_info"];
            if (!addressArr) {
                addressArr = @[];
            }
            [self.datasource removeAllObjects];
            [self.datasource addObjectsFromArray:[self convertAddrInfo:addressArr]];
            [self.tableView reloadData];
        }
        DLog(@"result: %@", responseObject);
    } failure:^(NSError *error) {
        [[HudHelper getInstance] hideHudInView:self.tableView];
        DLog(@"error: %@", error);
    }];

}

- (NSMutableArray *)convertAddrInfo: (NSArray *)addrArr {
    NSMutableArray *result = [[NSMutableArray alloc] init];
    for (NSDictionary *info in addrArr) {
        KGAddressObject *obj = [[KGAddressObject alloc] init];
        obj.addressId = [info[@"address_id"] integerValue];
        obj.consignee = info[@"receiver_name"];
        obj.mobile = info[@"tel"];
        obj.uid = [info[@"user_id"] integerValue];
        obj.areaCode = info[@"zipcode"];
        obj.defaultAddr = [info[@"address_is_default"] boolValue];
        obj.province = [info valueForKeyPath:@"address_detail.province"];
        obj.city = [info valueForKeyPath:@"address_detail.city"];
        obj.district = [info valueForKeyPath:@"address_detail.county"];
        obj.street = [info valueForKeyPath:@"address_detail.street"];
        [result addObject:obj];
    }
    return result;
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
    return  [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGDeliveryAddressCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kDeliveryAddressTableViewCell" forIndexPath:indexPath];
//    [cell setRightUtilityButtons:[self rightButtons] WithButtonWidth:58.0f];
//    cell.delegate = self;
    KGAddressObject *obj = self.datasource[indexPath.row];
    [cell setObject:obj];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 70.0;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    self.currEditCellIndex = indexPath.row;
    if (self.selectBlock) {
        KGAddressObject *selectObj = self.datasource[indexPath.row];
        [self goBack:nil];
        self.selectBlock(selectObj);
    } else {
        [self showActionSheet];
    }
}

// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        KGAddressObject *addrObj = [self.datasource objectAtIndex:indexPath.row];
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                 @"address_id":@(addrObj.addressId),
                                 @"session_key":APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/deleteAddress" params:params success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.tableView];
            DLog(@"%@", responseObject);
            if ([KGUtils checkResult:responseObject]) {
                [self.datasource removeObjectAtIndex:indexPath.row];
                [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
            }
        } failure:^(NSError *error) {
            [[HudHelper getInstance] hideHudInView:self.tableView];
            DLog(@"%@", error);
        }];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KGAddAddressController *desController = segue.destinationViewController;
    if ([@"kAddAddrSegue" isEqualToString:segue.identifier]) {
        desController.addressId = 0;
    }
}

- (void)refreshTableView: (NSNotification *)noti {
    [self refeshAddrList];
}

/*
- (NSArray *)rightButtons
{
    NSMutableArray *rightUtilityButtons = [NSMutableArray new];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:0.78f green:0.78f blue:0.8f alpha:1.0]
                                                title:@"更多"];
    [rightUtilityButtons sw_addUtilityButtonWithColor:
     [UIColor colorWithRed:1.0f green:0.231f blue:0.188 alpha:1.0f]
                                                title:@"删除"];

    return rightUtilityButtons;
}


- (void)swipeableTableViewCell:(SWTableViewCell *)cell didTriggerRightUtilityButtonWithIndex:(NSInteger)index
{
    NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
    self.currEditCellIndex = cellIndexPath.row;
    switch (index) {
        case 0:
        {
            NSLog(@"More button was pressed");
//            UIAlertView *alertTest = [[UIAlertView alloc] initWithTitle:@"Hello" message:@"More more more" delegate:nil cancelButtonTitle:@"cancel" otherButtonTitles: nil];
//            [alertTest show];
            [self showActionSheet];
            [cell hideUtilityButtonsAnimated:YES];
            break;
        }
        case 1:
        {
            // Delete button was pressed
            NSIndexPath *cellIndexPath = [self.tableView indexPathForCell:cell];
//
//            [_testArray[cellIndexPath.section] removeObjectAtIndex:cellIndexPath.row];
//            [self.tableView deleteRowsAtIndexPaths:@[cellIndexPath] withRowAnimation:UITableViewRowAnimationLeft];
            DLog(@"delete button clicked: %@", cellIndexPath);
            break;
        }
        default:
            break;
    }
}

- (BOOL)swipeableTableViewCellShouldHideUtilityButtonsOnSwipe:(SWTableViewCell *)cell
{
    // allow just one cell's utility button to be open at once
    return YES;
}
*/

- (void)showActionSheet {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"编辑",@"删除", @"设为默认地址", nil];
    [choiceSheet showInView:self.view.window];
}


#pragma UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    switch (buttonIndex) {
        case 0: {
            KGAddressObject *addrObj = self.datasource[self.currEditCellIndex];
            KGAddAddressController *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"kAddAddressController"];
            controller.title = @"编辑地址";
            controller.addressId = addrObj.addressId;
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
            break;
        }
        case 1: {
            KGAddressObject *addrObj = [self.datasource objectAtIndex:self.currEditCellIndex];
            NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                     @"address_id":@(addrObj.addressId),
                                     @"session_key":APPCONTEXT.currUser.sessionKey};
            [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/deleteAddress" params:params success:^(id responseObject) {
                [[HudHelper getInstance] hideHudInView:self.tableView];
                DLog(@"%@", responseObject);
                if ([KGUtils checkResult:responseObject]) {
                    [self.datasource removeObjectAtIndex:self.currEditCellIndex];
                    [self.tableView beginUpdates];
                    [self.tableView deleteRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:self.currEditCellIndex inSection:0]] withRowAnimation:UITableViewRowAnimationFade];
                    [self.tableView endUpdates];
                }
            } failure:^(NSError *error) {
                [[HudHelper getInstance] hideHudInView:self.tableView];
                DLog(@"%@", error);
            }];
            break;
        }
        case 2: {
            KGAddressObject *addrObj = [self.datasource objectAtIndex:self.currEditCellIndex];
            NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                     @"address_id":@(addrObj.addressId),
                                     @"session_key":APPCONTEXT.currUser.sessionKey};
            [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setAddressDefault" params:params success:^(id responseObject) {
                [[HudHelper getInstance] hideHudInView:self.tableView];
                DLog(@"%@", responseObject);
                if ([KGUtils checkResult:responseObject]) {
                    for (NSInteger i = 0; i < self.datasource.count; i ++) {
                        KGAddressObject *obj = self.datasource[i];
                        obj.defaultAddr = (i == self.currEditCellIndex);
                    }
                    [self.tableView reloadData];

                }
            } failure:^(NSError *error) {
                [[HudHelper getInstance] hideHudInView:self.tableView];
                DLog(@"%@", error);
            }];
            break;
        }

        default:
            break;
    }
}

@end
