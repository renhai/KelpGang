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

@interface KGDeliveryAddressController ()

@property(nonatomic, strong) NSMutableArray *datasource;

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



// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    return YES;
}



// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self.datasource removeObjectAtIndex:indexPath.row];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    }
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KGAddAddressController *desController = segue.destinationViewController;
    if ([@"kAddAddrSegue" isEqualToString:segue.identifier]) {
        desController.addrObj = nil;
    } else if ([@"kModAddrSegue" isEqualToString:segue.identifier]) {
        KGAddressObject *addrObj = self.datasource[[self.tableView indexPathForSelectedRow].row];
        desController.addrObj = addrObj;
    }
}

- (void)refreshTableView: (NSNotification *)noti {
    [self refeshAddrList];
}

@end
