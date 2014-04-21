//
//  KGPhotoBrowserViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGPhotoBrowserViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>

@interface KGPhotoBrowserViewController () <MWPhotoBrowserDelegate>

@property(nonatomic, strong) NSMutableArray *imgUrls;
@property(nonatomic, assign) NSInteger currIndex;

@end

@implementation KGPhotoBrowserViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (id) initWithImgUrls: (NSMutableArray *)imgUrls index: (NSInteger) index {
    self = [super initWithDelegate:self];
    if (self) {
        self.imgUrls = imgUrls;
        self.currIndex = index;
        
        self.displayActionButton = NO;
        self.displayNavArrows = NO;
        self.displaySelectionButtons = NO;
        self.alwaysShowControls = NO;
        self.wantsFullScreenLayout = YES;
        self.zoomPhotosToFill = NO;
        self.enableGrid = NO;
        self.startOnGrid = NO;
        self.enableSwipeToDismiss = NO;
        self.alwaysShowControls = NO;
        self.delayToHideElements = -1;
        [self setCurrentPhotoIndex:index];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - MWPhotoBrowserDelegate

- (NSUInteger)numberOfPhotosInPhotoBrowser:(MWPhotoBrowser *)photoBrowser {
    return [self.imgUrls count];
}

- (id <MWPhoto>)photoBrowser:(MWPhotoBrowser *)photoBrowser photoAtIndex:(NSUInteger)index {
    if (index < [self.imgUrls count]) {
        NSURL *imgUrl = self.imgUrls[index];
        MWPhoto *mPhoto = [MWPhoto photoWithURL:imgUrl];
        return mPhoto;
    }
    return nil;
}

- (void)photoBrowser:(MWPhotoBrowser *)photoBrowser didDisplayPhotoAtIndex:(NSUInteger)index {
    NSLog(@"Did start viewing photo at index %lu", (unsigned long)index);
}

- (NSString *)photoBrowser:(MWPhotoBrowser *)photoBrowser titleForPhotoAtIndex:(NSUInteger)index {
    return @"";
}

- (void)photoBrowserDidFinishModalPresentation:(MWPhotoBrowser *)photoBrowser {
    NSLog(@"Did finish modal presentation");
    [self dismissViewControllerAnimated:YES completion:nil];
}


@end
