//
//  KGDiscoverDetailViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverDetailViewController.h"
#import "KGDiscoverDetailCell.h"
#import "KGDiscovery.h"

@interface KGDiscoverDetailViewController () <UIWebViewDelegate, UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) NSArray *userArr;

@property (nonatomic, strong) KGDiscovery *discovery;

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
    [self reshreshThisView];
}

- (void)reshreshThisView {
    NSDictionary *params = @{@"discovery_id": @(self.discoveryId)};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/discovery/getDiscoveryInfo" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResult:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.discovery = [[KGDiscovery alloc] init];
            self.discovery.discoveryId = self.discoveryId;
            self.discovery.title = data[@"title"];
            self.discovery.article = data[@"article"];
            self.discovery.topImageUrl = data[@"backGround_pic_url"];

            NSArray *buyer_info = data[@"buyer_info"];
            self.userArr = buyer_info;

            [self initViews];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)initViews {
    [self setTitle:self.discovery.title];
    UIView *topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 135)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:topView.frame];
    [imageView setImageWithURL:[NSURL URLWithString:self.discovery.topImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
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
    [webView loadHTMLString:self.discovery.article baseURL:nil];
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
