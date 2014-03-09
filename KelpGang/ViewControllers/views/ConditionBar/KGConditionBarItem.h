//
//  KGConditionBarItem.h
//  KelpGang
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGConditionBarItem : UIView
@property (weak, nonatomic) IBOutlet UILabel *textLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImgView;
@property (weak, nonatomic) IBOutlet UIImageView *indImgView;

@property(nonatomic, assign) NSInteger index;

- (void)relayout;
- (void)openItem;
- (void)closeItem;

@end
