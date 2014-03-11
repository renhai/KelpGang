//
//  KGPicBottomView.h
//  KelpGang
//
//  Created by Andy on 14-3-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MWCaptionView.h"

@interface KGPicBottomView : MWCaptionView

@property (nonatomic, strong) UIView *bottomView;

- (id)initWithPhoto:(id<MWPhoto>)photo index: (NSInteger) index count: (NSInteger) count title: (NSString*) title;

@end
