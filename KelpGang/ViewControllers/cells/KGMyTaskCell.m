//
//  KGMyTaskCell.m
//  KelpGang
//
//  Created by Andy on 14-8-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyTaskCell.h"
#import "KGTaskObject.h"

@implementation KGMyTaskCell

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

- (void)layoutSubviews {
    [super layoutSubviews];
    self.taskImgView.size = CGSizeMake(60, 60);
    self.taskImgView.origin = CGPointMake(20, 10);
    [self.titleLabel sizeToFit];
    self.titleLabel.origin = CGPointMake(self.taskImgView.right + 10, self.taskImgView.top);
    [self.moneyLabel sizeToFit];
    self.moneyLabel.origin = CGPointMake(self.titleLabel.left, self.titleLabel.bottom + 10);
    [self.deadlineLabel sizeToFit];
    self.deadlineLabel.origin = CGPointMake(self.taskImgView.right + 105, 70);
    [self.statusLabel sizeToFit];
    self.statusLabel.right = self.width - 20;
    self.statusLabel.centerY = self.deadlineLabel.centerY;
    self.statusLabel.width += 4;
    self.statusLabel.height += 2;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (void)setObject:(KGTaskObject *)obj {
    self.taskImgView.clipsToBounds = YES;
    self.taskImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.taskImgView setImageWithURL:[NSURL URLWithString:obj.defaultImageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.taskImgView.layer.borderWidth = 1;
    self.taskImgView.layer.borderColor = RGB(187, 187, 187).CGColor;

    self.titleLabel.text = obj.title;
    self.titleLabel.width = 210;
    self.titleLabel.font = [UIFont systemFontOfSize:13];
    self.titleLabel.textColor = RGB(114, 114, 114);
    self.titleLabel.numberOfLines = 2;

    self.moneyLabel.text = [NSString stringWithFormat:@"金额：￥%0.1f", obj.maxMoney];
    self.moneyLabel.font = [UIFont systemFontOfSize:13];
    self.moneyLabel.textColor = RGB(187, 187, 187);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d"];
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@到期", [formatter stringFromDate:obj.deadline]];
    self.deadlineLabel.font = [UIFont systemFontOfSize:12];
    self.deadlineLabel.textColor = RGB(33, 185, 162);

    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.layer.cornerRadius = 4;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.textColor = MAIN_COLOR;
    self.statusLabel.layer.borderColor = MAIN_COLOR.CGColor;
    self.statusLabel.text = @"待认领";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
}

@end
