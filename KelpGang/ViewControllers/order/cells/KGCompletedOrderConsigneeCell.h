//
//  KGCompletedOrderConsigneeCell.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGAddressObject;

@interface KGCompletedOrderConsigneeCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *consigneeTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrTitleLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrValueLabel;

- (void)setObject:(KGAddressObject *)addrObj;

@end
