//
//  KGRegisterController.m
//  KelpGang
//
//  Created by Andy on 14-6-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRegisterController.h"
#import<CommonCrypto/CommonDigest.h>

@interface KGRegisterController ()

@property (weak, nonatomic) IBOutlet UITextField *nicknameTF;
@property (weak, nonatomic) IBOutlet UITextField *phoneNumTF;
@property (weak, nonatomic) IBOutlet UIButton *verifyBtn;
@property (weak, nonatomic) IBOutlet UITextField *verifyCodeTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;
@property (weak, nonatomic) IBOutlet UIButton *registerBtn;

@property (nonatomic, assign) Gender gender;


@end

@implementation KGRegisterController

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
    self.title = @"手机注册";
    self.tableView.backgroundColor = RGB(233, 243, 243);
    self.gender = FEMALE;
    [self.verifyBtn addTarget:self action:@selector(verifyPhone) forControlEvents:UIControlEventTouchUpInside];
    [self.registerBtn addTarget:self action:@selector(doRegister) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
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
    cell.contentView.backgroundColor = [UIColor whiteColor];
    if (indexPath.section == 0 && indexPath.row == 1) {
        cell.contentView.backgroundColor = RGB(233, 243, 243);
    }
    if (indexPath.section == 0 && indexPath.row == 2) {
        UIImageView *selectView = (UIImageView *)[cell viewWithTag:1];
        selectView.hidden = self.gender == MALE;
    }
    if (indexPath.section == 0 && indexPath.row == 3) {
        UIImageView *selectView = (UIImageView *)[cell viewWithTag:1];
        selectView.hidden = self.gender == FEMALE;
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    if (section == 1) {
        return 10.0;
    } else {
        return 0.0;
    }
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.width, 10)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        if (indexPath.row == 2) {
            self.gender = FEMALE;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
        if (indexPath.row == 3) {
            self.gender = MALE;
            [tableView reloadSections:[NSIndexSet indexSetWithIndex:indexPath.section] withRowAnimation:UITableViewRowAnimationNone];
        }
    }
}


- (void)verifyPhone {
    NSString *phone = self.phoneNumTF.text;
    NSDictionary *params = @{@"phone": phone, @"time": @"0", @"sign": @""};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/register/verifyCode" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];

}

- (void)doRegister {
    NSString *password = self.passwordTF.text;
    if (!password || [@"" isEqualToString:password]) {
        return;
    }
    NSString *md5Password = [self md5HexDigest:password];
    DLog(@"%@", md5Password);
}

- (NSString *)md5HexDigest:(NSString *)orig {
    const char *original_str = [orig UTF8String];
    unsigned char result[CC_MD5_DIGEST_LENGTH];
    CC_MD5(original_str, strlen(original_str), result);
    NSMutableString *hash = [NSMutableString string];
    for (int i = 0; i < 16; i++)
        [hash appendFormat:@"%02X", result[i]];
    return [hash lowercaseString];
}



@end
