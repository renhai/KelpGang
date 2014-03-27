//
//  KGCreateTaskViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateTaskViewController.h"
#import "MWPhotoBrowser.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "UIImage+Addtional.h"
#import "KGPhotoBrowserViewController.h"


@interface KGCreateTaskViewController () <UITextFieldDelegate, UIPickerViewDelegate, UIPickerViewDataSource, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *commionTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextField *deadlineTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *expectCountryTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxMoneyTextField;

@property (nonatomic, strong) UIPickerView *commionPickerView;
@property (nonatomic, strong) UIDatePicker *deadlinePicker;

@property (nonatomic, assign) BOOL picExpanded;
@property (nonatomic, assign) BOOL moreInfoExpanded;
@property (nonatomic, strong) NSMutableArray *imgThumbs;
@property (nonatomic, strong) NSMutableArray *imgUrls;

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;

@end

@implementation KGCreateTaskViewController

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
    self.titleTextField.delegate = self;
    self.commionTextField.delegate = self;
    self.deadlineTextField.delegate = self;
    self.descTextView.delegate = self;
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    self.imgThumbs = [[NSMutableArray alloc] init];
    self.imgUrls = [[NSMutableArray alloc] init];
    self.expectCountryTextField.delegate = self;
    self.maxMoneyTextField.delegate = self;

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
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 && !self.picExpanded) {
        return 1;
    } else if (section == 3 && !self.moreInfoExpanded) {
        return 1;
    }
    return [super tableView:tableView numberOfRowsInSection:section];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
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

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 1) {
        NSInteger height = self.picCollectionView.collectionViewLayout.collectionViewContentSize.height;
        NSLog(@"collectionViewContentSize.height :%d", height);
        return height;
    }
    return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    return cell;
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

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [self expandPictureView:imageView];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [self expandMoreInfoView:imageView];
    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    if (textField == self.titleTextField) {
        [textField resignFirstResponder];
    } else if (textField == self.expectCountryTextField) {
        [textField resignFirstResponder];
    } else if (textField == self.maxMoneyTextField) {
        [textField resignFirstResponder];
    }
    return YES;
}

- (void)textFieldDidBeginEditing:(UITextField *)textField {
    if (textField == self.commionTextField) {
        UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
        [pickerView sizeToFit];
        pickerView.showsSelectionIndicator = YES;
        pickerView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
        pickerView.delegate = self;
        pickerView.dataSource = self;
        textField.inputView = pickerView;
        self.commionPickerView = pickerView;
        [self.commionPickerView selectRow:9 inComponent:0 animated:YES];

        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleBlack;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(pickerDoneClicked:)];
        UIBarButtonItem *cancelButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(pickerCancelClicked:)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, fixedButton, doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    } else if (textField == self.deadlineTextField) {
        UIDatePicker *datepicker = [[UIDatePicker alloc] initWithFrame:CGRectZero];
        datepicker.datePickerMode = UIDatePickerModeDate;
        datepicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
        textField.inputView = datepicker;
        self.deadlinePicker = datepicker;

        UIToolbar* keyboardDoneButtonView = [[UIToolbar alloc] init];
        keyboardDoneButtonView.barStyle = UIBarStyleBlack;
        keyboardDoneButtonView.translucent = YES;
        keyboardDoneButtonView.tintColor = nil;
        [keyboardDoneButtonView sizeToFit];
        UIBarButtonItem* doneButton = [[UIBarButtonItem alloc] initWithTitle:@"完成" style:UIBarButtonItemStyleBordered target:self action:@selector(datePickerDoneClicked:)];
        UIBarButtonItem *cancelButton  = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleBordered target: self action: @selector(datePickerCancelClicked:)];
        UIBarButtonItem *fixedButton  = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target: nil action: nil];
        [keyboardDoneButtonView setItems:[NSArray arrayWithObjects:cancelButton, fixedButton, doneButton, nil]];
        textField.inputAccessoryView = keyboardDoneButtonView;
    }
}

#pragma UIPickerViewDataSource

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return 100;
}

#pragma UIPickerViewDelegate

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    return [NSString stringWithFormat:@"%d%@",row + 1, @"%"];
}

- (void) pickerDoneClicked:(UIBarButtonItem *) btn
{
    NSInteger approw = [self.commionPickerView selectedRowInComponent:0];
    self.commionTextField.text = [NSString stringWithFormat:@"%d%@", approw + 1, @"%"];
    [self.commionTextField resignFirstResponder];
}

- (void) pickerCancelClicked:(UIBarButtonItem *) btn
{
    [self.commionTextField resignFirstResponder];
}

