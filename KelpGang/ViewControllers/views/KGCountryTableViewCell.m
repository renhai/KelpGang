//
//  KGCountryTableViewCell.m
//  KelpGang
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCountryTableViewCell.h"

@implementation KGCountryTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if (selected) {
        [self.splitLine setImage:[UIImage imageNamed:@"selected_line"]];
    } else {
        [self.splitLine setImage:[UIImage imageNamed:@"default_line"]];
    }
}

@end
