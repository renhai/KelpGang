//
//  KGAddAddressTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddAddressController.h"
#import "KGAddressObject.h"
#import "FMDB.h"
#import "KGProvince.h"
#import "KGCity.h"
#import "KGZone.h"


@interface KGAddAddressController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource>

@property (strong, nonatomic) UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UITextField *consigneeTF;
@property (weak, nonatomic) IBOutlet UITextField *mobileTF;
@property (weak, nonatomic) IBOutlet UITextField *districtTF;
@property (weak, nonatomic) IBOutlet UITextField *streetTF;
@property (weak, nonatomic) IBOutlet UITextField *areaCodeTF;
- (IBAction)setDefaultAddr:(UIButton *)sender;
@property (nonatomic, strong) NSArray *provinceArr, *cityArr, *zoneArr;

@property (nonatomic, strong) KGAddressObject *addrObj;

@end

@implementation KGAddAddressController

- (void)dealloc
{
    DLog(@"KGAddAddressController dealloc");
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
    [self setLeftBarbuttonItem];
    [self setRightBarbuttonItem:[UIImage imageNamed:@"check-mark-white"] selector:@selector(finishAddAddress:)];
    [self initAreaData];
    if (self.addressId > 0) {
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                 @"address_id": @(self.addressId),
                                 @"session_key": APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getAddress" params:params success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.tableView];
            DLog(@"%@", responseObject);
            if ([KGUtils checkResult:responseObject]) {
                KGAddressObject *obj = [[KGAddressObject alloc] init];
                NSArray *addrArr = [responseObject valueForKeyPath:@"data.address_info"];
                if (addrArr && [addrArr count] > 0) {
                    NSDictionary *info = addrArr[0];
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
                }
                self.addrObj = obj;
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            [[HudHelper getInstance] hideHudInView:self.tableView];
            DLog(@"%@", error);
        }];
    } else {
        self.addrObj = [[KGAddressObject alloc] init];
    }
}

- (void)finishAddAddress: (UIBarButtonItem *)sender {
    if (![self checkAddressInfo]) {
        return;
    }
    NSDictionary *common = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"receiver_name": self.addrObj.consignee,
                             @"tel": self.addrObj.mobile,
                             @"province": self.addrObj.province,
                             @"city": self.addrObj.city,
                             @"county": self.addrObj.district,
                             @"street": self.addrObj.street,
                             @"zipcode": self.addrObj.areaCode,
                             @"is_default": @(self.addrObj.isDefaultAddr),
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary:common];
    NSString *postUrl = @"/mobile/user/addAddress";
    if (self.addrObj.addressId > 0) {
        postUrl = @"/mobile/user/updateAddress";
        [params setValue:@(self.addrObj.addressId) forKey:@"address_id"];
    }
    [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:postUrl
                                            params:params
                                           success:^(id responseObject) {
                                               [[HudHelper getInstance] hideHudInView:self.tableView];
                                               DLog(@"%@", responseObject);
                                               if ([KGUtils checkResult:responseObject]) {
                                                   [[NSNotificationCenter defaultCenter] postNotificationName:kUpdateAddress object:nil];
                                                   [self.navigationController popViewControllerAnimated:YES];
                                               }
                                        } failure:^(NSError *error) {
                                            DLog(@"%@", error);
                                            [[HudHelper getInstance] hideHudInView:self.tableView];
                                        }];
}

- (BOOL)checkAddressInfo {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if ([self.consigneeTF.text isEqualToString:@""]) {
        alert.title = @"收件人不能为空";
        [alert show];
        return NO;
    }
    if ([self.mobileTF.text isEqualToString:@""]) {
        alert.title = @"联系电话不能为空";
        [alert show];
        return NO;
    }
    if ([self.districtTF.text isEqualToString:@""]) {
        alert.title = @"所在地区不能为空";
        [alert show];
        return NO;
    }
    if ([self.streetTF.text isEqualToString:@""]) {
        alert.title = @"详细地址不能为空";
        [alert show];
        return NO;
    }
    self.addrObj.consignee = self.consigneeTF.text;
    self.addrObj.mobile = self.mobileTF.text;
    self.addrObj.street = self.streetTF.text;
    self.addrObj.areaCode = self.areaCodeTF.text;
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
    if (indexPath.row == 0) {
        self.consigneeTF.text = [self.addrObj consignee];
    }
    if (indexPath.row == 1) {
        self.mobileTF.text = [self.addrObj mobile];
    }
    if (indexPath.row == 2) {
        NSString *address = [NSString stringWithFormat:@"%@%@%@", self.addrObj.province, self.addrObj.city, self.addrObj.district];
        if (!address) {
            address = @"";
        }
        self.districtTF.text = address;

        UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectZero];
        [topView setBarStyle:UIBarStyleBlack];

        UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelSelectDistrict:)];

        UIBarButtonItem *spaceButton = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];

        UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(finishSelectDistrict:)];

        NSArray *buttonsArray = [NSArray arrayWithObjects:cancelButton,spaceButton,doneButton,nil];
        [topView setItems:buttonsArray];
        [topView sizeToFit];

        UIPickerView *pickerView = [[UIPickerView alloc]initWithFrame:CGRectZero];
        pickerView.showsSelectionIndicator = YES;
        pickerView.dataSource = self;
        pickerView.delegate = self;

        self.pickerView = pickerView;
        self.districtTF.inputView = self.pickerView;
        self.districtTF.inputAccessoryView = topView;
    }
    if (indexPath.row == 3) {
        self.streetTF.text = [self.addrObj street];
    }
    if (indexPath.row == 4) {
        self.areaCodeTF.text = [self.addrObj areaCode];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    return 10;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 10)];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}



