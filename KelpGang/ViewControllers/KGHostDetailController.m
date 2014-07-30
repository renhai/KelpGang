//
//  KGHostDetailTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostDetailController.h"
#import "KGUserObject.h"

@interface KGHostDetailController () <UITextFieldDelegate, UITextViewDelegate>

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
    self.user = [[KGUserObject alloc] init];
    if ([APPCONTEXT checkLogin]) {
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"session_key": APPCONTEXT.currUser.sessionKey};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getUser" params: params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([self checkResult:dic]) {
                NSDictionary *data = dic[@"data"];
                self.user.uname = [data valueForKeyPath:@"user_info.user_name"];
                self.user.cellPhone = [data valueForKeyPath:@"user_info.user_phone"];
                self.user.gender = [self convertGender:[data valueForKeyPath:@"user_info.user_sex"]];
                self.user.avatarUrl = [data valueForKeyPath:@"user_info.head_url"];
                self.user.vip = [[data valueForKeyPath:@"user_info.user_v"] boolValue];
                self.user.level = [[data valueForKeyPath:@"user_info.user_star"] integerValue];
                self.user.nickName = [data valueForKeyPath:@"user_info.user_name"];
                self.user.intro = [data valueForKeyPath:@"user_info.user_desc"];
                self.user.email = [data valueForKeyPath:@"user_info.user_email"];

                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }
}

- (BOOL)checkResult: (NSDictionary *)info {
    NSInteger code = [info[@"code"] integerValue];
    NSString *msg = info[@"msg"];
    if (code != 0) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return NO;
    } else {
        return YES;
    }
}

- (Gender)convertGender: (id)sex {
    if ([@"F" isEqualToString:sex]) {
        return FEMALE;
    } else {
        return MALE;
    }
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
    if (indexPath.section == 0) {
        cell = [super tableView:tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:indexPath.row inSection:indexPath.section]];
        switch (indexPath.section) {
            case 0: {
                if (indexPath.row == 0) {
                    UIImageView *headView = (UIImageView *)[cell viewWithTag:1];
                    [headView setImageWithURL:[NSURL URLWithString:self.user.avatarUrl] placeholderImage: [UIImage imageNamed:self.user.gender == MALE ? kAvatarMale : kAvatarFemale] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                } else if (indexPath.row == 4) {
                    UIImageView *selectedView = (UIImageView *)[cell viewWithTag:1];
                    selectedView.hidden = self.user.gender == FEMALE ? NO : YES;
                } else if (indexPath.row == 5) {
                    UIImageView *selectedView = (UIImageView *)[cell viewWithTag:1];
                    selectedView.hidden = self.user.gender == MALE ? NO : YES;
                } else if (indexPath.row == 6) {
                    UITextField *tf = (UITextField *)[cell viewWithTag:1];
                    tf.text = self.user.cellPhone;
                    tf.delegate = self;
                } else if (indexPath.row == 7) {
                    UITextField *tf = (UITextField *)[cell viewWithTag:1];
                    tf.text = self.user.email;
                    tf.delegate = self;
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
        if (indexPath.row == 4) {
            self.user.gender = FEMALE;
            [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
        } else if (indexPath.row == 5) {
            self.user.gender = MALE;
            [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
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
