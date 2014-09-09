//
//  KGCreateJourneyTableViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateJourneyController.h"
#import "KGJourneyAddImgTableViewCell.h"
#import "KGJourneyGoods.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import "MWPhotoBrowser.h"
#import "UIImage+Addtional.h"
#import "KGPhotoBrowserViewController.h"
#import "AFHTTPRequestOperationManager+Timeout.h"
#import "KGJourneyObject.h"

@interface KGCreateJourneyController () <UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UITextFieldDelegate, UITextViewDelegate, MWPhotoBrowserDelegate>

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, strong) KGJourneyObject *journeyObj;
@property (nonatomic, assign) NSInteger currTapCellIndex;
@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;
- (IBAction)publishJourney:(UIBarButtonItem *)sender;

- (IBAction)addGoods:(UIButton *)sender;

@end

@implementation KGCreateJourneyController

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
    [self setLeftBarbuttonItem];
    self.goodsArr = [[NSMutableArray alloc] init];
    self.journeyObj = [[KGJourneyObject alloc] init];
    self.currTapCellIndex = 0;

    [self loadAssets];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
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
            UITextField *tf = (UITextField *)[cell viewWithTag:1];
            tf.delegate = self;
            [tf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
            UISwitch *us = (UISwitch *)[cell viewWithTag:2];
            [us addTarget:self action:@selector(switchChanged:) forControlEvents:UIControlEventValueChanged];
        } else if (indexPath.row == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kSrcCityCell" forIndexPath:indexPath];
            UITextField *tf = (UITextField *)[cell viewWithTag:1];
            tf.delegate = self;
            [tf addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        } else if (indexPath.row == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kReturnTimeCell" forIndexPath:indexPath];
            UITextField *tf = (UITextField *)[cell viewWithTag:1];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
            datePicker.datePickerMode = UIDatePickerModeDate;
            tf.inputView = datePicker;

            UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectZero];
            [topView setBarStyle:UIBarStyleBlack];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerCancelClicked:)];
            cancelButton.tag = 1001;
            UIBarButtonItem *spaceButton = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDoneClicked:)];
            doneButton.tag = 1002;
            NSArray *buttonsArray = [NSArray arrayWithObjects:cancelButton,spaceButton,doneButton,nil];
            [topView setItems:buttonsArray];
            [topView sizeToFit];
            tf.inputAccessoryView = topView;
        } else {
            cell = [tableView dequeueReusableCellWithIdentifier:@"kStartTimeCell" forIndexPath:indexPath];
            UITextField *tf = (UITextField *)[cell viewWithTag:1];
            UIDatePicker *datePicker = [[UIDatePicker alloc] init];
            datePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
            datePicker.datePickerMode = UIDatePickerModeDate;
            tf.inputView = datePicker;

            UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectZero];
            [topView setBarStyle:UIBarStyleBlack];
            UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerCancelClicked:)];
            cancelButton.tag = 2001;
            UIBarButtonItem *spaceButton = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
            UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDoneClicked:)];
            doneButton.tag = 2002;
            NSArray *buttonsArray = [NSArray arrayWithObjects:cancelButton,spaceButton,doneButton,nil];
            [topView setItems:buttonsArray];
            [topView sizeToFit];
            tf.inputAccessoryView = topView;
        }
    } else if (indexPath.section == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kDetailCell" forIndexPath:indexPath];
        UITextView *tv = (UITextView *)[cell viewWithTag:1];
        tv.delegate = self;
    } else if (indexPath.section == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kAddPicturesCell" forIndexPath:indexPath];
    } else {
        cell = [tableView dequeueReusableCellWithIdentifier:@"kPicturesCell" forIndexPath:indexPath];
        KGJourneyAddImgTableViewCell *jCell = (KGJourneyAddImgTableViewCell *) cell;
        KGJourneyGoods *goods = self.goodsArr[indexPath.row];
        [jCell setupData:goods];
        jCell.imgNameTextField.delegate = self;
        [jCell.imgNameTextField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];

        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapPicture:)];
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
    /*
    if (![KGUtils isHigherIOS7]) {
        cell = (UITableViewCell *)tapGesture.view.superview.superview;
    }
    */
    NSIndexPath *tapPath = [self.tableView indexPathForCell:cell];
    self.currTapCellIndex = tapPath.row;
    NSLog(@"curr tap cell index: %d, image index: %d", self.currTapCellIndex, index);
    KGJourneyGoods *goods = self.goodsArr[self.currTapCellIndex];
    if (index >= 0 && index < goods.thumbs.count + 1) {
        if (index == goods.thumbs.count) {
            [self showActionSheet];
        } else {
            KGPhotoBrowserViewController *controller = [[KGPhotoBrowserViewController alloc]initWithImgUrls:goods.localImgUrls index:index];
            UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:controller];
            [self presentViewController:nc animated:YES completion:nil];
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
        browser.extendedLayoutIncludesOpaqueBars = YES;
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
            UIImage *thumb = [UIImage imageWithCGImage:asset.thumbnail];
            UIImage *oriImage = [UIImage imageWithCGImage:[asset.defaultRepresentation fullScreenImage]];
            [goods.thumbs addObject:thumb];
            [goods.localImgUrls addObject:asset.defaultRepresentation.url];
            [goods.imgArr addObject: oriImage];
        }
    }
    [self reloadCurrentEditRow];

}


