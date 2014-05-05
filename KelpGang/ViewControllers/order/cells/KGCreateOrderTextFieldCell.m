//
//  KGCreateOrderTextFieldCell.m
//  KelpGang
//
//  Created by Andy on 14-5-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderTextFieldCell.h"

@implementation KGCreateOrderTextFieldCell

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

}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.label sizeToFit];
    self.textField.left = self.label.right;
}

- (void)configCell: (NSString *)title text: (NSString *)text {
    self.label.text = title;
    self.textField.text = text;
}


@end
