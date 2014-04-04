//
//  KGFilterBar.h
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGFilterBarDelegate <NSObject>

@required
- (void)didSelectFilter:(NSInteger)index item: (NSString *)item;

@end

@interface KGFilterBar : UIView

- (id)initWithFrame:(CGRect)frame items: (NSArray *) items;

- (void)closeCurrFilterView;

@property (nonatomic, weak) id<KGFilterBarDelegate> delegate;


@end
