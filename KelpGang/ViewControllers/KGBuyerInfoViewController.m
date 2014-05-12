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
@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSMutableArray *photos;

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
    self.imageUrls = @[@"http://e.hiphotos.baidu.com/image/w%3D2048/sign=6fb2d513d60735fa91f049b9aa690eb3/f703738da977391277b1f269fa198618367ae227.jpg",
                       @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=c6c8dc509c2f07085f052d00dd1cb899/472309f7905298223310f7dcd5ca7bcb0a46d48a.jpg",
                       @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=3577b2edd762853592e0d521a4d776c6/6d81800a19d8bc3e1f12ced5808ba61ea8d34593.jpg",
                       @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=807be20a544e9258a63481eea8bad058/4610b912c8fcc3ce4aa5c35d9045d688d43f2072.jpg",
                       @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=bc8f94038544ebf86d71633fedc1d62a/5882b2b7d0a20cf4e64253df74094b36adaf99e4.jpg",
                       @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=908c963b938fa0ec7fc7630d12af58ee/d52a2834349b033ba9e9a8d217ce36d3d539bd51.jpg",
                       @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=c2974a1513dfa9ecfd2e511756e8f603/1b4c510fd9f9d72a501d3814d62a2834349bbbb9.jpg"];
    self.photos = [[NSMutableArray alloc] init];
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
    return [self.imageUrls count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    UIView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 97, 95)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    [imageView setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:index]] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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

    [self.photos removeAllObjects];
    for (NSString *url in self.imageUrls) {
        [self.photos addObject:[MWPhoto photoWithURL:[NSURL URLWithString:url]]];
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
    [browser setCurrentPhotoIndex:index];

    UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    buttonItem.tintColor = [UIColor whiteColor];
    browser.navigationItem.leftBarButtonItem = buttonItem;

    [self.navigationController pushViewController:browser animated:YES];

    //    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    //    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    //    [self presentViewController:nc animated:YES completion:nil];
    
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
    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:[NSString stringWithFormat:@"photo title - %i", index] chatBlock:^(UIButton *sender) {
        KGChatViewController *chatViewController = (KGChatViewController *)[self.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
        self.navigationController.navigationBar.translucent = NO;
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
