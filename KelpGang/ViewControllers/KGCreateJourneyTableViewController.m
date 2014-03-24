//
//  KGCreateJourneyTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateJourneyTableViewController.h"
#import "KGJourneyAddImgTableViewCell.h"
#import "KGJourneyGoods.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"


@interface KGCreateJourneyTableViewController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *goodsArr;
//@property (nonatomic, assign) BOOL picExpanded;
@property (nonatomic, assign) NSInteger currTapCellIndex;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;

- (IBAction)addGoods:(UIButton *)sender;
- (IBAction)goBack:(UIBarButtonItem *)sender;

@end

@implementation KGCreateJourneyTableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.goodsArr = [[NSMutableArray alloc] init];
    self.currTapCellIndex = 0;

    [self loadAssets];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 4;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 4;
    } else if (section == 1) {
        return 1;
    } else if (section == 2) {
        return 1;
    } else {
        return self.goodsArr.count;
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        if (indexPath.row == 0) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kDesCountryCell" forIndexPath:indexPath];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kSrcCityCell" forIndexPath:indexPath];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kReturnTimeCell" forIndexPath:indexPath];
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kStartTimeCell" forIndexPath:indexPath];
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kDetailCell" forIndexPath:indexPath];
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kAddPicturesCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kPicturesCell" forIndexPath:indexPath];
        KGJourneyAddImgTableViewCell *jCell = (KGJourneyAddImgTableViewCell *) cell;
        KGJourneyGoods *goods = self.goodsArr[indexPath.row];
        [jCell setupData:goods];
        jCell.imgNameTextField.delegate = self;

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
//        jCell.imgScrollView.tag = indexPath.row;
        [jCell.imgScrollView addGestureRecognizer:tapGesture];

        [jCell.delGoodsBtn addTarget:self action:@selector(deleteGoods:) forControlEvents:UIControlEventTouchUpInside];

        NSArray *subviews = [jCell.imgScrollView subviews];
        NSInteger index = 0;
        for (UIView *view in subviews) {
            if ([view isKindOfClass:[KGJourneyPictureContainerView class]]) {
                KGJourneyPictureContainerView *jpcView = (KGJourneyPictureContainerView *) view;
                jpcView.imgIndex = index ++;
                jpcView.goodsIndex = indexPath.row;
                [jpcView.delBtn addTarget:self action:@selector(deleteImgFromGoods:) forControlEvents:UIControlEventTouchUpInside];
            }
        }
    }

    return cell;
}

- (void)tapPicture:(UIGestureRecognizer *) tapGesture {
    CGPoint point = [tapGesture locationInView:tapGesture.view];
    NSInteger index = (point.x / kImageContainerViewWidth);
    UITableViewCell *cell = (UITableViewCell *)tapGesture.view.superview.superview.superview;
    if (![KGUtils isHigherIOS7]) {
        cell = (UITableViewCell *)tapGesture.view.superview.superview;
    }
    NSIndexPath *tapPath = [self.tableView indexPathForCell:cell];
//    self.currEditCellIndex = tapGesture.view.tag;
    self.currTapCellIndex = tapPath.row;
    NSLog(@"curr tap cell index: %d, image index: %d", self.currTapCellIndex, index);
    KGJourneyGoods *goods = self.goodsArr[self.currTapCellIndex];
    if (index >= 0 && index < goods.pictures.count + 1) {
        if (index == goods.pictures.count) {
            [self showActionSheet];
        } else {

        }
    }

}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 46.0;
    } else if (indexPath.section == 1) {
        return 64.0;
    } else if (indexPath.section == 2){
        return 46.0;
    } else {
        return 177.0;
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0 || section == 3) {
        return 0;
    }
    return 10;
}


- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *sectionHeaderView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 10)];
    sectionHeaderView.backgroundColor = [UIColor clearColor];
    return sectionHeaderView;
}

//- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section {
//    if (section == 3) {
//        return 30;
//    }
//    return 0;
//}
//
//- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section {
//    UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
//    footerView.backgroundColor = [UIColor redColor];
//    return footerView;
//}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {

}


- (void)reloadRowAtIndex: (NSInteger) index {
    NSArray *pathArr = @[[NSIndexPath indexPathForRow:index inSection:3]];
    [self.tableView reloadRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
}

- (void)reloadCurrentEditRow {
    [self reloadRowAtIndex:self.currTapCellIndex];
}

- (void)showActionSheet {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view.window];
}

