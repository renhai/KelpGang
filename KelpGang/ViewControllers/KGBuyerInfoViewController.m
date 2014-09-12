//
//  KGBuyerInfoViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-26.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerInfoViewController.h"
#import "KGBuyerRefPicturesCell.h"
#import "KGBuyerDescriptionCell.h"
#import "KGBuyerCommentCell.h"
#import "MWPhotoBrowser.h"
#import "KGPicBottomView.h"
#import "KGChatViewController.h"
#import "KGBuyerRouteCell.h"
#import "KGGoodsObject.h"
#import "KGGoodsPhotoObject.h"
#import "KGJourneyObject.h"
#import "KGBuyerRefPictureCollectionViewCell.h"
#import "KGCommentListController.h"



@interface KGBuyerInfoViewController () <MWPhotoBrowserDelegate, UICollectionViewDelegate, UICollectionViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSMutableArray *photos;

@property (nonatomic, strong) KGUserObject *userObj;
@property (nonatomic, strong) KGJourneyObject *journeyObj;
@property (nonatomic, strong) NSArray *good_info;
@property (nonatomic, strong) NSArray *comment_info;
@property (nonatomic, assign) NSInteger comment_number;
@property (nonatomic, assign) NSInteger currAlbumIndex;
@property (nonatomic, assign) BOOL isFollowed;

@end

@implementation KGBuyerInfoViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarbuttonItem];

    self.photos = [[NSMutableArray alloc] init];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid), @"travel_id": @(self.travelId)};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/getUserTravel" params:params success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.userObj = [self parseUserInfo:data[@"user_info"]];
            self.journeyObj = [self getJourneyObj:data[@"travel_info"]];
            self.good_info = [self getGoodsList:data[@"good_info"]];
            self.comment_info = data[@"comment_info"];
            self.comment_number = [data[@"comment_number"] integerValue];
            self.isFollowed = [data[@"isFollowed"] boolValue];
            [self.tableView reloadData];
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    UIViewController *destController = segue.destinationViewController;
    if ([destController isKindOfClass:[KGChatViewController class]]) {
        KGChatViewController *chatViewController = (KGChatViewController *)destController;
        chatViewController.toUserId = self.userObj.uid;
    } else if ([destController isKindOfClass:[KGCommentListController class]]) {
        KGCommentListController *commentController = (KGCommentListController *)destController;
        commentController.userId = self.userObj.uid;
    }
}

- (BOOL)shouldPerformSegueWithIdentifier:(NSString *)identifier sender:(id)sender {
    if ([@"kChatSegue" isEqualToString:identifier]) {
        if (![APPCONTEXT checkLogin]) {
            [JDStatusBarNotification showWithStatus:@"请先登录~" dismissAfter:2.0];
            return NO;
        }
        if (APPCONTEXT.currUser.uid == self.userObj.uid) {
            [JDStatusBarNotification showWithStatus:@"您不能和自己聊天~" dismissAfter:2.0];
            return NO;
        }
        if (self.userObj.uid <= 0) {
            return NO;
        }
    }
    if ([@"kCommentListSegue" isEqualToString:identifier]) {
        if (self.comment_number == 0) {
            return NO;
        }
    }

    return YES;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if (self.good_info) {
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return self.comment_info.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerDescriptionCell" forIndexPath:indexPath];
            KGBuyerDescriptionCell *dCell = (KGBuyerDescriptionCell *)cell;
            [dCell setUserInfo:self.userObj];
            [dCell.followButton setTitle:self.isFollowed ? @"取消关注" : @"关注" forState: UIControlStateNormal];
            [dCell.followButton addTarget:self action:@selector(followAction:) forControlEvents:UIControlEventTouchUpInside];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerRouteCell" forIndexPath:indexPath];
            KGBuyerRouteCell *rCell = (KGBuyerRouteCell *)cell;
            [rCell setRouteInfo:self.journeyObj];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerPictureCell" forIndexPath:indexPath];
            KGBuyerRefPicturesCell *pCell = (KGBuyerRefPicturesCell *)cell;
            pCell.photosCollectionView.delegate = self;
            pCell.photosCollectionView.dataSource = self;
        }
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerCommentTitleCell" forIndexPath:indexPath];
            UILabel *label = (UILabel *)[cell viewWithTag:1];
            label.text = [NSString stringWithFormat:@"评论%i", self.comment_number];
            [label sizeToFit];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerCommentCell" forIndexPath:indexPath];
            KGBuyerCommentCell *cCell = (KGBuyerCommentCell *)cell;
            [cCell setcommentInfo:self.comment_info[indexPath.row - 1]];
        }
    }

    return cell;
}



- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    CGFloat height = 0;
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                height = 106.0;
                break;
            case 1:
                height = 87.0;
                break;
            case 2:
                height = 138.0;
                break;
            default:
                break;
        }

    } else {
        switch (indexPath.row) {
            case 0:
                height = 46.0;
                break;
            default:
                height = 85.0;
                break;
        }
    }
    return height;
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return 0;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return _photos.count;
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < _photos.count)
        return [_photos objectAtIndex:index];
    return nil;
}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    if (!self.photos || self.photos.count == 0) {
        return nil;
    }
    MWPhoto *photo = [self.photos objectAtIndex:index];
    KGGoodsObject *goodsObj = self.good_info[self.currAlbumIndex];
    NSString *title = goodsObj.good_name;
    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:title chatBlock:^(UIButton *sender) {
        if (![APPCONTEXT checkLogin]) {
            [JDStatusBarNotification showWithStatus:@"请先登录~" dismissAfter:2.0];
            return;
        }
        if (APPCONTEXT.currUser.uid == self.userObj.uid) {
            [JDStatusBarNotification showWithStatus:@"您不能和自己聊天~" dismissAfter:2.0];
            return;
        }
        if (self.userObj.uid <= 0) {
            return;
        }
        KGChatViewController *chatViewController = (KGChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
        chatViewController.toUserId = self.userObj.uid;
        self.navigationController.navigationBar.translucent = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController pushViewController:chatViewController animated:YES];
        NSLog(@"do chat operation");
    } collectBlock:^(UIButton *sender) {
        NSLog(@"do collect operation");
        if (![APPCONTEXT checkLogin]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
            return;
        }
        NSInteger goodsId = goodsObj.goods_id;
        KGGoodsPhotoObject *goodsPhoto = goodsObj.good_photos[index];
        NSInteger photoId = goodsPhoto.good_photo_id;
        NSInteger travelId = self.journeyObj.journeyId;
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                 @"photo_id": @(photoId),
                                 @"good_id": @(goodsId),
                                 @"travel_id": @(travelId),
                                 @"session_key": APPCONTEXT.currUser.sessionKey};
        [[KGNetworkManager sharedInstance] postRequest:@"/mobile/good/addCollection" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"收藏成功" dismissAfter:2.0];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }];
    return captionView;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return @"";
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (NSArray *)getGoodsList:(NSArray *)goodsInfo {
    NSMutableArray *result = [[NSMutableArray alloc]init];
    for (NSDictionary *info in goodsInfo) {
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
        [result addObject:obj];
    }
    return result;
}

- (KGJourneyObject *)getJourneyObj: (NSDictionary *)info {
    KGJourneyObject *result = [[KGJourneyObject alloc]init];
    result.journeyId = [info[@"travel_id"] integerValue];
    result.toCountry = info[@"to"];
    result.fromCity = info[@"from"];
    result.backDate = [NSDate dateWithTimeIntervalSince1970:[info[@"travel_back_time"] doubleValue]];
    result.startDate = [NSDate dateWithTimeIntervalSince1970:[info[@"travel_start_time"] doubleValue]];
    result.desc = info[@"travel_desc"];
    return result;
}

- (void)followAction: (UIButton *)sender {
    if (![APPCONTEXT checkLogin]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"请先登录" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSInteger followId = self.userObj.uid;
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"follow_id": @(followId),
                             @"session_key": APPCONTEXT.currUser.sessionKey};

    if (self.isFollowed) {
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/user/disFollow" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            if ([KGUtils checkResultWithAlert:responseObject]) {
                [JDStatusBarNotification showWithStatus:@"取消关注成功" dismissAfter:2.0];
                self.isFollowed = NO;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
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
                self.isFollowed = YES;
                [self.tableView reloadRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]]withRowAnimation:UITableViewRowAnimationNone];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
        }];
    }

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
    return [self.good_info count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {

    KGBuyerRefPictureCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kBuyerRefPictureCollectionViewCell" forIndexPath:indexPath];
    NSString *imageUrl = [self.good_info[indexPath.row] valueForKey:@"good_default_head_url"];
    [cell.photoView setImageWithURL:[NSURL URLWithString:imageUrl] placeholderImage:[UIImage imageNamed:@"default-placeholder"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}


- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"selelect index is : %d", indexPath.row);

    self.currAlbumIndex = indexPath.row;
    [self.photos removeAllObjects];
    NSArray *imgArry = [self.good_info[indexPath.row] valueForKey:@"good_photos"];
    for (KGGoodsPhotoObject *one in imgArry) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:one.good_photo_url]]];
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.extendedLayoutIncludesOpaqueBars = YES;
    browser.zoomPhotosToFill = NO;
    browser.enableGrid = NO;
    browser.startOnGrid = NO;
    browser.enableSwipeToDismiss = YES;
    browser.alwaysShowControls = NO;
    browser.delayToHideElements = -1;
    [browser setCurrentPhotoIndex:0];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    [self presentViewController:nc animated:YES completion:nil];
}

@end
