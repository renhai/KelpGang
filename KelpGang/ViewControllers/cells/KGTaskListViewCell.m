//
//  KGTaskListViewCell.m
//  KelpGang
//
//  Created by Andy on 14-3-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskListViewCell.h"
#import "KGTaskObject.h"

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

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.cityLabel sizeToFit];
    self.cityLabel.centerX = self.headImageView.centerX;
    [self.nameLabel sizeToFit];
    self.nameLabel.top = self.headImageView.top;
    [self.xuyaoLabel sizeToFit];
    self.xuyaoLabel.left = self.nameLabel.right + 3;
    self.xuyaoLabel.top = self.nameLabel.top;
    [self.commissionLabel sizeToFit];
    self.commissionLabel.top = self.nameLabel.top;
    self.commissionLabel.left = 100;
    [self.deadLineLabel sizeToFit];
    self.deadLineLabel.right = self.deadLineLabel.superview.width - 10;
    self.deadLineLabel.top = self.nameLabel.top;
    [self.descLabel sizeToFit];
    self.descLabel.top = self.headImageView.centerY - 3;
    self.descLabel.width = 220;
}

- (void)setObject:(KGTaskObject *)taskObj {
    self.headImageView.clipsToBounds = YES;
    self.headImageView.ContentMode = UIViewContentModeScaleAspectFill;
    self.headImageView.layer.cornerRadius = self.headImageView.frame.size.width / 2;
    [self.headImageView setImageWithURL:[NSURL URLWithString:taskObj.ownerHeadUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];

    self.cityLabel.text = taskObj.ownerCity;
    self.nameLabel.text = taskObj.ownerName;
    self.nameLabel.textColor = taskObj.ownerGender == MALE ? MAIN_COLOR : RGB(255, 133, 133);
    self.xuyaoLabel.textColor = taskObj.ownerGender == MALE ? MAIN_COLOR : RGB(255, 133, 133);

    self.commissionLabel.text = [NSString stringWithFormat:@"跑腿费%0.1f%%",taskObj.gratuity];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    formatter.dateFormat = @"M/d";
    self.deadLineLabel.text = [NSString stringWithFormat:@"%@到期",[formatter stringFromDate:taskObj.deadline]];

    self.descLabel.text = taskObj.title;
    self.descLabel.numberOfLines = 2;

}

@end