#pragma UIActionSheetDelegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
    } else if (buttonIndex == 1) {
        // 从相册中选取
//        if ([self isPhotoLibraryAvailable]) {
//            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
//            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
//            controller.allowsEditing = NO;
//            controller.delegate = self;
//            [self presentViewController:controller
//                               animated:YES
//                             completion:^(void){
//                                 NSLog(@"Picker View Controller is presented");
//                             }];
//        }
        NSMutableArray *photos = [[NSMutableArray alloc] init];
        NSMutableArray *thumbs = [[NSMutableArray alloc] init];
        @synchronized(_assets) {
            NSMutableArray *copy = [_assets copy];
            for (ALAsset *asset in copy) {
                [photos addObject:[MWPhoto photoWithURL:asset.defaultRepresentation.url]];
                [thumbs addObject:[MWPhoto photoWithImage:[UIImage imageWithCGImage:asset.thumbnail]]];
            }
        }
        self.photos = photos;
        self.thumbs = thumbs;

        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = YES;
        browser.alwaysShowControls = YES;
        browser.wantsFullScreenLayout = YES;
        browser.zoomPhotosToFill = YES;
        browser.enableGrid = NO;
        browser.startOnGrid = YES;
        browser.enableSwipeToDismiss = NO;
        [browser setCurrentPhotoIndex:0];

        _selections = [NSMutableArray new];
        for (int i = 0; i < photos.count; i++) {
            [_selections addObject:[NSNumber numberWithBool:NO]];
        }

        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        [self presentViewController:nc animated:YES completion:nil];
    }
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

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser thumbPhotoAtIndex:(NSUInteger)index {
    if (index < _thumbs.count)
        return [_thumbs objectAtIndex:index];
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    MWCaptionView *captionView = [[MWCaptionView alloc] initWithPhoto:photo];
//    return [captionView autorelease];
//}

//- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser actionButtonPressedForPhotoAtIndex:(NSUInteger)index {
//    NSLog(@"ACTION!");
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

//- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
//    return [NSString stringWithFormat:@"Photo %lu", (unsigned long)index+1];
//}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
    KGJourneyGoods *goods = self.goodsArr[self.currTapCellIndex];
    if (!goods) {
        return;
    }
    for (NSInteger i = 0; i < self.selections.count; i ++) {
        if ([self.selections[i] boolValue]) {
            ALAsset *asset = self.assets[i];
            ALAssetRepresentation *representation = [asset defaultRepresentation];
            CGImageRef originalImage = [representation fullResolutionImage];
            UIImage *original = [UIImage imageWithCGImage:originalImage];
            [goods.pictures addObject:original];
        }
    }
    [self reloadCurrentEditRow];

}


//#pragma UIImagePickerControllerDelegate
//
//- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
//    [picker dismissViewControllerAnimated:YES completion:^() {
//        UIImage *oriImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
//        KGJourneyGoods *goods = self.goodsArr[self.currTapCellIndex];
//        if (!goods) {
//            return;
//        }
//        [goods.pictures addObject:oriImage];
//        [self reloadCurrentEditRow];
//
//        NSLog(@"%@",info);
//    }];
//}
//
//- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
//    [picker dismissViewControllerAnimated:YES completion:nil];
//}



- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return YES;
}

- (IBAction)addGoods:(UIButton *)sender {
    KGJourneyGoods *goods = [[KGJourneyGoods alloc] init];
    [self.goodsArr addObject:goods];

//    [self reloadGoodsSection];
    NSIndexPath *lastIndePath = [NSIndexPath indexPathForRow:self.goodsArr.count - 1 inSection:3];
    [self.tableView beginUpdates];
    [self.tableView insertRowsAtIndexPaths:@[lastIndePath] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath: lastIndePath
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];

}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)deleteGoods:(UIButton *) sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
    if (![KGUtils isHigherIOS7]) {
        cell = (UITableViewCell *)sender.superview.superview;
    }
    NSIndexPath *tapPath = [self.tableView indexPathForCell:cell];
    [self.goodsArr removeObjectAtIndex:tapPath.row];
    [self reloadGoodsSection];
}

- (void)deleteImgFromGoods:(UIButton *) sender {
    KGJourneyPictureContainerView *view = (KGJourneyPictureContainerView *)sender.superview;
    self.currTapCellIndex = view.goodsIndex;
    NSLog(@"goodsIndex: %d, imgIndex: %d", view.goodsIndex, view.imgIndex);
    KGJourneyGoods *goods = self.goodsArr[view.goodsIndex];
    if (goods && goods.pictures && view.imgIndex < goods.pictures.count) {
        [goods.pictures removeObjectAtIndex:view.imgIndex];
        [self reloadCurrentEditRow];
    }
}

- (void)reloadGoodsSection {
    [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:3] withRowAnimation:UITableViewRowAnimationFade];
}

#pragma mark - Load Assets

- (void)loadAssets {

    // Initialise
    _assets = [NSMutableArray new];
    _assetLibrary = [[ALAssetsLibrary alloc] init];

    // Run in the background as it takes a while to get all assets from the library
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{

        NSMutableArray *assetGroups = [[NSMutableArray alloc] init];
        NSMutableArray *assetURLDictionaries = [[NSMutableArray alloc] init];

        // Process assets
        void (^assetEnumerator)(ALAsset *, NSUInteger, BOOL *) = ^(ALAsset *result, NSUInteger index, BOOL *stop) {
            if (result != nil) {
                if ([[result valueForProperty:ALAssetPropertyType] isEqualToString:ALAssetTypePhoto]) {
                    [assetURLDictionaries addObject:[result valueForProperty:ALAssetPropertyURLs]];
                    NSURL *url = result.defaultRepresentation.url;
                    [_assetLibrary assetForURL:url
                                   resultBlock:^(ALAsset *asset) {
                                       if (asset) {
                                           @synchronized(_assets) {
                                               [_assets addObject:asset];
                                               if (_assets.count == 1) {
                                                   // Added first asset so reload data
                                                   [self.tableView performSelectorOnMainThread:@selector(reloadData) withObject:nil waitUntilDone:NO];
                                               }
                                           }
                                       }
                                   }
                                  failureBlock:^(NSError *error){
                                      NSLog(@"operation was not successfull!");
                                  }];

                }
            }
        };

        // Process groups
        void (^ assetGroupEnumerator) (ALAssetsGroup *, BOOL *) = ^(ALAssetsGroup *group, BOOL *stop) {
            if (group != nil) {
                [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:assetEnumerator];
                [assetGroups addObject:group];
            }
        };

        // Process!
        [self.assetLibrary enumerateGroupsWithTypes:ALAssetsGroupAll
                                         usingBlock:assetGroupEnumerator
                                       failureBlock:^(NSError *error) {
                                           NSLog(@"There is an error");
                                       }];

    });
    
}
@end
