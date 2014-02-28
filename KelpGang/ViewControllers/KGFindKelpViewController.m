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
//#import "KGCountryConditionViewController.h"

static NSString * const kFindKelpCell = @"kFindKelpCell";

@interface KGFindKelpViewController ()
@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;
@property (weak, nonatomic) IBOutlet UIView *conditionView;
@property (weak, nonatomic) IBOutlet UIImageView *headLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;
- (IBAction)showCountryCondition:(id)sender;

@property (nonatomic, assign) BOOL showCountryView;
@property (nonatomic, strong) KGCountryConditionView *countryConditionView;
@property (nonatomic, strong) NSArray *continents;
@property (nonatomic, strong) NSDictionary *countrys;
@property (nonatomic, copy) NSString *currContinent;

//@property (nonatomic, strong) KGCountryConditionViewController *countryConditionViewController;

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
    self.continents = @[@"热门国家", @"亚洲", @"欧洲", @"非洲", @"北美洲", @"南美洲", @"大洋洲"];
    self.countrys = @{@"热门国家":@[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"],
      @"亚洲": @[@"日本",@"韩国",@"泰国"],
      @"欧洲": @[@"英国",@"法国"],
      @"非洲": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"],
      @"北美洲": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"],
      @"南美洲": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"],
      @"大洋洲": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]};
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
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
        KGCountryConditionView *countryConditionView = [nibArr objectAtIndex:0];
        self.countryConditionView = countryConditionView;
        CGRect countryFrame = countryConditionView.frame;
        countryFrame.origin.y = self.conditionView.frame.origin.y + self.conditionView.frame.size.height;
        countryConditionView.frame = countryFrame;
        [self.countryConditionView.continentTableView setSeparatorColor:[UIColor clearColor]];
//        [self.countryConditionView.countryTableView setSeparatorColor:[UIColor redColor]];
        NSIndexPath *firstLine= [NSIndexPath indexPathForRow:0 inSection:0];
        [self.countryConditionView.continentTableView selectRowAtIndexPath:firstLine animated:YES scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.countryConditionView.continentTableView didSelectRowAtIndexPath:firstLine];
        self.currContinent = [self.continents objectAtIndex:0];

        [self.view addSubview:self.countryConditionView];
        self.showCountryView = YES;
        UIImage *arrowUpImg = [UIImage imageNamed:@"arrow-up.png"];
        [self.arrowImageView setImage:arrowUpImg];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView == self.countryConditionView.continentTableView) {
        return [self.continents count];
    } else {
        return [[self.countrys objectForKey:self.currContinent] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kLeftTableViewCell = @"kLeftTableViewCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
    if (cell == nil) {
        NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
        cell = [nibArr objectAtIndex:1];
    }


    if(tableView == self.countryConditionView.continentTableView) {
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [self.continents objectAtIndex:[indexPath row]];
    } else {
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [[self.countrys objectForKey:self.currContinent]objectAtIndex:[indexPath row]];
    }

    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(tableView == self.countryConditionView.continentTableView) {
        NSInteger row = indexPath.row;
        NSLog(@"item%d is: %@", row, [self.continents objectAtIndex:row]);
        NSString *continent = [self.continents objectAtIndex:row];
        self.currContinent = continent;
        [self.countryConditionView.countryTableView reloadData];
    } else {
        self.showCountryView = NO;
        [self.headLineImageView setHidden:YES];
        [self.headIndicatorImageView setHidden:YES];
        [self.countryConditionView removeFromSuperview];
        UIImage *arrowDownImg = [UIImage imageNamed:@"arrow-down.png"];
        [self.arrowImageView setImage:arrowDownImg];

        NSString *selectCountry = [[self.countrys objectForKey:self.currContinent]objectAtIndex:[indexPath row]];
        [self.countryBtn setTitle:selectCountry forState:UIControlStateNormal];
        
    }

}


@end
