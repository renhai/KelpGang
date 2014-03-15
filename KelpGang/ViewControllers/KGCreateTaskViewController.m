//
//  KGCreateTaskViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateTaskViewController.h"
#import "MWPhotoBrowser.h"

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
@property (nonatomic, strong) NSMutableArray *pictures;

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
    self.pictures = [[NSMutableArray alloc] init];
    self.expectCountryTextField.delegate = self;
    self.maxMoneyTextField.delegate = self;

//    UILongPressGestureRecognizer *longPressReger = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(handleLongPress:)];
//    longPressReger.minimumPressDuration = 1.0;
//    [self.picCollectionView addGestureRecognizer:longPressReger];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
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
        [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationTop];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:pathArr.lastObject
                                  atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
        UIImage *image = [UIImage imageNamed:@"close-active"];
        imageView.image = image;
    } else {
        self.picExpanded = NO;
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
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
            controller.allowsEditing = NO;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
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
        [self.pictures addObject:oriImage];
        [self.picCollectionView reloadData];

//        NSIndexPath *path = [NSIndexPath indexPathForRow:1 inSection:2];
//        [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];

        [self.tableView reloadData];
//        [self.tableView reloadSections:[NSIndexSet indexSetWithIndex:2] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                              atScrollPosition:UITableViewScrollPositionBottom
                                      animated:YES];
        NSLog(@"%@",info);
    }];
}

//- (UIImageView *) buildImageView: (UIImage *) image {
//    UIImageView *view = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 94, 94)];
//    view.clipsToBounds = YES;
//    view.ContentMode = UIViewContentModeScaleAspectFill;
//    if (image) {
//        view.image = image;
//    }
//    return view;
//}

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
    if (self.pictures) {
        return [self.pictures count] + 1;
    } else {
        return 1;
    }

}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    UICollectionViewCell *cell = nil;
    NSInteger count = [self.pictures count];
    if (indexPath.row == count) {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kAddBtnCollectionViewCell" forIndexPath:indexPath];
    } else {
        cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"kPictureCollectionViewCell" forIndexPath:indexPath];
        UIImageView *imgView = (UIImageView *)[cell viewWithTag:1];
        [imgView.layer setBorderColor:RGBCOLOR(213, 232, 232).CGColor];
        [imgView.layer setBorderWidth:5];
        imgView.image = self.pictures[indexPath.row];

        UIButton *btn = (UIButton *)[cell viewWithTag:2];
        [btn addTarget:self action:@selector(delPicture:) forControlEvents:UIControlEventTouchUpInside];
    }
    return cell;

}

#pragma UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == self.pictures.count) {
        [self showActionSheet];
    } else {
        MWPhotoBrowser *browser = [[MWPhotoBrowser alloc] initWithDelegate:self];
        browser.displayActionButton = NO;
        browser.displayNavArrows = NO;
        browser.displaySelectionButtons = NO;
        browser.alwaysShowControls = NO;
        browser.wantsFullScreenLayout = YES;
        browser.zoomPhotosToFill = NO;
        browser.enableGrid = NO;
        browser.startOnGrid = NO;
        browser.enableSwipeToDismiss = NO;
        browser.alwaysShowControls = NO;
        browser.delayToHideElements = -1;
        [browser setCurrentPhotoIndex:indexPath.row];

//        [self.navigationController pushViewController:browser animated:YES];
        UINavigationController *nc = [[UINavigationController alloc] initWithRootViewController:browser];
        nc.modalTransitionStyle = UIModalTransitionStyleCoverVertical;
        [self presentViewController:nc animated:YES completion:nil];

    }

}


//- (void)handleLongPress:(UILongPressGestureRecognizer *)gestureRecognizer {
//    CGPoint point = [gestureRecognizer locationInView:self.picCollectionView];
//    if(gestureRecognizer.state == UIGestureRecognizerStateBegan) {
//
//    } else if(gestureRecognizer.state == UIGestureRecognizerStateEnded) {
//
//    }
//    else if(gestureRecognizer.state == UIGestureRecognizerStateChanged) {
//
//    }
//    NSIndexPath *indexPath = [self.picCollectionView indexPathForItemAtPoint:point];
//    NSLog(@"handleLongPress indexPath: %@", indexPath);
//    if (indexPath) {
//        UICollectionViewCell *cell = [self.picCollectionView cellForItemAtIndexPath:indexPath];
//        UIButton *btn = (UIButton *)[cell viewWithTag:2];
//        btn.hidden = NO;
//        btn.tag = indexPath.row;
//        [btn addTarget:self action:@selector(delPicture:) forControlEvents:UIControlEventTouchUpInside];
//    }
//
//}


#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.pictures count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.pictures count]) {
        UIImage *img = [self.pictures objectAtIndex:index];
        MWPhoto *mPhoto = [MWPhoto photoWithImage:img];
        return mPhoto;
    }
    return nil;
}

//- (MWCaptionView *)photoBrowser:(MWPhotoBrowser *)photoBrowser captionViewForPhotoAtIndex:(NSUInteger)index {
//    MWPhoto *photo = [self.photos objectAtIndex:index];
//    KGPicBottomView *captionView = [[KGPicBottomView alloc] initWithPhoto:photo index:index count:self.photos.count title:[NSString stringWithFormat:@"photo title - %i", index] chatBlock:^(UIButton *sender) {
//        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
//        KGChatViewController *chatViewController = (KGChatViewController *)[storyBoard instantiateViewControllerWithIdentifier:@"kChatViewController"];
//        [self.navigationController pushViewController:chatViewController animated:YES];
//        NSLog(@"do chat operation");
//    } collectBlock:^(UIButton *sender) {
//        NSLog(@"do collect operation");
//    }];
//    return captionView;
//}


- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return @"";
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    // If we subscribe to this method we must dismiss the view controller ourselves
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];


}

- (void) delPicture: (UIButton *) sender {
    UICollectionViewCell *cell = (UICollectionViewCell *)sender.superview.superview;
    NSIndexPath *path = [self.picCollectionView indexPathForCell:cell];
    [self delPictureAtIndex:path.row];
}

- (void) delPictureAtIndex: (NSInteger) index {
    [self.pictures removeObjectAtIndex:index];
    [self.picCollectionView reloadData];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:1 inSection:2]
                          atScrollPosition:UITableViewScrollPositionTop
                                  animated:YES];
}

@end
