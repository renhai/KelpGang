//
//  KGCompletedOrderBuyerCell.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCompletedOrderBuyerCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *buyerTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerValueLabel;

- (void)setBuyerName: (NSString *)value;

@end
