//
//  KGMyCollectViewCell.h
//  KelpGang
//
//  Created by Andy on 14-8-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SWTableViewCell.h"

@class KGCollectObject;

@interface KGMyCollectViewCell : SWTableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *goodsImageView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotLabel;
@property (weak, nonatomic) IBOutlet UILabel *hotValueLabel;

- (void)setObject:(KGCollectObject *)obj;

@end
