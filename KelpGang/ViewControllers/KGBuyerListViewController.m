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
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KGBuyerDetailViewController *detailController = segue.destinationViewController;
    [detailController setHidesBottomBarWhenPushed:YES];

    BOOL connect = [[XMPPManager sharedInstance] connect];
    NSLog(@"prepareForSegue, connect: %d", connect);
    NSLog(@"prepareForSegue, isXmppConnected: %d", [[XMPPManager sharedInstance] isXmppConnected]);

}


#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
