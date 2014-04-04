//
//  KGFilterItem.h
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGFilterView.h"

@protocol KGFilterItemDelegate <NSObject>

@required
- (void)didSelectFilterItem:(NSInteger)index item: (NSString *)item;

@end

@interface KGFilterItem : UIView

@property (nonatomic, weak) UIView* canvasView;
@property (nonatomic, assign) NSInteger index;
@property (nonatomic, assign) NSInteger type;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, strong) NSString *text;

@property (nonatomic, weak) id<KGFilterItemDelegate> delegate;

- (id)initWithFrame:(CGRect)frame text: (NSString *) text data: (NSArray *)data;
- (void)openFilterView;
- (void)closeFilterView;

@end
