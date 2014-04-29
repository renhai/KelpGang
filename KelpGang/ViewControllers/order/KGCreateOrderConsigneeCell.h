//
//  KGCreateOrderConsigneeCell.h
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@class KGAddressObject;

@interface KGCreateOrderConsigneeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *consigneeNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *consigneeValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *addrValueLabel;
@property (weak, nonatomic) IBOutlet UILabel *mobileLabel;
@property (weak, nonatomic) IBOutlet UIImageView *arrowImageView;


- (void)setObject:(KGAddressObject *)addrObj;


@end
