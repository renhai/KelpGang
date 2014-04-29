//
//  KGAddAddressTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddAddressController.h"
#import "KGAddressObject.h"

@interface KGAddAddressController () <UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (weak, nonatomic) IBOutlet UIButton *finishBtn;
- (IBAction)setDefaultAddr:(UIButton *)sender;
@property (nonatomic, assign) BOOL areaExpand;
@property (nonatomic, strong) NSArray *provinces, *cities, *areas;

@end

@implementation KGAddAddressController

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
        [button addTarget:self action:@selector(finishSelectDistrict:) forControlEvents:UIControlEventTouchUpInside];
        if (self.addrObj) {
            label.text = [NSString stringWithFormat:@"%@%@%@", self.addrObj.province, self.addrObj.city, self.addrObj.district];
            [label sizeToFit];
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
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    self.provinces = data;
    self.cities = self.provinces[0][@"cities"];
    self.areas = self.cities[0][@"areas"];

    if (!self.addrObj) {
        KGAddressObject *addrObj = [[KGAddressObject alloc] init];
        self.addrObj = addrObj;
        self.addrObj.province = self.provinces[0][@"state"];
        self.addrObj.city = self.cities[0][@"city"];
        if (self.areas.count > 0) {
            self.addrObj.district = self.areas[0];
        } else{
            self.addrObj.district = @"";
        }
    }
}

#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 3;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    NSInteger num = 0;
    switch (component) {
        case 0:
            num = [self.provinces count];
            break;
        case 1:
            num = [self.cities count];
            break;
        case 2:
            num = [self.areas count];
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
        case 0:
            title = self.provinces[row][@"state"];
            break;
        case 1:
            title = self.cities[row][@"city"];
            break;
        case 2:
            if (self.areas.count > 0) {
                title = self.areas[row];
            }
            break;
        default:
            break;
    }
    return title;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    switch (component) {
        case 0:
            self.cities = [[self.provinces objectAtIndex:row] objectForKey:@"cities"];
            [self.pickerView selectRow:0 inComponent:1 animated:YES];
            [self.pickerView reloadComponent:1];

            self.areas = [[self.cities objectAtIndex:0] objectForKey:@"areas"];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];

            self.addrObj.province = [[self.provinces objectAtIndex:row] objectForKey:@"state"];
            self.addrObj.city = [[self.cities objectAtIndex:0] objectForKey:@"city"];
            if ([self.areas count] > 0) {
                self.addrObj.district = [self.areas objectAtIndex:0];
            } else{
                self.addrObj.district = @"";
            }
            break;
        case 1:
            self.areas = [[self.cities objectAtIndex:row] objectForKey:@"areas"];
            [self.pickerView selectRow:0 inComponent:2 animated:YES];
            [self.pickerView reloadComponent:2];

            self.addrObj.city = [[self.cities objectAtIndex:row] objectForKey:@"city"];
            if ([self.areas count] > 0) {
                self.addrObj.district = [self.areas objectAtIndex:0];
            } else{
                self.addrObj.district = @"";
            }
            break;
        case 2:
            if ([self.areas count] > 0) {
                self.addrObj.district = [self.areas objectAtIndex:row];
            } else{
                self.addrObj.district = @"";
            }
            break;
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

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}


- (IBAction)setDefaultAddr:(UIButton *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)finishSelectDistrict:(UIButton *)sender {
    self.areaExpand = NO;
    NSArray *paths = @[[NSIndexPath indexPathForRow:3 inSection:0]];
    [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:2 inSection:0]] withRowAnimation:UITableViewRowAnimationNone];
}
@end
