//
//  KGFindKelpViewController.m
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerListViewController.h"
#import "KGBuyerListViewCell.h"
#import "KGBuyerDetailViewController.h"
#import "XMPPManager.h"
#import "UIImageView+WebCache.h"
#import "KGConditionBar.h"


static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController () <KGConditionDelegate>

@property (weak, nonatomic) IBOutlet KGConditionBar *conditionBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation KGBuyerListViewController

-(void) dealloc {

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
    self.conditionBar.canvasView = self.view;
    self.conditionBar.delegate = self;

    if (!iPhone5) {
        CGRect frame = self.tableView.frame;
        frame.size.height = SCREEN_HEIGHT - STATUSBAR_HEIGHT - NAVIGATIONBAR_HEIGHT - TABBAR_HEIGHT - self.conditionBar.frame.size.height;
        self.tableView.frame = frame;
    }

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
    cell.headImageView.clipsToBounds = YES;
    cell.headImageView.ContentMode = UIViewContentModeScaleAspectFill;
    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=828c8a708544ebf86d71633fedc1d62a/5882b2b7d0a20cf4d8414dac74094b36adaf99f4.jpg"] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
    return cell;
}



#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
