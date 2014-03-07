//
//  KGFindKelpViewController.m
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerListViewController.h"
#import "KGBuyerListViewCell.h"
#import "KGConditionSelectBar.h"
#import "KGBuyerDetailViewController.h"
#import "XMPPManager.h"
#import "UIImageView+WebCache.h"


static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController () <KGConditionDelegate>

//@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet KGConditionSelectBar *conditionSelectBar;

@end

@implementation KGBuyerListViewController

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
    self.conditionSelectBar.canvasView = self.view;
    self.conditionSelectBar.delegate = self;
//    if (![KGUtils isHigherIOS7]) {
//        UIImage *image = [UIImage imageNamed:@"nav_bar_44"];
//        [self.navigationController.navigationBar setBackgroundImage:image forBarMetrics:UIBarMetricsDefault];
//    }

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KGBuyerDetailViewController *detailController = segue.destinationViewController;
    [detailController setHidesBottomBarWhenPushed:YES];

//    BOOL connect = [[XMPPManager sharedInstance] connect];
//    NSLog(@"prepareForSegue, connect: %d", connect);
//    NSLog(@"prepareForSegue, isXmppConnected: %d", [[XMPPManager sharedInstance] isXmppConnected]);

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"kBuyerListViewCell";

    KGBuyerListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KGBuyerListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
//    cell.headImageView.clipsToBounds = YES;
//    [cell.headImageView setContentMode:UIViewContentModeScaleAspectFill];
    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=9540c45036a85edffa8cf9237d6c0823/3ac79f3df8dcd10093d05521708b4710b9122f65.jpg"] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
    return cell;
}



#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
