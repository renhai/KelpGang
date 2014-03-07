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

@interface KGBuyerDetailViewController () <SwipeViewDataSource, SwipeViewDelegate>
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIImageView *headImgView;
@property (weak, nonatomic) IBOutlet SwipeView *swipeView;
- (IBAction)goBack:(UIBarButtonItem *)sender;

@end

@implementation KGBuyerDetailViewController

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
    UIView *chatView = [[UIView alloc] initWithFrame:CGRectMake(0, 440, 320, 64)];
    [chatView setBackgroundColor:RGBCOLOR(246, 251, 249)];
    [self.view addSubview:chatView];

    self.swipeView.dataSource = self;
    self.swipeView.delegate = self;
    self.swipeView.alignment = SwipeViewAlignmentEdge;
    self.swipeView.pagingEnabled = YES;
    self.swipeView.itemsPerPage = 1;
//    self.swipeView.truncateFinalPage = YES;
}


#pragma SwipViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    return 10;
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    if (!view)
    {
    	//load new item view instance from nib
        //control events are bound to view controller in nib file
        //note that it is only safe to use the reusingView if we return the same nib for each
        //item view, if different items have different contents, ignore the reusingView value
        UIView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 87, 85)];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 85, 85)];
        [imageView setContentMode:UIViewContentModeScaleAspectFill];
        [imageView setClipsToBounds:YES];
        [imageView setImageWithURL:[NSURL URLWithString:@"http://h.hiphotos.baidu.com/image/w%3D2048/sign=96ba60248b13632715edc533a5b7a1ec/d8f9d72a6059252d534fe1fc359b033b5ab5b9ea.jpg"] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
        [containerView addSubview:imageView];

    	view = containerView;
    }
    return view;
}

#pragma SwipeViewDelegate
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selelect index is : %d", index);
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
