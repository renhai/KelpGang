//
//  KGFilterBar.m
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGFilterBar.h"
#import "KGFilterItem.h"

@interface KGFilterBar() <KGFilterItemDelegate>

@property (nonatomic, assign) NSInteger currTapIndex;

@end

@implementation KGFilterBar

- (void)dealloc {
    NSLog(@"KGFilterBar dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items: (NSArray *) items {
    self = [self initWithFrame:frame];
    if (self) {
        self.currTapIndex = -1;
        UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(0, frame.size.height - LINE_HEIGHT, SCREEN_WIDTH, LINE_HEIGHT)];
        [self addSubview:bottomLine];
        for (KGFilterItem *item in items) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
            [item addGestureRecognizer:tapGesture];
            item.delegate = self;
            [self addSubview:item];
        }
    }
    return self;
}

- (void)didTap: (UIGestureRecognizer *)gestureRecognizer {
    KGFilterItem *item = (KGFilterItem *)gestureRecognizer.view;
    if (item.data && item.data.count > 0) {
        if (self.currTapIndex == -1) {
            [self openItem:item];
        } else if (self.currTapIndex == item.index) {
            [self closeItem:item];
        } else {
            [self closeItemByIndex:self.currTapIndex];
            [self openItem:item];
        }
    } else {
        [self.delegate didSelectFilter:item.index item:item.text];
    }
}

- (void)didSelectFilterItem:(NSInteger)index item: (NSString *)item {
    [self closeItemByIndex:self.currTapIndex];
    [self.delegate didSelectFilter:index item:item];
}

- (void)closeItemByIndex:(NSInteger) index {
    for (UIView *view in self.subviews) {
        if ([view isKindOfClass:[KGFilterItem class]]) {
            KGFilterItem *fItem = (KGFilterItem *)view;
            if (fItem.index == index) {
                [self closeItem:fItem];
                break;
            }
        }
    }
}

- (void)closeItem:(KGFilterItem *) item {
    self.currTapIndex = -1;
    [item closeFilterView];
}

- (void)openItem:(KGFilterItem *) item {
    self.currTapIndex = item.index;
    [item openFilterView];
}

- (void)closeCurrFilterView {
    [self closeItemByIndex:self.currTapIndex];
}


@end
