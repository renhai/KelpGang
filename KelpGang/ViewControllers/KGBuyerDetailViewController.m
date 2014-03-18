//
//  KGBuyerDetailViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerDetailViewController.h"
#import "SwipeView.h"
#import "UIImageView+WebCache.h"
#import "MWPhotoBrowser.h"
#import "KGPicBottomView.h"
#import "KGChatViewController.h"

@interface KGBuyerDetailViewController () <SwipeViewDataSource, SwipeViewDelegate, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
- (IBAction)goBack:(UIBarButtonItem *)sender;

@property (nonatomic, strong) NSArray *imageUrls;
@property (nonatomic, strong) NSMutableArray *photos;
//@property (nonatomic, strong) NSMutableArray *thumbs;

@end

@implementation KGBuyerDetailViewController

- (void)dealloc
{
    NSLog(@"KGBuyerDetailViewController deallloc");
}

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
    NSLog(@"%@",self.navigationItem.leftBarButtonItem);
    self.headImgView.layer.cornerRadius = self.headImgView.frame.size.width / 2;
    [self.scrollView setContentSize:CGSizeMake(320, 600)];

    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.swipeView.alignment = SwipeViewAlignmentEdge;
//    self.swipeView.pagingEnabled = YES;
//    self.swipeView.itemsPerPage = 1;
//    self.swipeView.truncateFinalPage = YES;

    self.imageUrls = @[@"http://e.hiphotos.baidu.com/image/w%3D2048/sign=6fb2d513d60735fa91f049b9aa690eb3/f703738da977391277b1f269fa198618367ae227.jpg",
                       @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=c6c8dc509c2f07085f052d00dd1cb899/472309f7905298223310f7dcd5ca7bcb0a46d48a.jpg",
                       @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=3577b2edd762853592e0d521a4d776c6/6d81800a19d8bc3e1f12ced5808ba61ea8d34593.jpg",
                       @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=807be20a544e9258a63481eea8bad058/4610b912c8fcc3ce4aa5c35d9045d688d43f2072.jpg",
                       @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=bc8f94038544ebf86d71633fedc1d62a/5882b2b7d0a20cf4e64253df74094b36adaf99e4.jpg",
                       @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=908c963b938fa0ec7fc7630d12af58ee/d52a2834349b033ba9e9a8d217ce36d3d539bd51.jpg",
                       @"http://a.hiphotos.baidu.com/image/w%3D2048/sign=c2974a1513dfa9ecfd2e511756e8f603/1b4c510fd9f9d72a501d3814d62a2834349bbbb9.jpg"];
    self.photos = [[NSMutableArray alloc] init];
}


#pragma SwipViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return [self.imageUrls count];
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
//    if (!view)
//    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
        UIView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 97, 95)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 95, 95)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setImageWithURL:[NSURL URLWithString:[self.imageUrls objectAtIndex:index]] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
        [containerView addSubview:imageView];

    	view = containerView;
//    }
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

    [self setLeftBarButtonItem:browser];

    [self.navigationController pushViewController:browser animated:YES];

//    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
//    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
//    [self presentViewController:nc animated:YES completion:nil];

}

- (void)setLeftBarButtonItem: (UIViewController *) controller{
    UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(goBack:)];
    buttonItem.tintColor = [UIColor whiteColor];
    controller.navigationItem.leftBarButtonItem = buttonItem;
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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

//- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
//    if (index < _thumbs.count)
//        return [_thumbs objectAtIndex:index];
//    return nil;
//}

- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
    MWPhoto *photo = [self.photos objectAtIndex:index];
    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:[NSString stringWithFormat:@"photo title - %i", index] chatBlock:^(UIButton *sender) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        KGChatViewController *chatViewController = (KGChatViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"kChatViewController"];
        [self.navigationController pushViewController:chatViewController animated:YES];
        NSLog(@"do chat operation");
    } collectBlock:^(UIButton *sender) {
        NSLog(@"do collect operation");
    }];
    return captionView;
}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

//- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
//    return [[_selections objectAtIndex:index] boolValue];
//}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return @"";
}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
//    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
//    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
//}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
