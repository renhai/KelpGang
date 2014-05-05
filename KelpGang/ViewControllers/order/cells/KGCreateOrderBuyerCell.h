//
//  KGCreateOrderBuyerCell.h
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCreateOrderBuyerCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *buyerNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *buyerValueLabel;

- (void)setObject:(NSString *)buyerName;

@end
