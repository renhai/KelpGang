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
#import "KGTaskViewController.h"
#import "KGTaskObject.h"


@interface KGCreateTaskViewController () <UITextFieldDelegate, UITextViewDelegate, UIActionSheetDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, MWPhotoBrowserDelegate>
@property (weak, nonatomic) IBOutlet UITextField *commionTextField;
@property (weak, nonatomic) IBOutlet UITextField *titleTextField;
@property (weak, nonatomic) IBOutlet UITextView *descTextView;
@property (weak, nonatomic) IBOutlet UICollectionView *picCollectionView;
@property (weak, nonatomic) IBOutlet UITextField *expectCountryTextField;
@property (weak, nonatomic) IBOutlet UITextField *maxMoneyTextField;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *previewBarBtn;
@property (weak, nonatomic) IBOutlet UITextField *deadlineTextField;
@property (strong, nonatomic) UIDatePicker *deadlinePicker;

@property (nonatomic, assign) BOOL picExpanded;
@property (nonatomic, assign) BOOL moreInfoExpanded;

@property (nonatomic, strong) NSMutableArray *imgThumbs;
@property (nonatomic, strong) NSMutableArray *imgUrls;
@property (nonatomic, strong) NSMutableArray *imgOrigins;

@property (nonatomic, strong) ALAssetsLibrary *assetLibrary;
@property (nonatomic, strong) NSMutableArray *assets;
@property (nonatomic, strong) NSMutableArray *photos;
@property (nonatomic, strong) NSMutableArray *thumbs;
@property (nonatomic, strong) NSMutableArray *selections;

@end

@implementation KGCreateTaskViewController

- (void)dealloc {
    NSLog(@"KGCreateTaskViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(clearData:) name:kPublishTask object:nil];

    self.titleTextField.delegate = self;
    self.commionTextField.delegate = self;
    self.descTextView.delegate = self;
    self.picCollectionView.delegate = self;
    self.picCollectionView.dataSource = self;
    self.imgThumbs = [[NSMutableArray alloc] init];
    self.imgUrls = [[NSMutableArray alloc] init];
    self.imgOrigins = [[NSMutableArray alloc] init];
    self.expectCountryTextField.delegate = self;
    self.maxMoneyTextField.delegate = self;

    [self initDatePicker];

    [self.previewBarBtn setTarget:self];
    [self.previewBarBtn setAction:@selector(previewAction:)];

    [self loadAssets];

    self.titleTextField.text = @"";
    self.commionTextField.text = @"";
    self.descTextView.text = @"";
}

- (void)initDatePicker {
    self.deadlinePicker = [[UIDatePicker alloc] init];
    self.deadlinePicker.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"Chinese"];
    self.deadlinePicker.datePickerMode = UIDatePickerModeDate;
    self.deadlineTextField.inputView = self.deadlinePicker;

    UIToolbar *topView = [[UIToolbar alloc]initWithFrame:CGRectZero];
    [topView setBarStyle:UIBarStyleBlack];
    UIBarButtonItem *cancelButton = [[UIBarButtonItem alloc]initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerCancelClicked:)];
    UIBarButtonItem *spaceButton = [[UIBarButtonItem  alloc]initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:self action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc]initWithTitle:@"完成" style:UIBarButtonItemStyleDone target:self action:@selector(datePickerDoneClicked:)];
    NSArray *buttonsArray = [NSArray arrayWithObjects:cancelButton,spaceButton,doneButton,nil];
    [topView setItems:buttonsArray];
    [topView sizeToFit];
    self.deadlineTextField.inputAccessoryView = topView;
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
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
    return [super numberOfSectionsInTableView:tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 2 && !self.picExpanded) {
        return 1;
    } else if (section == 3 && !self.moreInfoExpanded) {
        return 1;
    } else if (section == 0) {
        return 4;
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
    sectionHeaderView.backgroundColor = CLEARCOLOR;
    return sectionHeaderView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 2 && indexPath.row == 1) {
//        NSInteger height = self.picCollectionView.collectionViewLayout.collectionViewContentSize.height;
//        NSLog(@"collectionViewContentSize.height :%d", height);
//        return height;
        return 120.0;
    }
    return [super tableView:self.tableView heightForRowAtIndexPath:indexPath];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [super tableView:self.tableView cellForRowAtIndexPath:indexPath];
    return cell;
}


