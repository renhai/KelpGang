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

    self.imageUrls = @[@"http://f.hiphotos.baidu.com/image/w%3D2048/sign=c0745bf8a586c91708035539fd0571cf/0824ab18972bd40760446cfd79899e510fb3092a.jpg",
                       @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=c6c8dc509c2f07085f052d00dd1cb899/472309f7905298223310f7dcd5ca7bcb0a46d48a.jpg",
                       @"http://c.hiphotos.baidu.com/image/w%3D2048/sign=022720314e086e066aa8384b36307af4/7acb0a46f21fbe09d1dd7f1469600c338744ad2b.jpg",
                       @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=80cd02e4b11c8701d6b6b5e613479f2f/b3fb43166d224f4a8e1acf130bf790529822d12b.jpg",
                       @"http://g.hiphotos.baidu.com/image/w%3D2048/sign=b1b6a1081d30e924cfa49b3178306f06/9922720e0cf3d7cacd758376f01fbe096b63a92b.jpg",
                       @"http://f.hiphotos.baidu.com/image/w%3D2048/sign=6679150dfadcd100cd9cff2146b34610/0eb30f2442a7d933952b5b73af4bd11373f0012a.jpg",
                       @"http://h.hiphotos.baidu.com/image/w%3D2048/sign=9ec10093c1cec3fd8b3ea075e2b0d53f/72f082025aafa40f6c283382a964034f79f01986.jpg"];
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
    [[SDImageCache sharedImageCache] clearDisk];
    [[SDImageCache sharedImageCache] clearMemory];

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
    [browser setCurrentPhotoIndex:index];

//    [self.navigationController pushViewController:browser animated:YES];

    UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
    nc.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:nc animated:YES completion:nil];

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
    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:[NSString stringWithFormat:@"photo title - %i", index]];
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
