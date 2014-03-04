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

static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGBuyerListViewController () <KGConditionDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
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

#pragma mark - UICollectionView Datasource
- (NSInteger)collectionView:(UICollectionView *)view numberOfItemsInSection:(NSInteger)section;
{
    return 51;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)cv cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    KGBuyerListViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kFindKelpCell forIndexPath:indexPath];
//    cell.headImageView.clipsToBounds = YES;
//    [cell.headImageView setContentMode:UIViewContentModeScaleAspectFill];

    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    

    return cell;
}

//- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
//{
//    FlickrPhotoHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"FlickPhotoHeaderView" forIndexPath:indexPath];
//    NSString *searchTerm = self.searches[indexPath.section];
//    [headerView setSearchText:searchTerm];
//    return headerView;
//}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(!self.sharing)
//    {
//        NSString *searchTerm = self.searches[indexPath.section];
//        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
//        [self performSegueWithIdentifier:@"ShowFlickrPhoto" sender:photo];
//        [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
//    }
//    else
//    {
//        NSString *searchTerm = self.searches[indexPath.section];
//        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
//        [self.selectedPhotos addObject:photo];
//    }

}

- (void)collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath
{
//    if(self.sharing)
//    {
//        NSString *searchTerm = self.searches[indexPath.section];
//        FlickrPhoto *photo = self.searchResults[searchTerm][indexPath.row];
//        [self.selectedPhotos removeObject:photo];
//    }
}

//- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
//{
//    return retval;
//}

//- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
//{
//    return UIEdgeInsetsMake(50, 20, 50, 20);
//}


-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    KGBuyerDetailViewController *detailController = segue.destinationViewController;
    [detailController setHidesBottomBarWhenPushed:YES];

}


#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
