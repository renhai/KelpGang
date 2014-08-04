//
//  KGAddAddressTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddAddressController.h"
#import "KGAddressObject.h"
#import <sqlite3.h>
#import "KGProvince.h"
#import "KGCity.h"
#import "KGZone.h"


@interface KGAddAddressController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)setDefaultAddr:(UIButton *)sender;
@property (nonatomic, assign) BOOL areaExpand;
@property (nonatomic, strong) NSArray *provinceArr, *cityArr, *zoneArr;

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
    self.finishBtn.layer.cornerRadius = 4;
    [self initAreaData];
}

- (void)finishAddAddress: (UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    if (!self.areaExpand) {
        return 5;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (!self.areaExpand && indexPath.row > 2) {
        cell = [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];
    }
    if (indexPath.row == 0) {
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        tf.text = [self.addrObj consignee];
    }
    if (indexPath.row == 1) {
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        tf.text = [self.addrObj mobile];
    }
    if (indexPath.row == 2) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        UIButton *button = (UIButton *)[cell viewWithTag:2];
        UILabel *label = (UILabel *)[cell viewWithTag:3];
        [button sizeToFit];
        button.right = 305;
        button.centerY = cell.height / 2;
        [button addTarget:self action:@selector(finishSelectDistrict:) forControlEvents:UIControlEventTouchUpInside];
        if (self.addrObj) {
            label.text = [NSString stringWithFormat:@"%@%@%@", self.addrObj.province, self.addrObj.city, self.addrObj.district];
            [label sizeToFit];
            if (label.width > 180) {
                label.width = 180;
            }
        }
        if (self.areaExpand) {
            button.hidden = NO;
            imageView.hidden = YES;
        } else {
            button.hidden = YES;
            imageView.hidden = NO;
            imageView.image = [UIImage imageNamed:@"down-arrow-big"];
        }
    }
    if (indexPath.row == 3 && !self.areaExpand) {
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        tf.text = [self.addrObj street];
    }
    if (indexPath.row == 4 && !self.areaExpand) {
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        tf.text = [self.addrObj areaCode];
    }
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2 && !self.areaExpand) {
        self.areaExpand = YES;
        NSArray *paths = @[[NSIndexPath indexPathForRow:3 inSection:indexPath.section]];
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (!self.areaExpand && indexPath.row > 2) {
        height = [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];;
    }
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

- (void)finishSelectDistrict:(UIButton *)sender {
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

    self.areaExpand = NO;
    NSArray *paths = @[[NSIndexPath indexPathForRow:3 inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
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
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        DLog(@"Failed to open database");
        return resultList;
    }

    NSString *query = @"select ProName, ProSort, ProRemark from T_Province";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *proName = (char *)sqlite3_column_text(statement, 0);
            NSString *proNameStr = [[NSString alloc] initWithUTF8String:proName];
            char *proSort = (char *)sqlite3_column_text(statement, 1);
            NSString *proSortStr = [[NSString alloc] initWithUTF8String:proSort];
            char *proRemark = (char *)sqlite3_column_text(statement, 2);
            NSString *proRemarkStr = [[NSString alloc] initWithUTF8String:proRemark];
            DLog(@"%@-%@-%@", proNameStr, proSortStr, proRemarkStr);
            KGProvince *province = [[KGProvince alloc] init];
            province.proName = proNameStr;
            province.proId = proSortStr;
            province.proRemark = proRemarkStr;
            [resultList addObject:province];
        }
        sqlite3_finalize(statement);
    } else {
        DLog(@"error !!!!!");
    }
    sqlite3_close(database);
    return resultList;
}

- (NSMutableArray *)queryCity: (NSString *)proId {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        DLog(@"Failed to open database");
        return resultList;
    }

    NSString *query = @"select CityName, CitySort from T_City where ProId = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [proId UTF8String], -1, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *cityName = (char *)sqlite3_column_text(statement, 0);
            NSString *cityNameStr = [[NSString alloc] initWithUTF8String:cityName];
            char *citySort = (char *)sqlite3_column_text(statement, 1);
            NSString *citySortStr = [[NSString alloc] initWithUTF8String:citySort];
            DLog(@"%@-%@", cityNameStr, citySortStr);
            KGCity *city = [[KGCity alloc] init];
            city.cityName = cityNameStr;
            city.cityId = citySortStr;
            [resultList addObject:city];
        }
        sqlite3_finalize(statement);
    } else {
        DLog(@"error !!!!!");
    }
    sqlite3_close(database);
    return resultList;
}

- (NSMutableArray *)queryZone: (NSString *)cityId {
    NSMutableArray *resultList = [[NSMutableArray alloc] init];
    sqlite3 *database;
    if (sqlite3_open([[self dataFilePath] UTF8String], &database) != SQLITE_OK) {
        sqlite3_close(database);
        DLog(@"Failed to open database");
        return resultList;
    }

    NSString *query = @"select ZoneID, ZoneName from T_Zone where CityID = ?";
    sqlite3_stmt *statement;
    if (sqlite3_prepare_v2(database, [query UTF8String], -1, &statement, nil) == SQLITE_OK) {
        sqlite3_bind_text(statement, 1, [cityId UTF8String], -1, NULL);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *zoneId = (char *)sqlite3_column_text(statement, 0);
            NSString *zoneIdStr = [[NSString alloc] initWithUTF8String:zoneId];
            char *zoneName = (char *)sqlite3_column_text(statement, 1);
            NSString *zoneNameStr = [[NSString alloc] initWithUTF8String:zoneName];
            DLog(@"%@-%@", zoneIdStr, zoneNameStr);
            KGZone *zone = [[KGZone alloc] init];
            zone.zoneId = zoneIdStr;
            zone.zoneName = zoneNameStr;
            [resultList addObject:zone];
        }
        sqlite3_finalize(statement);
    } else {
        DLog(@"error !!!!!");
    }
    sqlite3_close(database);
    return resultList;
}

@end
