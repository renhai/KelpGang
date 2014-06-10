//
//  KGFilterItem.h
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGFilterView.h"

typedef void(^SelectDoneBlock)(NSInteger, NSString *);

@interface KGFilterItem : UIControl

@property (nonatomic, weak) UIView* canvasView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *url;
@property (nonatomic, copy) SelectDoneBlock selectDoneBlock;

- (id)initWithFrame:(CGRect)frame text: (NSString *) text data: (NSArray *)data;
- (void)openFilterView;
- (void)closeFilterView;

@end
