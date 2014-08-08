//
//  KGDiscoverDetailCell.h
//  KelpGang
//
//  Created by Andy on 14-8-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGDiscoverDetailCell : UICollectionViewCell

@property (nonatomic, strong) UIImageView *headImageView;
@property (nonatomic, strong) UILabel *nameLabel;

- (void)setObject: (id)info;

@end
