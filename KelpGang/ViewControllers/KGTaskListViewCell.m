//
//  KGTaskListViewCell.m
//  KelpGang
//
//  Created by Andy on 14-3-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskListViewCell.h"

@implementation KGTaskListViewCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end