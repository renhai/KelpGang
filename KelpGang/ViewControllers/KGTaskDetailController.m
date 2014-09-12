//
//  KGTaskDetailController.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskDetailController.h"
#import "KGTaskObject.h"
#import "KGGoodsObject.h"
#import "KGGoodsPhotoObject.h"
#import "KGUserObject.h"
#import "KGTaskDetailHeadCell.h"
#import "KGTaskExpectCountryCell.h"
#import "KGTaskMaxMoneyCell.h"
#import "KGTaskDescCell.h"
#import "KGTaskGoodsPhotoCell.h"
#import "KGTaskGoodsPhotoCollectionViewCell.h"
#import "KGChatViewController.h"
#import "KGPhotoBrowserViewController.h"



@interface KGTaskDetailController () <UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, strong) KGTaskObject *taskObj;
@property (nonatomic, strong) KGGoodsObject *goodsObj;
//@property (nonatomic, strong) KGUserObject *taskOwner;


@end

@implementation KGTaskDetailController

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
    [self setTitle:@"任务说明"];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.tableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [self refreshDatasource];
}

-(void)refreshDatasource {
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"task_id": @(self.taskId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/task/getUserTask" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *goodsArr = data[@"good_info"];
            NSDictionary *good_info = @{};
            if (goodsArr && goodsArr.count > 0) {
                good_info = goodsArr[0];
            }
            NSDictionary *task_info = data[@"task_info"];
            NSDictionary *user_info = data[@"user_info"];

            self.taskObj = [self parseTaskInfo:task_info ownerInfo:user_info];
            self.goodsObj = [self parseGoodsInfo:good_info];

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
    if (!self.taskObj) {
        return 0;
    }
    return 7;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGTableViewCell *cell = nil;
    switch (indexPath.row) {
        case 0: {
            NSString *reuseId = @"kTaskDetailHeadCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGTaskDetailHeadCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.taskObj];
            break;
        }
        case 1: {
            cell = [[KGTableViewCell alloc]init];
            cell.contentView.backgroundColor = RGB(233, 243, 243);
            break;
        }
        case 2: {
            NSString *reuseId = @"kTaskExpectCountryCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGTaskExpectCountryCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.taskObj.expectCountry];
            break;
        }
        case 3: {
            NSString *reuseId = @"kTaskMaxMoneyCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGTaskMaxMoneyCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:[NSString stringWithFormat:@"￥%0.1f", self.taskObj.maxMoney]];
            break;
        }
        case 4: {
            NSString *reuseId = @"kTaskDescCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGTaskDescCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:self.taskObj.message];
            break;
        }
        case 5: {
            cell = [[KGTableViewCell alloc]init];
            cell.contentView.backgroundColor = RGB(233, 243, 243);
            break;
        }
        case 6: {
            NSString *reuseId = @"kTaskGoodsPhotoCell";
            cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
            if (!cell) {
                cell = [[KGTaskGoodsPhotoCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
            }
            [cell setObject:nil];
            KGTaskGoodsPhotoCell *kCell = (KGTaskGoodsPhotoCell *)cell;
            [kCell.photosView setDataSource:self];
            [kCell.photosView setDelegate:self];
            [kCell.photosView registerClass:[KGTaskGoodsPhotoCollectionViewCell class] forCellWithReuseIdentifier:@"kTaskGoodsPhotoCollectionViewCell"];
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
            height = 125;
            break;
        case 1:
            height = 10;
            break;
        case 2:
            height = 40;
            break;
        case 3:
            height = 40;
            break;
        case 4:
            height = 60;
            break;
        case 5:
            height = 10;
            break;
        case 6:
            height = iPhone5 ? 159 : 115;
            break;
        default:
            height = 44;
            break;
    }
    return height;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
    UIView *footer = [[UIView alloc] initWithFrame:CGRectMake(0, 0, tableView.width, 65.0)];
    footer.backgroundColor = RGB(230, 242, 238);

    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(15, 10, 290, 37)];
    button.backgroundColor = MAIN_COLOR;
    button.showsTouchWhenHighlighted = YES;

    [button setTitle:@"开始聊天" forState:UIControlStateNormal];
    [button addTarget:self action:@selector(chatButtonClicked:) forControlEvents:UIControlEventTouchUpInside];

    [footer addSubview:button];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
    if (!self.taskObj) {
        return 0;
    }
    if (APPCONTEXT.currUser.uid == self.taskObj.ownerId) {
        return 0;
    }
    return 60.0;
}

- (KGGoodsObject *)parseGoodsInfo: (NSDictionary *) info {
    KGGoodsObject *obj = [[KGGoodsObject alloc]init];
    obj.goods_id = [info[@"good_id"] integerValue];
    obj.good_default_head_url = info[@"good_default_head_url"];
    obj.good_default_main_url = info[@"good_default_main_url"];
    obj.good_default_photo_url = info[@"good_default_photo_url"];
    obj.good_default_tiny_url = info[@"good_default_tiny_url"];
    obj.good_name = info[@"good_name"];
    obj.good_is_collection = [info[@"good_is_collection"] boolValue];
    NSArray *photoArr = info[@"good_photos"];
    NSMutableArray *photos = [[NSMutableArray alloc]init];
    for (NSDictionary *photoDic in photoArr) {
        KGGoodsPhotoObject *photoObj = [[KGGoodsPhotoObject alloc]init];
        photoObj.good_photo_id = [photoDic[@"good_photo_id"] integerValue];
        photoObj.good_head_url = photoDic[@"good_head_url"];
        photoObj.good_main_url = photoDic[@"good_main_url"];
        photoObj.good_photo_url = photoDic[@"good_photo_url"];
        photoObj.good_tiny_url = photoDic[@"good_tiny_url"];
        [photos addObject:photoObj];
    }
    obj.good_photos = photos;
    return obj;
}

- (KGTaskObject *)parseTaskInfo: (NSDictionary *) task_info ownerInfo: (NSDictionary *)user_info {
    KGTaskObject *taskObj = [[KGTaskObject alloc] init];
    taskObj.taskId = [task_info[@"task_id"] integerValue];
    taskObj.title = task_info[@"task_title"];
    taskObj.gratuity = [task_info[@"task_gratuity"] floatValue];
    taskObj.deadline = [NSDate dateWithTimeIntervalSince1970:[task_info[@"task_deadline"] doubleValue]];
    taskObj.message = task_info[@"task_message"];
    taskObj.expectCountry = task_info[@"task_good_country"];
    taskObj.maxMoney = [task_info[@"task_money"] floatValue];
    taskObj.taskStatus = [task_info[@"task_status"] integerValue];
    taskObj.ownerCity = task_info[@"task_live_city"];

    taskObj.ownerId = [user_info [@"user_id"] integerValue];
    taskObj.ownerName = user_info [@"user_name"];
    taskObj.ownerGender = [KGUtils convertGender:user_info [@"user_sex"]];
    taskObj.ownerHeadUrl = user_info [@"head_url"];

    return taskObj;
}

- (KGUserObject *)parseUserInfo: (NSDictionary *)user_info {
    KGUserObject *obj = [[KGUserObject alloc] init];
    obj.uid = [user_info [@"user_id"] integerValue];
    obj.uname = user_info [@"account"];
    obj.nickName = user_info [@"user_name"];
    obj.gender = [KGUtils convertGender:user_info [@"user_sex"]];
    obj.avatarUrl = user_info [@"head_url"];
    obj.vip = [user_info [@"user_v"] boolValue];
    obj.level = [user_info [@"user_star"] integerValue];
    obj.intro = user_info [@"user_desc"];
    return obj;
}


#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.goodsObj.good_photos count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    KGGoodsPhotoObject *photo = self.goodsObj.good_photos[indexPath.row];
    KGTaskGoodsPhotoCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kTaskGoodsPhotoCollectionViewCell" forIndexPath:indexPath];
    [cell.photoView setImageWithURL:[NSURL URLWithString:photo.good_head_url] placeholderImage:[UIImage imageNamed:kDefaultPlaceHolder] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSMutableArray *photoUrls = [NSMutableArray new];
    NSArray *photoObjArr = self.goodsObj.good_photos;
    for (KGGoodsPhotoObject *obj in photoObjArr) {
        if (!obj.good_main_url) {
            continue;
        }
        [photoUrls addObject:[NSURL URLWithString:obj.good_photo_url]];
    }
    KGPhotoBrowserViewController *controller = [[KGPhotoBrowserViewController alloc] initWithImgUrls:photoUrls index:indexPath.row];
    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];;
    [self presentViewController:nc animated:YES completion:nil];
}


#pragma UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(95, 95);
}

- (void)chatButtonClicked: (UIButton *) sender
{
    if (![APPCONTEXT checkLogin]) {
        [JDStatusBarNotification showWithStatus:@"请先登录~" dismissAfter:2.0];
        return;
    }
    if (APPCONTEXT.currUser.uid == self.taskObj.ownerId) {
        [JDStatusBarNotification showWithStatus:@"您不能和自己聊天~" dismissAfter:2.0];
        return;
    }
    if (self.taskObj.ownerId <= 0) {
        return;
    }

    UIStoryboard *sb = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    KGChatViewController *chatViewController = (KGChatViewController *)[sb instantiateViewControllerWithIdentifier:@"kChatViewController"];
    chatViewController.toUserId = self.taskObj.ownerId;
    [self.navigationController pushViewController:chatViewController animated:YES];

}



@end
