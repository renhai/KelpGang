//
//  KGFilterView.h
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
	KGFilterViewCommonStyle						= 0,
	KGFilterViewCascadeStyle                    = 1,
} KGFilterViewStyle;

@protocol KGFilterViewDelegate <NSObject>

@required
- (void)didSelectFilterViewCell:(NSString *)item;

@end

@interface KGFilterView : UIView

@property (nonatomic, weak) id<KGFilterViewDelegate> delegate;

@end
