//
//  KGCommentOrderController.m
//  KelpGang
//
//  Created by Andy on 14-9-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommentOrderController.h"
#import "KGOrderNumberAndDateCell.h"
#import "KGOrderObject.h"
#import "KGUserObject.h"
#import "KGBuyerInfoCell.h"
#import "KGRatingCell.h"
#import "KGCommentCell.h"
#import "AMRatingControl.h"


@interface KGCommentOrderController () <UITextViewDelegate>

@property (nonatomic, strong) KGUserObject *buyer;
@property (nonatomic, assign) BOOL isFollow;
@property (nonatomic, assign) NSInteger rate;
@property (nonatomic, strong) NSString *comment;

@end

@implementation KGCommentOrderController

- (void)dealloc {
    DLog(@"");
}

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
    [self setRightBarbuttonItemWithText:@"完成" selector:@selector(finishComment:)];
    [self setTitle:@"评论"];
    if ([self.tableView respondsToSelector:@selector(setSeparatorInset:)]) {
        [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    }
    [self queryUserInfo];
    self.rate = kDefaultRate;
    self.comment = kDefaultComment;
    [KGUtils setExtraCellLineHidden:self.tableView];
}

- (void)queryUserInfo {
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"host_id": @(self.orderObj.buyerId)};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getUser2" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = [responseObject valueForKeyPath:@"data.user_info"];
            KGUserObject *buyer = [[KGUserObject alloc] init];
            buyer.uid = [data[@"user_id"] integerValue];
            buyer.nickName = data[@"user_name"];
            buyer.vip = [data[@"user_v"] boolValue];
            buyer.level = [data[@"user_star"] integerValue];
            buyer.intro = data[@"user_desc"];
            buyer.avatarUrl = data[@"head_url"];
            buyer.gender = [KGUtils convertGender:data[@"user_sex"]];
            self.isFollow = [data[@"user_is_follow"] boolValue];
            self.buyer = buyer;
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
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
    if (!self.buyer) {
        return 0;
    }
    return 4;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            NSString *reuseId = @"orderNumberAndDateCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGOrderNumberAndDateCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            NSArray *obj = @[self.orderObj.orderNumber, self.orderObj.orderDate];
            [cell setObject:obj];
            break;
        }
        case 1: {
            NSString *reuseId = @"buyerInfoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGBuyerInfoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            [cell setObject:self.buyer];
            KGBuyerInfoCell *bCell = (KGBuyerInfoCell *)cell;
            [bCell.followButton setTitle:self.isFollow ? @"取消关注" : @"+关注" forState: UIControlStateNormal];
            [bCell.followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
            break;
        }
        case 2: {
            NSString *reuseId = @"ratingCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGRatingCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            [cell setObject:nil];
            __weak typeof(self) weakSelf = self;
            KGRatingCell *rCell = (KGRatingCell *)cell;
            rCell.ratingControl.editingChangedBlock = ^ (NSUInteger rate) {
                weakSelf.rate = rate;
            };
            break;
        }
        case 3: {
            NSString *reuseId = @"commentCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGCommentCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];

            }
            [cell setObject:nil];

            KGCommentCell *commentCell = (KGCommentCell *)cell;
            commentCell.commentTV.delegate = self;
            break;
        }
        default:
            cell = [[KGTableViewCell alloc]init];
            break;
    }

    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height;
    switch (indexPath.row) {
        case 0:
            height = 54;
            break;
        case 1:
            height = 108;
            break;
        case 2:
            height = 50;
            break;
        case 3:
            height = 100;
            break;
        default:
            height = 44;
            break;
    }
    return height;
}

- (BOOL)isBuyer {
    return self.orderObj.buyerId == APPCONTEXT.currUser.uid;
}

- (void)finishComment: (UIBarButtonItem *)sender {
    if (self.orderObj.ownerId != APPCONTEXT.currUser.uid) {
        return;
    }

    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"order_id": @(self.orderObj.orderId),
                             @"star": @(self.rate),
                             @"content": self.comment};

    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/addComment" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            if (self.block) {
                self.block();
            }
            [self goBack:nil];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)followAction: (UIButton *)sender {
    if (![APPCONTEXT checkLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSInteger followId = self.buyer.uid;
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"follow_id": @(followId),
                             @"session_key": APPCONTEXT.currUser.sessionKey};

    if (self.isFollow) {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/disFollow" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"取消关注成功" dismissAfter:2.0];
                self.isFollow = NO;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    } else {
        if (followId == APPCONTEXT.currUser.uid) {
            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"不能关注自己哦" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/follow" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"关注成功" dismissAfter:2.0];
                self.isFollow = YES;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:1 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }
    
}

- (void)textViewDidChange:(UITextView *)textView {
    self.comment = textView.text;
}


@end
