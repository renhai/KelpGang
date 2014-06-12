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
#import "KGCommentListViewController.h"


@interface KGBuyerInfoViewController () <SwipeViewDataSource, SwipeViewDelegate, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *comments;
@property (nonatomic, strong) NSMutableArray *photos;


@property (nonatomic, strong) NSDictionary *user_info;
@property (nonatomic, strong) NSDictionary *travel_info;
@property (nonatomic, strong) NSArray *good_info;
@property (nonatomic, assign) NSInteger currAlbumIndex;

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

    //for test
    self.comments = @[@"1", @"2", @"3", @"4", @"5"];
    self.photos = [[NSMutableArray alloc] init];

    NSDictionary *params = @{@"user_id": @0, @"travel_id": @(self.travelId)};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/travel/getUserTravel" params:params success:^(id responseObject) {
        NSLog(@"%@", responseObject);
        NSDictionary *dic = (NSDictionary *)responseObject;
        NSDictionary *data = dic[@"data"];
        self.user_info = data[@"user_info"];
        self.travel_info = data[@"travel_info"];
        self.good_info = data[@"good_info"];
        [self.tableView reloadData];
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
    
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 3;
    } else {
        return self.comments.count + 1;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerDescriptionCell" forIndexPath:indexPath];
            KGBuyerDescriptionCell *dCell = (KGBuyerDescriptionCell *)cell;
            dCell.headImgView.layer.cornerRadius = dCell.headImgView.frame.size.width / 2;
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerRouteCell" forIndexPath:indexPath];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerPictureCell" forIndexPath:indexPath];
            KGBuyerRefPicturesCell *pCell = (KGBuyerRefPicturesCell *)cell;
            pCell.swipeView.delegate = self;
            pCell.swipeView.dataSource = self;
            pCell.swipeView.alignment = SwipeViewAlignmentEdge;
            [pCell.swipeView reloadData];
        }
    } else {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerCommentTitleCell" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kBuyerCommentCell" forIndexPath:indexPath];
            KGBuyerCommentCell *cCell = (KGBuyerCommentCell *)cell;
            cCell.headImgView.layer.cornerRadius = cCell.headImgView.frame.size.width / 2;
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


#pragma SwipViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.good_info count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 97, 95)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    NSString *imageUrl = self.good_info[index][@"good_default_head_url"];
    [imageView setImageWithURL:[NSURL URLWithString:imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    [containerView addSubview:imageView];

    view = containerView;
    return view;
}

#pragma SwipeViewDelegate
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selelect index is : %d", index);
    //for testing
    //    [[SDImageCache sharedImageCache] clearDisk];
    //    [[SDImageCache sharedImageCache] clearMemory];

    self.currAlbumIndex = index;
    [self.photos removeAllObjects];
    NSArray *imgArry = self.good_info[index][@"good_photos"];
    for (NSDictionary *one in imgArry) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:one[@"good_photo_url"]]]];
    }

    MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
    browser.displayActionButton = NO;
    browser.displayNavArrows = NO;
    browser.displaySelectionButtons = NO;
    browser.alwaysShowControls = NO;
    browser.wantsFullScreenLayout = YES;
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
    MWPhoto *photo = [self.photos objectAtIndex:index];
    NSString *title = self.good_info[self.currAlbumIndex][@"good_name"];
    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:title chatBlock:^(UIButton *sender) {
        KGChatViewController *chatViewController = (KGChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
        self.navigationController.navigationBar.translucent = NO;
        [self dismissViewControllerAnimated:NO completion:nil];
        [self.navigationController pushViewController:chatViewController animated:YES];
        NSLog(@"do chat operation");
    } collectBlock:^(UIButton *sender) {
        NSLog(@"do collect operation");
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


@end
