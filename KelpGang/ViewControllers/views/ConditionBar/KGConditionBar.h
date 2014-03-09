//
//  KGConditionBar.h
//  KelpGang
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGConditionDelegate <NSObject>

@optional

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item;

@end

@interface KGConditionBar : UIView <UIGestureRecognizerDelegate>

@property (nonatomic, weak) UIView* canvasView;
@property (nonatomic, weak) id<KGConditionDelegate> delegate;

@end
