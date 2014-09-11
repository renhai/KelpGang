//
//  KGRecentContactsController.m
//  KelpGang
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRecentContactsController.h"
#import "KGRecentContactsCell.h"
#import "KGRecentContactObject.h"
#import "FMDB.h"

@interface KGRecentContactsController ()

@property(nonatomic, strong) NSMutableArray *contacts;

@end

@implementation KGRecentContactsController

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

    self.contacts = [[NSMutableArray alloc] init];

    NSArray *results = [self queryRecentContact];
    [self.contacts addObjectsFromArray:results];

    [self queryUserInfo];
    [self.tableView reloadData];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"kRecentContactsCell";
    KGRecentContactsCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[KGRecentContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    }
    KGRecentContactObject *obj = self.contacts[indexPath.row];
    [cell configCell:obj];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    

    UIViewController *chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
    KGRecentContactObject *obj = self.contacts[indexPath.row];
    [chatViewController setValue:@(obj.uid) forKey:@"toUserId"];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}

- (NSArray *)queryRecentContact{
    NSMutableArray *resultList = [NSMutableArray new];
    NSString *dbFilePath = [KGUtils databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    [db setShouldCacheStatements:YES];

    FMResultSet *rs = [db executeQuery:@"select * from recent_contact order by id desc"];

    while ([rs next]) {
        NSInteger uid = [rs intForColumn:@"uid"];
        NSInteger gender = [rs intForColumn:@"gender"];
        NSString *uname = [rs stringForColumn:@"uname"];
        NSString *lastMsg = [rs stringForColumn:@"last_msg"];
        NSDate *lastMsgTime = [NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"last_msg_Time"]];
        BOOL hasRead = [rs boolForColumn:@"has_read"];

        KGRecentContactObject *obj = [[KGRecentContactObject alloc]init];
        obj.uid = uid;
        obj.gender = gender;
        obj.uname = uname;
        obj.lastMsg = lastMsg;
        obj.lastMsgTime = lastMsgTime;
        obj.hasRead = hasRead;
        [resultList addObject:obj];
    }

    [db close];
    return resultList;
}

- (void)queryUserInfo {
    for (KGRecentContactObject *obj in self.contacts) {
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                 @"host_id": @(obj.uid)};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getUser2" params: params success:^(id responseObject) {
            if ([KGUtils checkResult:responseObject]) {
                NSDictionary *data = responseObject[@"data"];
                NSString *headUrl = [data valueForKeyPath:@"user_info.head_url"];
                [obj setValue:headUrl forKey:@"headUrl"];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }

}


@end
