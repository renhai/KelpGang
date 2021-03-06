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
#import "KGJourneyObject.h"
#import "KGMyJourneyCell.h"
#import "KGBuyerInfoViewController.h"
#import "KGTaskDetailController.h"


@interface KGMyTaskController ()

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) NSInteger segType;

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
    self.segType = 0;
    [self refreshDatasource];
}

- (void)refreshDatasource {
    if (!self.datasource) {
        self.datasource = [[NSMutableArray alloc]init];
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"end_id": @(0),
                             @"limit": @(50)};
    [[HudHelper getInstance]showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    if (self.segType == 0) {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/getUserTasks" params:params success:^(id responseObject) {
            DLog(@"%@",responseObject);
            [[HudHelper getInstance] hideHudInView:self.tableView];
            if ([KGUtils checkResultWithAlert:responseObject]) {
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
                    taskObj.taskStatus = [task_info[@"task_status"] integerValue];
                    if (!taskObj.defaultImageUrl) {
                        taskObj.defaultImageUrl = @"";
                    }
                    [self.datasource addObject:taskObj];
                }

                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            DLog(@"%@",error);
        }];
    } else {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/getUserTravels" params:params success:^(id responseObject) {
            DLog(@"%@",responseObject);
            [[HudHelper getInstance] hideHudInView:self.tableView];
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [self.datasource removeAllObjects];
                NSArray *taskArr = responseObject[@"data"];
                for (NSDictionary *info in taskArr) {
                    NSArray *goodsArr = [info valueForKeyPath:@"good_info"];
                    NSDictionary *goodsInfo = @{};
                    if (goodsArr && [goodsArr count] > 0) {
                        goodsInfo = goodsArr[0];
                    }
                    NSDictionary *travel_info = [info valueForKeyPath:@"travel_info"];
                    KGJourneyObject *journeyObj = [[KGJourneyObject alloc] init];
                    journeyObj.journeyId = [travel_info[@"travel_id"] integerValue];
                    journeyObj.toCountry = travel_info[@"to"];
                    journeyObj.fromCity = travel_info[@"from"];
                    journeyObj.backDate = [NSDate dateWithTimeIntervalSince1970:[travel_info[@"travel_back_time"] doubleValue]];
                    journeyObj.startDate = [NSDate dateWithTimeIntervalSince1970:[travel_info[@"travel_start_time"] doubleValue]];
                    journeyObj.desc = travel_info[@"travel_desc"];
                    journeyObj.defaultGoodsImgUrl = goodsInfo[@"good_default_head_url"];
                    journeyObj.journeyStatus = [travel_info[@"travel_status"] integerValue];
                    [self.datasource addObject:journeyObj];
                }
                [self.tableView reloadData];
            }
        } failure:^(NSError *error) {
            DLog(@"%@",error);
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
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.segType == 0) {
        KGMyTaskCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMyTaskCell" forIndexPath:indexPath];
        KGTaskObject *task = self.datasource[indexPath.row];
        [cell setObject:task];
        return cell;
    } else {
        KGMyJourneyCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kMyJourneyCell" forIndexPath:indexPath];
        KGJourneyObject *journeyObj = self.datasource[indexPath.row];
        [cell setObject:journeyObj];
        return cell;
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
    if (self.segType == 0) {
        KGTaskObject *taskObj = self.datasource[indexPath.row];
        KGTaskDetailController *controller = [[KGTaskDetailController alloc]initWithStyle:UITableViewStylePlain];
        controller.taskId = taskObj.taskId;
        [self.navigationController pushViewController:controller animated:YES];
    } else {
        KGJourneyObject *travelObj = self.datasource[indexPath.row];
        KGBuyerInfoViewController *vc = [self.storyboard instantiateViewControllerWithIdentifier:@"kBuyerInfoViewController"];
        vc.travelId = travelObj.journeyId;
        [self.navigationController pushViewController:vc animated:YES];
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 49.0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    UISegmentedControl *seg = [[UISegmentedControl alloc] initWithItems:@[@"我的任务", @"我的行程"]];
    seg.selectedSegmentIndex = self.segType;
    seg.tintColor = RGBCOLOR(187, 187, 187);
    seg.frame = CGRectMake(20, 10, 280, 29);
    [seg addTarget:self action:@selector(segmentedControl:) forControlEvents:UIControlEventValueChanged];
    UIView *header = [[UIView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 49)];
    header.backgroundColor = RGBCOLOR(246, 251, 249);
    [header addSubview:seg];
    return header;
}

#pragma UISegmentedControl

- (void)segmentedControl: (UISegmentedControl *) seg {
    self.segType = seg.selectedSegmentIndex;
    [self refreshDatasource];
}


 // Override to support conditional editing of the table view.
 - (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
 {
     if (self.segType == 0) {
         KGTaskObject *taskObj = self.datasource[indexPath.row];
         if (taskObj.taskStatus == 1) {
             return NO;
         }
     }
     return YES;
 }



 // Override to support editing the table view.
 - (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
 {

     if (editingStyle == UITableViewCellEditingStyleDelete) {
         if (self.segType == 0) {
             KGTaskObject *taskObj = self.datasource[indexPath.row];
             NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                      @"session_key": APPCONTEXT.currUser.sessionKey,
                                      @"task_id": @(taskObj.taskId)};
             [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
             [[KGNetworkManager sharedInstance] postRequest:@"/mobile/task/delete" params: params success:^(id responseObject) {
                 DLog(@"%@", responseObject);
                 [[HudHelper getInstance] hideHudInView:self.view];
                 if ([KGUtils checkResultWithAlert:responseObject]) {
                     [tableView beginUpdates];
                     [self.datasource removeObjectAtIndex:indexPath.row];
                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                     [tableView endUpdates];
                 }
             } failure:^(NSError *error) {
                 DLog(@"%@", error);
             }];
         } else if (self.segType == 1) {
             KGJourneyObject *journeyObj = self.datasource[indexPath.row];
             NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                      @"session_key": APPCONTEXT.currUser.sessionKey,
                                      @"travel_id": @(journeyObj.journeyId)};
             [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
             [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/delete" params: params success:^(id responseObject) {
                 DLog(@"%@", responseObject);
                 [[HudHelper getInstance] hideHudInView:self.view];
                 if ([KGUtils checkResultWithAlert:responseObject]) {
                     [tableView beginUpdates];
                     [self.datasource removeObjectAtIndex:indexPath.row];
                     [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
                     [tableView endUpdates];
                 }
             } failure:^(NSError *error) {
                 DLog(@"%@", error);
             }];
         }
     }
 }


@end
