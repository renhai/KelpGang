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
    self.datasource = [[NSMutableArray alloc] init];
//    [self mockData];

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
            [self.datasource addObjectsFromArray:addressArr];
            [self mockData];
            [self.tableView reloadData];
        }
        DLog(@"result: %@", responseObject);
    } failure:^(NSError *error) {
        [[HudHelper getInstance] hideHudInView:self.tableView];
        DLog(@"error: %@", error);
    }];

//    [KGUtils setExtraCellLineHidden:self.tableView];
}

- (void)mockData {
    KGAddressObject *obj1 = [[KGAddressObject alloc] init];
    obj1.consignee = @"用户1";
    obj1.mobile = @"12112127878";
    obj1.province = @"河北省";
    obj1.city = @"沧州市";
    obj1.district = @"盐山县";
    obj1.street = @"圣诞节法拉盛江东父老就撒旦法离开就撒旦法离开家拉屎大富科技圣诞节发牢骚";
    obj1.areaCode = @"343899";
    obj1.defaultAddr = NO;

    KGAddressObject *obj2 = [[KGAddressObject alloc] init];
    obj2.consignee = @"任海";
    obj2.mobile = @"17612891239";
    obj2.province = @"北京";
    obj2.city = @"北京市";
    obj2.district = @"朝阳区";
    obj2.street = @"酒仙桥中路18号 国投创意产业园";
    obj2.areaCode = @"231387";
    obj2.defaultAddr = YES;

    KGAddressObject *obj3 = [[KGAddressObject alloc] init];
    obj3.consignee = @"谁谁谁谁谁谁";
    obj3.mobile = @"12345678909";
    obj3.province = @"辽宁省";
    obj3.city = @"大连市";
    obj3.district = @"甘井子区";
    obj3.street = @"所发生的离开房间乱收费的 水电费加拉斯的";
    obj3.areaCode = @"327487";
    obj3.defaultAddr = NO;

    [self.datasource addObject:obj1];
    [self.datasource addObject:obj2];
    [self.datasource addObject:obj3];
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


@end