- (void)initAreaData {
    self.provinceArr = [self queryProvince];
    KGProvince *province = self.provinceArr[0];
    self.cityArr = [self queryCity:province.proId];
    KGCity *city = self.cityArr[0];
    self.zoneArr = [self queryZone:city.cityId];
}

#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger num = 0;
    switch (component) {
        case 0:
            num = [self.provinceArr count];
            break;
        case 1:
            num = [self.cityArr count];
            break;
        case 2:
            num = [self.zoneArr count];
            break;
        default:
            break;
    }
    return num;
}

#pragma UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    NSString *title;
    switch (component) {
        case 0: {
            KGProvince *province = self.provinceArr[row];
            title = province.proName;
            break;
        }
        case 1: {
            KGCity *city = self.cityArr[row];
            title = city.cityName;
            break;
        }
        case 2: {
            KGZone *zone = self.zoneArr[row];
            title = zone.zoneName;
            break;
        }
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0: {
            KGProvince *province = self.provinceArr[row];
            NSString *proId = province.proId;
            NSArray *cityArr = [self queryCity:proId];
            self.cityArr = cityArr;
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];

            KGCity *city = self.cityArr[0];
            NSString *cityId = city.cityId;
            NSArray *zoneArr = [self queryZone:cityId];
            self.zoneArr = zoneArr;
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
            break;
        }
        case 1: {
            KGCity *city = self.cityArr[row];
            NSString *cityId = city.cityId;
            NSArray *zoneArr = [self queryZone:cityId];
            self.zoneArr = zoneArr;
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];
            break;
        }
        case 2: {
            break;
        }
        default:
            break;
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    [self.view endEditing:YES];
}


- (IBAction)setDefaultAddr:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishSelectDistrict:(UIBarButtonItem *)sender {
    [self.districtTF resignFirstResponder];

    KGProvince *province = self.provinceArr[[self.pickerView selectedRowInComponent:0]];
    self.addrObj.province = province.proName;
    KGCity *city = self.cityArr[[self.pickerView selectedRowInComponent:1]];
    self.addrObj.city = city.cityName;
    if ([@"直辖市" isEqualToString: province.proRemark]
        || [@"特别行政区" isEqualToString: province.proRemark] ) {
        self.addrObj.city = @"";
    }
    NSInteger zoneIndex = [self.pickerView selectedRowInComponent:2];
    if ([self.zoneArr count] > 0) {
        KGZone *zone = self.zoneArr[zoneIndex];
        self.addrObj.district = zone.zoneName;
    } else {
        self.addrObj.district = @"";
    }

    NSString *address = [NSString stringWithFormat:@"%@%@%@", self.addrObj.province, self.addrObj.city, self.addrObj.district];
    self.districtTF.text = address;
}

- (void)cancelSelectDistrict:(UIBarButtonItem *)sender {
    [self.districtTF resignFirstResponder];
}

- (NSString *)dataFilePath {
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,
                                                         NSUserDomainMask,
                                                         YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    return [documentsDirectory stringByAppendingPathComponent:@"china_province_city_zone.sqlite"];
}

- (NSMutableArray *)queryProvince {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    FMDatabase *db  = [FMDatabase databaseWithPath:[self dataFilePath]];
    if (![db open]) {
        NSLog(@"Open database failed");
        return resultList;
    }
    FMResultSet *rs = [db executeQuery:@"select ProName, ProSort, ProRemark from T_Province"];
    while ([rs next]) {
        NSString *proName = [rs stringForColumn:@"ProName"];
        NSString *proSort = [rs stringForColumn:@"ProSort"];
        NSString *proRemark = [rs stringForColumn:@"ProRemark"];
        DLog(@"province: %@-%@-%@", proName, proSort, proRemark);
        KGProvince *province = [[KGProvince alloc] init];
        province.proName = proName;
        province.proId = proSort;
        province.proRemark = proRemark;
        [resultList addObject:province];
    }
    [db close];
    return resultList;
}

- (NSMutableArray *)queryCity: (NSString *)proId {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    FMDatabase *db  = [FMDatabase databaseWithPath:[self dataFilePath]];
    if (![db open]) {
        NSLog(@"Open database failed");
        return resultList;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select CityName, CitySort from T_City where ProId = %@", proId]];

    while ([rs next]) {
        NSString *cityName = [rs stringForColumn:@"CityName"];
        NSString *cityId = [rs stringForColumn:@"CitySort"];
        DLog(@"city: %@-%@", cityId, cityName);
        KGCity *city = [[KGCity alloc] init];
        city.cityName = cityName;
        city.cityId = cityId;
        [resultList addObject:city];
    }
    [db close];
    return resultList;
}

- (NSMutableArray *)queryZone: (NSString *)cityId {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    FMDatabase *db  = [FMDatabase databaseWithPath:[self dataFilePath]];
    if (![db open]) {
        NSLog(@"Open database failed");
        return resultList;
    }
    FMResultSet *rs = [db executeQuery:[NSString stringWithFormat:@"select ZoneID, ZoneName from T_Zone where CityID = %@", cityId]];

    while ([rs next]) {
        NSString *zoneId = [rs stringForColumn:@"ZoneID"];
        NSString *zoneName = [rs stringForColumn:@"ZoneName"];
        DLog(@"%@-%@", zoneId, zoneName);
        KGZone *zone = [[KGZone alloc] init];
        zone.zoneId = zoneId;
        zone.zoneName = zoneName;
        [resultList addObject:zone];
    }
    [db close];
    return resultList;
}

@end
