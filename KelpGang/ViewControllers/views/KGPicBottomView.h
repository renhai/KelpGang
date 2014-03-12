//
//  KGPicBottomView.h
//  KelpGang
//
//  Created by Andy on 14-3-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "MWCaptionView.h"
typedef void (^ChatBlock)(UIButton * sender);
typedef void (^CollectBlock)(UIButton * sender);

@interface KGPicBottomView : MWCaptionView

@property (nonatomic, strong) UIView *bottomView;
@property (nonatomic, copy) ChatBlock chatBlock;
@property (nonatomic, copy) CollectBlock collectBlock;

- (id)initWithPhoto:(id<MWPhoto>)photo index: (NSInteger) index count: (NSInteger) count title: (NSString*) title chatBlock: (ChatBlock) chatBlock collectBlock: (CollectBlock) collectBlock;

@end
