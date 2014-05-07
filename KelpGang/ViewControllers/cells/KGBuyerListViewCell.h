//
//  KGFindKelpViewCell.h
//  KelpGang
//
//  Created by Andy on 14-2-27.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGBuyerSummaryObject;

@interface KGBuyerListViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headImageView;
@property (weak, nonatomic) IBOutlet UILabel *fromCityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *planeImgView;
@property (weak, nonatomic) IBOutlet UILabel *toCityLabel;
@property (weak, nonatomic) IBOutlet UIImageView *countryImgView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UIView *levelView;

- (void)setObject: (KGBuyerSummaryObject *)obj;


@end
