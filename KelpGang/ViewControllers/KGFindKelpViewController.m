//
//  KGFindKelpViewController.m
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGFindKelpViewController.h"
#import "KGFindKelpViewCell.h"
#import "KGCountryConditionView.h"
#import "KGCountryConditionViewController.h"

static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGFindKelpViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *conditionView;
@property (weak, nonatomic) IBOutlet UIImageView *headLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
- (IBAction)showCountryCondition:(id)sender;

@property (nonatomic, assign) BOOL showCountryView;
@property (nonatomic, strong) UIView *countryConditionView;

@end

@implementation KGFindKelpViewController

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
    [self.headLineImageView setHidden:YES];
    [self.headIndicatorImageView setHidden:YES];
//    [self.collectionView registerClass:[KGFindKelpViewCell class] forCellWithReuseIdentifier:@"mycell"];

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
    KGFindKelpViewCell *cell = [cv dequeueReusableCellWithReuseIdentifier:kFindKelpCell forIndexPath:indexPath];
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

- (IBAction)showCountryCondition:(id)sender {
    if (self.showCountryView) {
        self.showCountryView = NO;
        [self.headLineImageView setHidden:YES];
        [self.headIndicatorImageView setHidden:YES];
        [self.countryConditionView removeFromSuperview];
        UIImage *arrowDownImg = [UIImage imageNamed:@"arrow-down.png"];
        [self.arrowImageView setImage:arrowDownImg];
    } else {
        [self.headLineImageView setHidden:NO];
        [self.headIndicatorImageView setHidden:NO];
//        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
//        KGCountryConditionView *countryConditionView = [nibArr objectAtIndex:0];
//        CGRect conditionFrame = self.conditionView.frame;
//        CGRect countryFrame = countryConditionView.frame;
//        countryFrame.origin.y = conditionFrame.origin.y + conditionFrame.size.height;
//        countryConditionView.frame = countryFrame;

//        countryConditionView.continentTableView.backgroundColor = [UIColor clearColor];
        UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        KGCountryConditionViewController *conditionController = [storyboard instantiateViewControllerWithIdentifier:@"kCountryConditionViewController"];

//        [conditionController.view setBackgroundColor:[UIColor redColor]];
        conditionController.view.frame = CGRectMake(0, self.conditionView.frame.origin.y + self.conditionView.frame.size.height, 320, 360);
        self.countryConditionView = conditionController.view;
        [self.view addSubview:self.countryConditionView];
        self.showCountryView = YES;
        UIImage *arrowUpImg = [UIImage imageNamed:@"arrow-up.png"];
        [self.arrowImageView setImage:arrowUpImg];
    }
}

@end
