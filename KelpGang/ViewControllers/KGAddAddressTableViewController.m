//
//  KGAddAddressTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-25.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGAddAddressTableViewController.h"
#import "KGAddressObject.h"

@interface KGAddAddressTableViewController ()

@property (weak, nonatomic) IBOutlet UIPickerView *pickerView;
@property (nonatomic, assign) BOOL areaExpand;
@property (nonatomic, strong) NSArray *provinces, *cities, *areas;
@property (nonatomic, strong) KGAddressObject *addrObj;

@end

@implementation KGAddAddressTableViewController

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
    NAVIGATIONBAR_ADD_DEFAULT_BACKBUTTON_WITH_CALLBACK(goBack:);

    [self initAreaData];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)goBack:(UIBarButtonItem *)sender {
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
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    //    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.row == 2) {
        NSArray *paths = @[[NSIndexPath indexPathForRow:3 inSection:indexPath.section]];
        [self.tableView beginUpdates];
        if (!self.areaExpand) {
            self.areaExpand = YES;
            [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        } else {
            self.areaExpand = NO;
            [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
        }
        [self.tableView endUpdates];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = [super tableView:tableView heightForRowAtIndexPath:indexPath];
    if (!self.areaExpand && indexPath.row > 2) {
        height = [super tableView:tableView heightForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section]];;
    }
    return height;
}

- (void)initAreaData {
    NSArray *data = [[NSArray alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area" ofType:@"plist"]];
    self.provinces = data;
    self.cities = self.provinces[0][@"cities"];
    self.areas = self.cities[0][@"areas"];

    if (!self.addrObj) {
        KGAddressObject *addrObj = [[KGAddressObject alloc] init];
        self.addrObj = addrObj;
    }
    self.addrObj.province = self.provinces[0][@"state"];
    self.addrObj.city = self.cities[0][@"city"];
    if (self.areas.count > 0) {
        self.addrObj.district = self.areas[0];
    } else{
        self.addrObj.district = @"";
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


@end
