//
//  KGHostDetailTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostDetailController.h"
#import "UIImageView+WebCache.h"
#import "KGUserObject.h"

@interface KGHostDetailController () <UITextFieldDelegate, UITextViewDelegate>

@property (nonatomic, assign) BOOL sexExpand;

@end

@implementation KGHostDetailController

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

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
    if (section == 0) {
        if (!self.sexExpand) {
            return 6;
        }
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 0) {
        if (!self.sexExpand && indexPath.row > 3) {
            cell = [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row + 2 inSection:indexPath.section]];
        }
        switch (indexPath.section) {
            case 0: {
                if (indexPath.row == 0) {
                    UIImageView *headView = (UIImageView *)[cell viewWithTag:1];
                    [headView setImageWithURL:[NSURL URLWithString:self.user.avatarUrl]];
                    headView.layer.cornerRadius = headView.width / 2;
                } else if (indexPath.row == 1) {
                    UITextField *tf = (UITextField *)[cell viewWithTag:1];
                    tf.text = self.user.uname;
                    tf.delegate = self;
                } else if (indexPath.row == 2) {
                    UITextView *tv = (UITextView *)[cell viewWithTag:1];
                    tv.layer.cornerRadius = 4;
                    if (self.user.intro && ![@"" isEqualToString:self.user.intro]) {
                        tv.text = self.user.intro;
                    }
                    tv.delegate = self;
                } else if (indexPath.row == 3) {
                    if (self.sexExpand) {
                        cell.contentView.backgroundColor = RGBCOLOR(233, 243, 243);
                    } else {
                        cell.contentView.backgroundColor = [UIColor whiteColor];
                    }
                } else if (indexPath.row == 4) {
                    if (self.sexExpand) {
                        UIImageView *selectedView = (UIImageView *)[cell viewWithTag:1];
                        selectedView.hidden = self.user.gender == FEMALE ? NO : YES;
                    } else {
                        UITextField *tf = (UITextField *)[cell viewWithTag:1];
                        tf.text = self.user.cellPhone;
                        tf.delegate = self;
                    }
                } else if (indexPath.row == 5) {
                    if (self.sexExpand) {
                        UIImageView *selectedView = (UIImageView *)[cell viewWithTag:1];
                        selectedView.hidden = self.user.gender == MALE ? NO : YES;
                    } else {
                        UITextField *tf = (UITextField *)[cell viewWithTag:1];
                        tf.text = self.user.email;
                        tf.delegate = self;
                    }
                }
                break;
            }
            default:
                break;
        }
    }

    return cell;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    NSArray *paths = @[[NSIndexPath indexPathForRow:4 inSection:indexPath.section], [NSIndexPath indexPathForRow:5 inSection:indexPath.section]];

    if (indexPath.section == 0) {
        if (indexPath.row == 3) {
            [self.tableView beginUpdates];
            if (!self.sexExpand) {
                self.sexExpand = YES;
                [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            } else {
                self.sexExpand = NO;
                [self.tableView deleteRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationFade];
            }
            [self.tableView endUpdates];
            [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:3 inSection:indexPath.section]] withRowAnimation:UITableViewRowAnimationNone];
        } else if (indexPath.row == 4) {
            if (self.sexExpand) {
                self.user.gender = FEMALE;
                [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
            }
        } else if (indexPath.row == 5) {
            if (self.sexExpand) {
                self.user.gender = MALE;
                [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
            }
        }
    }

}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10)];
    header.backgroundColor = CLEARCOLOR;
    return header;
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}


#pragma UITextViewDelegate

- (BOOL)textViewShouldBeginEditing:(UITextView *)textView {
    textView.backgroundColor = RGBCOLOR(233, 243, 243);
    return YES;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        textView.backgroundColor = [UIColor whiteColor];
        return NO;
    }
    return YES;
}

- (void)textViewDidEndEditing:(UITextView *)textView {
    textView.backgroundColor = [UIColor whiteColor];
}


#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

@end
