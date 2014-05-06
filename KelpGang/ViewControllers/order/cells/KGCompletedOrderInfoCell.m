//
//  KGCompletedOrderInfoCell.m
//  KelpGang
//
//  Created by Andy on 14-5-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCompletedOrderInfoCell.h"

@implementation KGCompletedOrderInfoCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.orderNumberTitle sizeToFit];
    self.orderNumberTitle.left = 15;
    self.orderNumberTitle.top = 8;

    [self.orderNumberValue sizeToFit];
    self.orderNumberValue.left = self.orderNumberTitle.right + 15;
    self.orderNumberValue.top = self.orderNumberTitle.top;

    [self.orderDateTitle sizeToFit];
    self.orderDateTitle.left = self.orderNumberTitle.left;
    self.orderDateTitle.top = self.orderNumberTitle.bottom + 5;

    [self.orderDateValue sizeToFit];
    self.orderDateValue.left = self.orderDateTitle.right + 15;
    self.orderDateValue.top = self.orderDateTitle.top;
}

-(void)setOrderNumber: (NSString *)number date: (NSDate *)date {
    self.orderNumberValue.text = number;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"yyyy.MM.dd HH:mm:ss"];
    self.orderDateValue.text = [formatter stringFromDate:date];
}


@end
