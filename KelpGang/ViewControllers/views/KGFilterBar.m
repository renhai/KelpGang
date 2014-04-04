//
//  KGFilterBar.m
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGFilterBar.h"
#import "KGFilterItem.h"

@interface KGFilterBar()

@property (nonatomic, assign) NSInteger currTapIndex;

@end

@implementation KGFilterBar

- (void)dealloc {
    NSLog(@"KGFilterBar dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(selectFilterViewCell:) name:kSelectFilterViewCell object:nil];
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame items: (NSArray *) items {
    self = [self initWithFrame:frame];
    if (self) {
        self.currTapIndex = -1;
        for (KGFilterItem *item in items) {
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
            [item addGestureRecognizer:tapGesture];
            [self addSubview:item];
        }
    }
    return self;
}

- (void)didTap: (UIGestureRecognizer *)gestureRecognizer {
    KGFilterItem *item = (KGFilterItem *)gestureRecognizer.view;
    if (self.currTapIndex == -1) {
        [self openItem:item];
    } else if (self.currTapIndex == item.index) {
        [self closeItem:item];
    } else {
        [self closeItemByIndex:self.currTapIndex];
        [self openItem:item];
    }
}

- (void)selectFilterViewCell:(NSNotification*)notification {
    NSDictionary *dict = notification.object;
    NSInteger index = [dict[@"index"] integerValue];
    NSString *item = dict[@"item"];

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