#pragma UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *oriImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        KGJourneyGoods *goods = self.goodsArr[self.currTapCellIndex];
        if (!goods) {
            return;
        }
        UIImage *thumb = [UIImage scaleImage:oriImage toScale:0.1];
        [goods.thumbs addObject:thumb];
        [goods.imgArr addObject:oriImage];
        [self reloadCurrentEditRow];
        NSLog(@"%@",info);

        [self.assetLibrary writeImageToSavedPhotosAlbum:[oriImage CGImage] orientation:(ALAssetOrientation)[oriImage imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            if (error) {
                NSLog(@"error");
            } else {
                NSLog(@"url %@", assetURL);
                [goods.localImgUrls addObject:assetURL];
            }  
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:nil];
}



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


- (void)deleteGoods:(UIButton *) sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
//    if (![KGUtils isHigherIOS7]) {
//        cell = (UITableViewCell *)sender.superview.superview;
//    }
    NSIndexPath *tapPath = [self.tableView indexPathForCell:cell];
    [self.goodsArr removeObjectAtIndex:tapPath.row];
    [self reloadGoodsSection];
}

- (void)deleteImgFromGoods:(UIButton *) sender {
    KGJourneyPictureContainerView *view = (KGJourneyPictureContainerView *)sender.superview;
    self.currTapCellIndex = view.goodsIndex;
    NSLog(@"goodsIndex: %d, imgIndex: %d", view.goodsIndex, view.imgIndex);
    KGJourneyGoods *goods = self.goodsArr[view.goodsIndex];
    if (goods && goods.thumbs && view.imgIndex < goods.thumbs.count) {
        [goods.thumbs removeObjectAtIndex:view.imgIndex];
        [goods.localImgUrls removeObjectAtIndex:view.imgIndex];
        [goods.imgArr removeObjectAtIndex:view.imgIndex];
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

- (IBAction)publishJourney:(UIBarButtonItem *)sender {
    if (![self checkJourney]) {
        return;
    }
    self.navigationItem.rightBarButtonItem.enabled = NO;
    NSTimeInterval backTime = [self.journeyObj.backDate timeIntervalSince1970];
    NSTimeInterval startTime = [self.journeyObj.startDate timeIntervalSince1970];
    NSDictionary *basicParams = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"to_country": self.journeyObj.toCountry,
                             @"resident": @(self.journeyObj.permanent),
                             @"departure_city": self.journeyObj.fromCity,
                             @"back_time": @([[NSNumber numberWithDouble:backTime] longLongValue]),
                             @"start_time": @([[NSNumber numberWithDouble:startTime] longLongValue]),
                             @"description": self.journeyObj.desc,
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    NSMutableDictionary *params = [[NSMutableDictionary alloc] initWithDictionary:basicParams];
    for (NSInteger i = 0; i < self.goodsArr.count; i ++) {
        KGJourneyGoods *goods = self.goodsArr[i];
        [params setValue:goods.name forKey:[NSString stringWithFormat:@"good_name_%d", i + 1]];
    }
    [[HudHelper getInstance] showHudOnView:self.tableView caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [self uploadMultiPhotos:@"/mobile/travel/publish" params:params success:^(id responseObject) {
        [[HudHelper getInstance] hideHudInView:self.tableView];
        self.navigationItem.rightBarButtonItem.enabled = YES;
        DLog(@"%@",responseObject);
        if ([KGUtils checkResultWithAlert:responseObject]) {
            UIAlertView *alert = [[UIAlertView alloc]initWithTitle:@"提示" message:@"发布成功" delegate:self cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
            [alert show];
        }
    } failure:^(NSError *error) {
        DLog(@"error:%@",error);
        self.navigationItem.rightBarButtonItem.enabled = YES;
        [JDStatusBarNotification showWithStatus:kNetworkError dismissAfter:1.6    styleName:JDStatusBarStyleDark];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    [self.navigationController popToRootViewControllerAnimated:NO];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *rootViewController = (UITabBarController *)window.rootViewController;
    [rootViewController setSelectedIndex:0];
//    UINavigationController *navController = (UINavigationController *)(rootViewController.selectedViewController);
//
//    UIViewController *myTaskController = [self.storyboard instantiateViewControllerWithIdentifier:@"kMyTaskController"];
//    myTaskController.hidesBottomBarWhenPushed = YES;
//    [navController pushViewController:myTaskController animated:YES];
}

- (void)uploadMultiPhotos:(NSString *)path
                   params:(NSDictionary *)params
                  success:(ResponseBlock)success
                  failure:(FailureBlock)failure {
    AFHTTPRequestOperationManager *mgr = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:kWebServerBaseURL]];
    [mgr POST:path parameters:params constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *fileName = [formatter stringFromDate:[NSDate date]];

        for (NSInteger i = 0; i < self.goodsArr.count; i ++) {
            KGJourneyGoods *goods = self.goodsArr[i];
            NSString *iName = [NSString stringWithFormat:@"good_photos_%d", i + 1];
            for (NSInteger j = 0; j < goods.imgArr.count; j ++) {
                UIImage *goodsImage = goods.imgArr[j];
                [formData appendPartWithFileData:UIImageJPEGRepresentation(goodsImage, 0.5) name:iName fileName:[NSString stringWithFormat:@"%@-%d-%d.jpg",fileName,i+1, j+1] mimeType:@"image/jpeg"];
            }
        }
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if (success) {
            success(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        if (failure) {
            failure(error);
        }
    }];
}

- (void)textFieldChanged: (UITextField *)sender {
    UITableViewCell *cell = (UITableViewCell *)sender.superview.superview.superview;
//    if (![KGUtils isHigherIOS7]) {
//        cell = (UITableViewCell *)sender.superview.superview;
//    }
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    if (indexPath.section == 0) {
        switch (indexPath.row) {
            case 0:
                self.journeyObj.toCountry = sender.text;
                break;
            case 1:
                self.journeyObj.fromCity = sender.text;
                break;
            default:
                break;
        }
    } else if (indexPath.section == 3) {
        KGJourneyGoods *goods = self.goodsArr[indexPath.row];
        goods.name = sender.text;
    }
}

- (void)datePickerDoneClicked: (UIBarButtonItem *)sender {
    NSDateFormatter *formatter = [[NSDateFormatter alloc]init];
    formatter.dateFormat = @"yyyy/M/d";
    if (sender.tag == 1002) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        UIDatePicker *picker = (UIDatePicker *)tf.inputView;
        NSDate *backDate = picker.date;
        self.journeyObj.backDate = backDate;
        tf.text = [formatter stringFromDate:backDate];
        [tf resignFirstResponder];
    } else if (sender.tag == 2002) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        UIDatePicker *picker = (UIDatePicker *)tf.inputView;
        NSDate *startDate = picker.date;
        self.journeyObj.startDate = startDate;
        tf.text = [formatter stringFromDate:startDate];
        [tf resignFirstResponder];
    }
}

- (void)datePickerCancelClicked: (UIBarButtonItem *)sender {
    if (sender.tag == 1001) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:2 inSection:0]];
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        [tf resignFirstResponder];
    } else if (sender.tag == 2001) {
        UITableViewCell *cell = [self.tableView cellForRowAtIndexPath:[NSIndexPath indexPathForRow:3 inSection:0]];
        UITextField *tf = (UITextField *)[cell viewWithTag:1];
        [tf resignFirstResponder];
    }
}

