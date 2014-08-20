//
//  KGMyJourneyCell.h
//  KelpGang
//
//  Created by Andy on 14-8-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGJourneyObject;

@interface KGMyJourneyCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *journeyImgView;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;
@property (weak, nonatomic) IBOutlet UILabel *toCountryLabel;
@property (weak, nonatomic) IBOutlet UILabel *deadlineLabel;
@property (weak, nonatomic) IBOutlet UILabel *statusLabel;

-(void)setObject: (KGJourneyObject *)obj;

@end
