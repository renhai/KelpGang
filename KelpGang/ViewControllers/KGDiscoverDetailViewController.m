//
//  KGDiscoverDetailViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverDetailViewController.h"
#import "KGDiscoverDetailCell.h"

@interface KGDiscoverDetailViewController () <UIWebViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *userArr;

@end

@implementation KGDiscoverDetailViewController

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
    self.title = @"英国海淘指南";
    [self mockData];
    [self initViews];
}

- (void)mockData {
    NSDictionary *one = @{@"userName": @"王帮主", @"gender":@"M", @"imageUrl": @"http://b.hiphotos.baidu.com/image/pic/item/32fa828ba61ea8d3345fa68b950a304e241f58c4.jpg"};
    NSDictionary *two = @{@"userName": @"哈哈哈是", @"gender":@"F", @"imageUrl": @"http://f.hiphotos.baidu.com/image/pic/item/eaf81a4c510fd9f9c2ae5789272dd42a2934a490.jpg"};
    NSDictionary *three = @{@"userName": @"andy ren", @"gender":@"M", @"imageUrl": @"http://d.hiphotos.baidu.com/image/pic/item/42166d224f4a20a40503fcc392529822720ed091.jpg"};
    NSDictionary *four = @{@"userName": @"myrenhai", @"gender":@"F", @"imageUrl": @"http://b.hiphotos.baidu.com/image/pic/item/4d086e061d950a7b2b8b8dc008d162d9f2d3c97c.jpg"};
    NSDictionary *five = @{@"userName": @"任海", @"gender":@"M", @"imageUrl": @"http://c.hiphotos.baidu.com/image/pic/item/314e251f95cad1c865143c237d3e6709c93d5103.jpg"};
    NSDictionary *six = @{@"userName": @"kongzhihui", @"gender":@"F", @"imageUrl": @"http://d.hiphotos.baidu.com/image/pic/item/0df3d7ca7bcb0a46b99c483d6963f6246b60af7c.jpg"};
    self.userArr = @[one, two, three, four, five, six];
}

- (void)initViews {
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:topView.frame];
    [imageView setImageWithURL:[NSURL URLWithString:self.imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    imageView.contentMode = UIViewContentModeScaleAspectFill;
    imageView.clipsToBounds = YES;
    [topView addSubview:imageView];
    [self.view addSubview:topView];

    UIView *midView = [[UIView alloc] initWithFrame:CGRectMake(0, 135, SCREEN_WIDTH, 60)];
    midView.backgroundColor = RGB(246, 251, 251);

    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    layout.sectionInset = UIEdgeInsetsMake(-5, 10, 0, 10);
    UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(20, 0, 280, 60) collectionViewLayout:layout];
    [collectionView setDataSource:self];
    [collectionView setDelegate:self];
    [collectionView registerClass:[KGDiscoverDetailCell class] forCellWithReuseIdentifier:@"cellIdentifier"];
    [collectionView setBackgroundColor:[UIColor clearColor]];
    [midView addSubview:collectionView];

    [self.view addSubview:midView];

    CGFloat webViewHeight = SCREEN_HEIGHT - TABBAR_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT - 195;
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 190, SCREEN_WIDTH, webViewHeight)];
    webView.delegate = self;
    [webView loadHTMLString:@"<h3>海淘已经不是新鲜事了</h3>三季度非垃圾收代理费就爱上了快点放假啦圣诞节法拉盛分类拉三季度了房间爱上了对方就阿里水电费法开始了对方就拉倒法拉克水电费拉丝级东方离开家阿斯顿浪费空间阿里山快点放假啦水电费加拉斯的减肥拉丝级东方拉丝机撒地方加拉斯的减肥拉丝级东方路第十六课枫蓝国际老实交代干辣椒十多个垃圾是个坚实的房价萨克的礼服加拉斯加对方了就立刻就死定了<h3>附近阿里是大姐夫拉萨的减肥</h3>拉萨京东方拉丝级东方路科技阿斯蒂芬李会计阿萨德路附近阿斯顿浪费三季度非垃圾收代理费就爱上了快点放假啦圣诞节法拉盛分类拉三季度了房间爱上了对方就阿里水电费法开始了对方就拉倒法拉克水电费拉丝级东方离开家阿斯顿浪费空间阿里山快点放假啦水电费加拉斯的减肥拉丝级东方拉丝机撒地方加拉斯的减肥拉丝级东方路第十六课枫蓝国际老实交代干辣椒十多个垃圾是个坚实的房价萨克的礼服加拉斯加对方了就立刻就死定了附近阿里是大姐夫拉萨的减肥拉萨京东方拉丝级东方路科技阿斯蒂芬李会计阿萨德路附近阿斯顿浪费" baseURL:nil];
    [self.view addSubview:webView];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma UIWebViewDelegate

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    return YES;
}
- (void)webViewDidStartLoad:(UIWebView *)webView {

}
- (void)webViewDidFinishLoad:(UIWebView *)webView {

}
- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    DLog(@"error: %@", error);
}

#pragma UICollectionViewDataSource

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return [self.userArr count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *info = self.userArr[indexPath.row];
    KGDiscoverDetailCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cellIdentifier" forIndexPath:indexPath];
    [cell setObject:info];
    return cell;
}


#pragma UICollectionViewDelegateFlowLayout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(60, 40);
}

@end
