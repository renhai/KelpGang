//
//  KGLoginController.m
//  KelpGang
//
//  Created by Andy on 14-5-13.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLoginController.h"

@interface KGLoginController ()
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UITextField *accountTF;
@property (weak, nonatomic) IBOutlet UITextField *passwordTF;

@end

@implementation KGLoginController

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
    [self setTitle:@"登录"];
    [self.loginBtn addTarget:self action:@selector(login:) forControlEvents:UIControlEventTouchUpInside];
    

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
    return [super tableView:tableView numberOfRowsInSection:section];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:tableView cellForRowAtIndexPath:indexPath];
    return cell;
}

- (void)login: (UIButton *) sender {
    NSString *account = self.accountTF.text;
    NSString *password = self.passwordTF.text;
    NSString *md5Password = [KGUtils md5HexDigest:password];
    NSDictionary *params = @{@"account": account, @"password_md5": md5Password};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/home/login" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSInteger code = [dic[@"code"] integerValue];
        NSString *msg = dic[@"msg"];
        if (code == 0) {
            NSDictionary *data = dic[@"data"];
            NSInteger userId = [data[@"id"] integerValue];
            NSString *sessionKey = data[@"session_key"];
            NSDictionary *info = data[@"user_info"];

            [[NSUserDefaults standardUserDefaults] setInteger:userId forKey:kCurrentUserId];
            [[NSUserDefaults standardUserDefaults] setObject:sessionKey forKey:kCurrentSessionKey];
            [[NSUserDefaults standardUserDefaults] synchronize];

            [self userLogin:info sessionKey:sessionKey];
            
            [self dismissViewControllerAnimated:YES completion:nil];
        } else {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);

    }];
}

- (void)userLogin: (NSDictionary *)info sessionKey: (NSString *) sessionKey {

    if (!APPCONTEXT.currUser) {
        APPCONTEXT.currUser = [[KGUserObject alloc] init];
    }

    APPCONTEXT.currUser.sessionKey = sessionKey;
    APPCONTEXT.currUser.uid = [[info objectForKey:@"id"] integerValue];
    APPCONTEXT.currUser.uname = [info objectForKey:@"name"];
    APPCONTEXT.currUser.avatarUrl = [info objectForKey:@"head_url"];
    NSString *sex = [info valueForKeyPath:@"userDetail.sex"];
    APPCONTEXT.currUser.gender = [sex isEqualToString:@"F"] ? FEMALE : MALE;

    [APPCONTEXT userPersist];
}


@end
