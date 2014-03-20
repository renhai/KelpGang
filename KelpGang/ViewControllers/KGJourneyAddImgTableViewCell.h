//
//  KGJourneyAddImgTableViewCell.h
//  KelpGang
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KGJourneyPictureContainerView.h"


@class KGJourneyGoods;

@interface KGJourneyAddImgTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *imgNameTextField;

@property (weak, nonatomic) IBOutlet UIScrollView *imgScrollView;

@property (weak, nonatomic) IBOutlet UIButton *delGoodsBtn;

- (void)setupData: (KGJourneyGoods *) goods;


@end