#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [self expandPictureView:imageView];
    } else if (indexPath.section == 3 && indexPath.row == 0) {
        UIImageView *imageView = (UIImageView *)[cell viewWithTag:1];
        [self expandMoreInfoView:imageView];
    } else if (indexPath.section == 0 && indexPath.row == 3) {

    }
}

#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    if (textField == self.titleTextField) {

    } else if (textField == self.expectCountryTextField) {

    } else if (textField == self.maxMoneyTextField) {

    } else if (textField == self.commionTextField) {

    }
    return YES;
}

- (void)datePickerCancelClicked:(UIBarButtonItem *) sender {
    [self.deadlineTextField resignFirstResponder];
}

- (void)datePickerDoneClicked:(UIBarButtonItem *) sender {
    [self.deadlineTextField resignFirstResponder];
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"YYYY/M/d";
    NSString *timestamp = [formattor stringFromDate:self.deadlinePicker.date];
    self.deadlineTextField.text = timestamp;
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
        [self.imgOrigins removeAllObjects];
        _selections = nil;

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

        if (!_selections) {
            _selections = [NSMutableArray new];
            for (int i = 0; i < photos.count; i++) {
                [_selections addObject:[NSNumber numberWithBool:NO]];
            }
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
        [self.imgOrigins addObject:oriImage];
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
    [self.imgOrigins removeObjectAtIndex:index];
    [self.picCollectionView reloadData];
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

    [self.imgThumbs removeAllObjects];
    [self.imgUrls removeAllObjects];
    [self.imgOrigins removeAllObjects];
    for (NSInteger i = 0; i < self.selections.count; i ++) {
        if ([self.selections[i] boolValue]) {
            ALAsset *asset = self.assets[i];
            UIImage *thumb = [UIImage imageWithCGImage:asset.thumbnail];
            UIImage *originImage = [UIImage imageWithCGImage:asset.defaultRepresentation.fullScreenImage];
            [self.imgThumbs addObject:thumb];
            [self.imgUrls addObject:asset.defaultRepresentation.url];
            [self.imgOrigins addObject:originImage];
        }
    }
    [self.picCollectionView reloadData];

    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                          atScrollPosition:UITableViewScrollPositionBottom
                                  animated:YES];
}

- (void)previewAction: (UIBarButtonItem *) btn {
    if (![self checkTask]) {
        return;
    }
    KGTaskObject *req = [[KGTaskObject alloc] init];
    req.title = self.titleTextField.text;
    req.gratuity = [self.commionTextField.text floatValue];
    req.deadline = self.deadlinePicker.date;
    req.message = self.descTextView.text;
    req.expectCountry = self.expectCountryTextField.text;
    req.maxMoney = [self.maxMoneyTextField.text floatValue];
    req.imageArr = self.imgOrigins;

    KGTaskViewController *taskController = [self.storyboard instantiateViewControllerWithIdentifier:@"kTaskTableViewController"];
    taskController.taskObj = req;
    [taskController setHidesBottomBarWhenPushed:YES];
    [self.navigationController pushViewController:taskController animated:YES];
}

- (BOOL)checkTask {
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
    if ([self.titleTextField.text isEqualToString:@""]) {
        alert.message = @"任务标题不能为空";
        [alert show];
        return NO;
    }
    if ([self.commionTextField.text isEqualToString:@""]) {
        alert.message = @"跑腿费比例不能为空";
        [alert show];
        return NO;
    }
    if ([self.deadlineTextField.text isEqualToString:@""]) {
        alert.message = @"失效时间不能为空";
        [alert show];
        return NO;
    }
    if ([self.descTextView.text isEqualToString:@""]) {
        alert.message = @"任务描述不能为空";
        [alert show];
        return NO;
    }
    if (!self.imgThumbs || [self.imgThumbs count] == 0) {
        alert.message = @"参考图片不能为空";
        [alert show];
        return NO;
    }
    return YES;
}

- (void)clearData:(NSNotification *) notification{
    [self.imgUrls removeAllObjects];
    [self.imgThumbs removeAllObjects];
    [self.imgOrigins removeAllObjects];
    [self.picCollectionView reloadData];
    self.titleTextField.text = @"";
    self.commionTextField.text = @"";
    self.deadlineTextField.text = @"";
    self.descTextView.text = @"";
    self.expectCountryTextField.text = @"";
    self.maxMoneyTextField.text = @"";
    [self.tableView reloadData];
}


@end
