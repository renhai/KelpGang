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

@interface KGCreateJourneyTableViewController () <SwipeViewDataSource, SwipeViewDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) NSMutableArray *goodsArr;
@property (nonatomic, assign) BOOL picExpanded;
@property (nonatomic, assign) NSInteger currEditIndex;
@property (nonatomic, strong) SwipeView *currEditSwipeView;


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
    self.currEditIndex = 0;
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
        if (self.picExpanded) {
            return self.goodsArr.count;
        } else {
            return 0;
        }
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
//        KGJourneyGoods *goods = self.goodsArr[indexPath.row];
//        [jCell.imgSwipView reloadData];
        self.currEditIndex = indexPath.row;
        jCell.imgSwipView.delegate = self;
        jCell.imgSwipView.dataSource = self;
    }

    return cell;
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 0) {
        return 44.0;
    } else if (indexPath.section == 1) {
        return 65.0;
    } else if (indexPath.section == 2){
        return 44.0;
    } else {
        return 160.0;
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
//    UITableViewCell *cell = [self tableView:tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == 2 && indexPath.row == 0) {
        [self expandPictureView:nil];
    }
}

- (void)expandPictureView:(UIImageView *)imageView {
    NSMutableArray *pathArr = [[NSMutableArray alloc] init];
    if (self.goodsArr.count == 0) {
        [pathArr addObject:[NSIndexPath indexPathForRow:0 inSection:3]];
    } else {
        for (NSInteger i = 0; i < self.goodsArr.count; i ++) {
            [pathArr addObject:[NSIndexPath indexPathForRow:i inSection:3]];
        }
    }
    if (!self.picExpanded) {
        if (self.goodsArr.count == 0) {
            KGJourneyGoods *goods = [[KGJourneyGoods alloc] init];
            [self.goodsArr addObject:goods];
        }
        self.picExpanded = YES;
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:pathArr.lastObject
                              atScrollPosition:UITableViewScrollPositionTop
                                      animated:YES];
//        UIImage *image = [UIImage imageNamed:@"close-active"];
//        imageView.image = image;

        UIView *footerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 30)];
        footerView.backgroundColor = [UIColor redColor];
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(test:)];
        [footerView addGestureRecognizer:gesture];
        self.tableView.tableFooterView = footerView;
    } else {
        self.picExpanded = NO;
//        for (NSIndexPath *path in pathArr) {
//            [self.goodsArr removeObjectAtIndex:path.row];
//        }
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:pathArr withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
//        UIImage *image = [UIImage imageNamed:@"add-active"];
//        imageView.image = image;
        self.tableView.tableFooterView = nil;

    }
}

- (void) test:(UIGestureRecognizer *) gesture {
    NSLog(@"test");
    KGJourneyGoods *one = [[KGJourneyGoods alloc] init];
    [self.goodsArr addObject:one];
//    NSIndexPath *path = [NSIndexPath indexPathForRow:self.goodsArr.count - 1 inSection:3];
    [self.tableView reloadData];
//    [self.tableView reloadRowsAtIndexPaths:@[path] withRowAnimation:UITableViewRowAnimationNone];
}

#pragma SwipViewDataSource
- (NSInteger)numberOfItemsInSwipeView:(SwipeView *)swipeView
{
    KGJourneyGoods *goodsObj = self.goodsArr[self.currEditIndex];
    if (goodsObj && goodsObj.pictures.count > 0) {
        return [goodsObj.pictures count] + 1;
    } else {
        return 1;
    }
}

- (UIView *)swipeView:(SwipeView *)swipeView viewForItemAtIndex:(NSInteger)index reusingView:(UIView *)view
{
    KGJourneyGoods *goodsObj = self.goodsArr[self.currEditIndex];
    if (!goodsObj) {
        return  nil;
    }
    UIView *containerView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 109, 94)];
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 0, 94, 94)];
    [imageView setContentMode:UIViewContentModeScaleAspectFill];
    [imageView setClipsToBounds:YES];
    if (index == goodsObj.pictures.count) {
        [imageView setImage:[UIImage imageNamed:@"add_img"]];
    } else {
        [imageView setImage:[goodsObj.pictures objectAtIndex:index]];
    }
    [containerView addSubview:imageView];

    view = containerView;
    return view;
}

#pragma SwipeViewDelegate
- (void)swipeView:(SwipeView *)swipeView didSelectItemAtIndex:(NSInteger)index {
    NSLog(@"selelect index is : %d", index);
    KGJourneyAddImgTableViewCell *cell = (KGJourneyAddImgTableViewCell *)swipeView.superview.superview.superview;
    NSIndexPath *path = [self.tableView indexPathForCell:cell];
    self.currEditIndex = path.row;
    self.currEditSwipeView = swipeView;
    KGJourneyGoods *goods = self.goodsArr[path.row];
    if (!goods) {
        return;
    }
    NSMutableArray *pictures = goods.pictures;
    if (index == pictures.count) {
        [self showActionSheet];
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


#pragma UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *oriImage = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        KGJourneyGoods *goods = self.goodsArr[self.currEditIndex];
        if (!goods) {
            return;
        }
        [goods.pictures addObject:oriImage];
        [self.currEditSwipeView reloadData];


        NSLog(@"%@",info);
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

@end
