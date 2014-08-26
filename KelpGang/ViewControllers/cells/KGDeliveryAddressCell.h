//
//  KGDeliveryAddressCell.h
//  KelpGang
//
//  Created by Andy on 14-4-24.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "SWTableViewCell.h"

@class KGAddressObject;

@interface KGDeliveryAddressCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *districtLabel;
@property (weak, nonatomic) IBOutlet UILabel *detailAddrLabel;
@property (weak, nonatomic) IBOutlet UIImageView *defaultAddrImageView;

- (void)setObject: (KGAddressObject *)addrObj;

@end