- (void) datePickerDoneClicked:(UIBarButtonItem *) btn
{
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"YYYY/M/d";
    NSString *timestamp = [formattor stringFromDate:self.deadlinePicker.date];
    self.deadlineTextField.text = timestamp;
    [self.deadlineTextField resignFirstResponder];
}

- (void) datePickerCancelClicked:(UIBarButtonItem *) btn
{
    [self.deadlineTextField resignFirstResponder];
}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)expandPictureView:(UIImageView *)imageView {
    NSArray *pathArr = @[[NSIndexPath indexPathForRow:1 inSection:2]];
    if (!self.picExpanded) {
        self.picExpanded = YES;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:pathArr.lastObject
                                  atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        UIImage *image = [UIImage imageNamed:@"close-active"];
        imageView.image = image;
    } else {
        self.picExpanded = NO;
        [self.imgThumbs removeAllObjects];
        [self.imgUrls removeAllObjects];
        [self.picCollectionView reloadData];
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        UIImage *image = [UIImage imageNamed:@"add-active"];
        imageView.image = image;
    }
}

- (void)expandMoreInfoView:(UIImageView *)imageView {
    NSArray *pathArr = @[[NSIndexPath indexPathForRow:1 inSection:3], [NSIndexPath indexPathForRow:2 inSection:3]];
    if (!self.moreInfoExpanded) {
        self.moreInfoExpanded = YES;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:pathArr.lastObject
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        UIImage *image = [UIImage imageNamed:@"up-arrow-big"];
        imageView.image = image;
    } else {
        self.moreInfoExpanded = NO;
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        UIImage *image = [UIImage imageNamed:@"down-arrow-big"];
        imageView.image = image;
    }
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

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}


#pragma UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *oriImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        UIImage *thumb = [UIImage scaleImage:oriImage toScale:0.1];
        [self.imgThumbs addObject:thumb];
        [self.picCollectionView reloadData];
        [self.tableView reloadData];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];

        [self.assetLibrary writeImageToSavedPhotosAlbum:[oriImage CGImage] orientation:(ALAssetOrientation)[oriImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                NSLog(@"url %@", assetURL);
                [self.imgUrls addObject:assetURL];
            }
        }];

        NSLog(@"%@",info);
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
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


#pragma UICollectionViewDataSource

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (self.imgThumbs) {
        return [self.imgThumbs count] + 1;
    } else {
        return 1;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    NSInteger count = [self.imgThumbs count];
    if (indexPath.row == count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kAddBtnCollectionViewCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPictureCollectionViewCell" forIndexPath:indexPath];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        [imgView.layer setBorderColor:RGBCOLOR(213, 232, 232).CGColor];
        [imgView.layer setBorderWidth:3];
        imgView.image = self.imgThumbs[indexPath.row];

        UIButton *btn = (UIButton *)[cell viewWithTag:2];
        [btn addTarget:self action:@selector(delPicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;

}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.imgThumbs.count) {
        [self showActionSheet];
    } else {
        KGPhotoBrowserViewController *controller = [[KGPhotoBrowserViewController alloc] initWithImgUrls:self.imgUrls index:indexPath.row];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
        [self presentViewController:nc animated:YES completion:nil];

//        [self.navigationController pushViewController:controller animated:YES];

    }

}

- (void) delPicture: (UIButton *) sender {
    UICollectionViewCell *cell = (UICollectionViewCell *)sender.superview.superview;
    NSIndexPath *path = [self.picCollectionView indexPathForCell:cell];
    [self delPictureAtIndex:path.row];
}

- (void) delPictureAtIndex: (NSInteger) index {
    [self.imgThumbs removeObjectAtIndex:index];
    [self.imgUrls removeObjectAtIndex:index];
    [self.picCollectionView reloadData];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
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

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (BOOL)photoBrowser:(MWPhotoBrowser *)photoBrowser isPhotoSelectedAtIndex:(NSUInteger)index {
    return [[_selections objectAtIndex:index] boolValue];
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index selectedChanged:(BOOL)selected {
    [_selections replaceObjectAtIndex:index withObject:[NSNumber numberWithBool:selected]];
    NSLog(@"Photo at index %lu selected %@", (unsigned long)index, selected ? @"YES" : @"NO");
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];

    for (NSInteger i = 0; i < self.selections.count; i ++) {
        if ([self.selections[i] boolValue]) {
            ALAsset *asset = self.assets[i];
            UIImage *thumb = [UIImage imageWithCGImage:asset.thumbnail];
            [self.imgThumbs addObject:thumb];
            [self.imgUrls addObject:asset.defaultRepresentation.url];
        }
    }
    [self.picCollectionView reloadData];

    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}



@end
