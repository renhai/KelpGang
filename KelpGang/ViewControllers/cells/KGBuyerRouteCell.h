//
//  KGBuyerRouteCell.h
//  KelpGang
//
//  Created by Andy on 14-6-13.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGBuyerRouteCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *fromLabel;
@property (weak, nonatomic) IBOutlet UIImageView *airplaneLabel;
@property (weak, nonatomic) IBOutlet UILabel *toLabel;
@property (weak, nonatomic) IBOutlet UILabel *durationLabel;
@property (weak, nonatomic) IBOutlet UILabel *descLabel;

- (void)setRouteInfo: (NSDictionary *)info;

@end
