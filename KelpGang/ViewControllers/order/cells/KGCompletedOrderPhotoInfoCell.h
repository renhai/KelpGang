//
//  KGCompletedOrderPhotoInfoCell.h
//  KelpGang
//
//  Created by Andy on 14-5-6.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGCompletedOrderPhotoInfoCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *orderImageView;
@property (weak, nonatomic) IBOutlet UILabel *orderDescLabel;

- (void)setOrderImage: (NSString *)url desc: (NSString *)desc;

@end
