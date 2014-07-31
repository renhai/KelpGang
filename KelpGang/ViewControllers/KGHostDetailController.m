//
//  KGHostDetailTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGHostDetailController.h"
#import "KGUserObject.h"

@interface KGHostDetailController () <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextView *introTV;
@property (weak, nonatomic) IBOutlet UITextField *cellphoneTF;
@property (weak, nonatomic) IBOutlet UITextField *emailTF;

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
//    self.nicknameTF.enabled = NO;
    self.cellphoneTF.enabled = NO;
    self.user = [[KGUserObject alloc] init];
    if ([APPCONTEXT checkLogin]) {
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"session_key": APPCONTEXT.currUser.sessionKey};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getUser" params: params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            [[HudHelper getInstance] hideHudInView:self.tableView];
            NSDictionary *dic = (NSDictionary *)responseObject;
            if ([KGUtils checkResult:dic]) {
                NSDictionary *data = dic[@"data"];
                self.user.uname = [data valueForKeyPath:@"user_info.user_name"];
                self.user.cellPhone = [data valueForKeyPath:@"user_info.user_phone"];
                self.user.gender = [KGUtils convertGender:[data valueForKeyPath:@"user_info.user_sex"]];
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
            [[HudHelper getInstance] hideHudInView:self.tableView];
        }];
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
    NSArray *paths = @[[NSIndexPath indexPathForRow:4 inSection:indexPath.section], [NSIndexPath indexPathForRow:5 inSection:indexPath.section]];

    if (indexPath.section == 0) {

        if (indexPath.row == 0) {
            [self showActionSheet];
        } else if (indexPath.row == 4) {
            [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
            NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"sex": @"F", @"session_key": APPCONTEXT.currUser.sessionKey};
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setSex" params:params success:^(id responseObject) {
                [[HudHelper getInstance] hideHudInView:self.view];
                if ([KGUtils checkResult:responseObject]) {
                    self.user.gender = FEMALE;
                    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
                    APPCONTEXT.currUser.gender = FEMALE;
                    [APPCONTEXT userPersist];
                }
            } failure:^(NSError *error) {
                DLog(@"error: %@", error);
                [[HudHelper getInstance] hideHudInView:self.tableView];
            }];
        } else if (indexPath.row == 5) {
            [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
            NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"sex": @"M", @"session_key": APPCONTEXT.currUser.sessionKey};
            [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setSex" params:params success:^(id responseObject) {
                [[HudHelper getInstance] hideHudInView:self.view];
                if ([KGUtils checkResult:responseObject]) {
                    self.user.gender = MALE;
                    [self.tableView reloadRowsAtIndexPaths:paths withRowAnimation:UITableViewRowAnimationNone];
                    APPCONTEXT.currUser.gender = MALE;
                    [APPCONTEXT userPersist];
                }
            } failure:^(NSError *error) {
                DLog(@"error: %@", error);
                [[HudHelper getInstance] hideHudInView:self.tableView];
            }];
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
    if (textField == self.emailTF) {
        NSString *email = textField.text;
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"email": email, @"session_key": APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setEmail" params:params success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.view];
            if ([KGUtils checkResult:responseObject]) {
                APPCONTEXT.currUser.email = email;
                [APPCONTEXT userPersist];
            }
        } failure:^(NSError *error) {
            DLog(@"error: %@", error);
            [[HudHelper getInstance] hideHudInView:self.tableView];
        }];
    } else if (textField == self.nicknameTF) {
        NSString *nickName = textField.text;
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"name": nickName, @"session_key": APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setName" params:params success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.view];
            if ([KGUtils checkResult:responseObject]) {
                APPCONTEXT.currUser.nickName = nickName;
                APPCONTEXT.currUser.uname = nickName;
                [APPCONTEXT userPersist];
            }
        } failure:^(NSError *error) {
            DLog(@"error: %@", error);
            [[HudHelper getInstance] hideHudInView:self.tableView];
        }];
    }
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

        NSString *intro = textView.text;
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"desc": intro, @"session_key": APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/setDesc" params:params success:^(id responseObject) {
            [[HudHelper getInstance] hideHudInView:self.view];
            if ([KGUtils checkResult:responseObject]) {
                APPCONTEXT.currUser.intro = intro;
                [APPCONTEXT userPersist];
            }
        } failure:^(NSError *error) {
            DLog(@"error: %@", error);
            [[HudHelper getInstance] hideHudInView:self.tableView];
        }];

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




- (void)showActionSheet {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view.window];
}

#pragma UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([UIDevice supportCamera]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    } else if (buttonIndex == 1) {
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            controller.allowsEditing = YES;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }

    }
}

#pragma UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [[HudHelper getInstance] showHudOnView:self.tableView caption:@"上传头像中" image:nil acitivity:YES autoHideTime:0.0];
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *oriImage = [info objectForKey:@"UIImagePickerControllerEditedImage"];
        if (!oriImage) {
            oriImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        }
        NSData *imageData = UIImageJPEGRepresentation(oriImage, 0.5);
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"session_key": APPCONTEXT.currUser.sessionKey};

        [[KGNetworkManager sharedInstance] uploadPhoto:@"/mobile/user/setHeadurl"
                                                params:params
                                                  name:@"head_url"
                                              filename:@"head_url.jpg"
                                                 image:imageData
                                               success:^(id responseObject) {
                                                   [[HudHelper getInstance] hideHudInView:self.tableView];
                                                   DLog(@"result: %@", responseObject);
                                                   if ([KGUtils checkResult:responseObject]) {
                                                       NSDictionary *data = responseObject[@"data"];
                                                       NSString *headUrl = data[@"head_url"];
                                                       self.user.avatarUrl = headUrl;
                                                       [self.tableView reloadData];
                                                       APPCONTEXT.currUser.avatarUrl = headUrl;
                                                       [APPCONTEXT userPersist];
                                                   }
                                               }
                                               failure:^(NSError *error) {
                                                   [[HudHelper getInstance] hideHudInView:self.tableView];
                                                   DLog(@"error: %@", error);
                                               }];

    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}


@end
