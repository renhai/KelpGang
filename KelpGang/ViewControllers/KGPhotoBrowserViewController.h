//
//  KGPhotoBrowserViewController.h
//  KelpGang
//
//  Created by Andy on 14-3-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MWPhotoBrowser.h"

@interface KGPhotoBrowserViewController : MWPhotoBrowser

- (id) initWithImgUrls: (NSArray *)imgUrls index: (NSInteger) index;

@end