-(void)switchChanged:(UISwitch *)sender {
    self.journeyObj.permanent = sender.isOn;
}

#pragma UITextViewDelegate

- (void)textViewDidChange:(UITextView *)textView {
    self.journeyObj.desc = textView.text;
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}

- (BOOL)checkJourney {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:nil delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if (![APPCONTEXT checkLogin]) {
        alert.message = @"请先登录";
        [alert show];
        return NO;
    }
    if (!self.journeyObj.toCountry || [@"" isEqualToString:self.journeyObj.toCountry]) {
        alert.message = @"去往国家不能为空";
        [alert show];
        return NO;
    }
    if (!self.journeyObj.permanent && (!self.journeyObj.fromCity || [@"" isEqualToString:self.journeyObj.fromCity])) {
        alert.message = @"出发城市不能为空";
        [alert show];
        return NO;
    }
    if (!self.journeyObj.backDate) {
        alert.message = @"回国时间不能为空";
        [alert show];
        return NO;
    }
    if (!self.journeyObj.startDate) {
        alert.message = @"出发时间不能为空";
        [alert show];
        return NO;
    }
    if (!self.journeyObj.desc || [@"" isEqualToString:self.journeyObj.desc]) {
        alert.message = @"描述不能为空";
        [alert show];
        return NO;
    }
    return YES;
}

@end
