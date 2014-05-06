//
//  KGCompletedOrderInfoCell.h
//  KelpGang
//
//  Created by Andy on 14-5-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCompletedOrderInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *orderNumberTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderNumberValue;
@property (weak, nonatomic) IBOutlet UILabel *orderDateTitle;
@property (weak, nonatomic) IBOutlet UILabel *orderDateValue;

-(void)setOrderNumber: (NSString *)number date: (NSDate *)date;

@end
