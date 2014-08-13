//
//  KGMyTaskController.m
//  KelpGang
//
//  Created by Andy on 14-8-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyTaskController.h"
#import "KGMyTaskCell.h"
#import "KGTaskObject.h"

@interface KGMyTaskController ()

@property (nonatomic, strong) NSMutableArray *datasource;

@end

@implementation KGMyTaskController

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
    [self refreshDatasource];
}

- (void)refreshDatasource {
    if (!self.datasource) {
        self.datasource = [[NSMutableArray alloc]init];
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid)};
    [[HudHelper getInstance]showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/getUserTasks" params:params success:^(id responseObject) {
        DLog(@"%@",responseObject);
        [[HudHelper getInstance] hideHudInView:self.tableView];
        if ([KGUtils checkResult:responseObject]) {
            [self.datasource removeAllObjects];
            NSArray *taskArr = responseObject[@"data"];
            for (NSDictionary *info in taskArr) {
                NSArray *goodsArr = [info valueForKeyPath:@"good_info"];
                NSDictionary *goodsInfo = @{};
                if (goodsArr && [goodsArr count] > 0) {
                    goodsInfo = goodsArr[0];
                }
                NSDictionary *task_info = [info valueForKeyPath:@"task_info"];
                KGTaskObject *taskObj = [[KGTaskObject alloc] init];
                taskObj.taskId = [task_info[@"task_id"] integerValue];
                taskObj.title = task_info[@"task_title"];
                taskObj.gratuity = [task_info[@"task_gratuity"] floatValue];
                taskObj.deadline = [NSDate dateWithTimeIntervalSince1970:[task_info[@"task_deadline"] doubleValue]];
                taskObj.message = task_info[@"task_message"];
                taskObj.expectCountry = task_info[@"task_good_country"];
                taskObj.maxMoney = [task_info[@"task_money"] floatValue];
                taskObj.defaultImageUrl = goodsInfo[@"good_default_head_url"];
                if (!taskObj.defaultImageUrl) {
                    taskObj.defaultImageUrl = @"";
                }
                [self.datasource addObject:taskObj];
            }

            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"%@",error);
        [[HudHelper getInstance] showHudOnView:self.view caption:@"系统错误,请稍后再试" image:nil acitivity:NO autoHideTime:1.6];
    }];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMyTaskCell" forIndexPath:indexPath];
    KGMyTaskCell *tCell = (KGMyTaskCell *)cell;
    KGTaskObject *task = self.datasource[indexPath.row];
    [tCell setObject:task];
        
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
