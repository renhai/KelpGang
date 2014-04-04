//
//  KGFilterItem.h
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGFilterView.h"

@interface KGFilterItem : UIView

@property (nonatomic, weak) UIView* canvasView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *data;

- (id)initWithFrame:(CGRect)frame text: (NSString *) text;
- (void)openFilterView;
- (void)closeFilterView;

@end
