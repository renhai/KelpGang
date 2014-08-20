//
//  KGMyJourneyCell.m
//  KelpGang
//
//  Created by Andy on 14-8-20.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGMyJourneyCell.h"
#import "KGJourneyObject.h"

@implementation KGMyJourneyCell

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
    self.journeyImgView.size = CGSizeMake(60, 60);
    self.journeyImgView.origin = CGPointMake(20, 10);
    [self.descLabel sizeToFit];
    self.descLabel.origin = CGPointMake(self.journeyImgView.right + 10, self.journeyImgView.top);
    [self.toCountryLabel sizeToFit];
    self.toCountryLabel.origin = CGPointMake(self.descLabel.left, self.descLabel.bottom + 10);
    [self.deadlineLabel sizeToFit];
    self.deadlineLabel.origin = CGPointMake(self.journeyImgView.right + 105, 70);
    [self.statusLabel sizeToFit];
    self.statusLabel.right = self.width - 20;
    self.statusLabel.centerY = self.deadlineLabel.centerY;
    self.statusLabel.width += 4;
    self.statusLabel.height += 2;
}

- (void)setObject:(KGJourneyObject *)obj {
    self.journeyImgView.clipsToBounds = YES;
    self.journeyImgView.contentMode = UIViewContentModeScaleAspectFill;
    [self.journeyImgView setImageWithURL:[NSURL URLWithString:obj.defaultGoodsImgUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.journeyImgView.layer.borderWidth = 1;
    self.journeyImgView.layer.borderColor = RGB(187, 187, 187).CGColor;

    self.descLabel.text = obj.desc;
    self.descLabel.width = 210;
    self.descLabel.font = [UIFont systemFontOfSize:13];
    self.descLabel.textColor = RGB(114, 114, 114);
    self.descLabel.numberOfLines = 2;

    self.toCountryLabel.text = [NSString stringWithFormat:@"目的地：%@", obj.toCountry];
    self.toCountryLabel.font = [UIFont systemFontOfSize:13];
    self.toCountryLabel.textColor = RGB(187, 187, 187);

    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M/d"];
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@到期", [formatter stringFromDate:obj.backDate]];
    self.deadlineLabel.font = [UIFont systemFontOfSize:12];
    self.deadlineLabel.textColor = RGB(33, 185, 162);

    self.statusLabel.font = [UIFont systemFontOfSize:13];
    self.statusLabel.layer.cornerRadius = 4;
    self.statusLabel.layer.borderWidth = 1;
    self.statusLabel.textColor = MAIN_COLOR;
    self.statusLabel.layer.borderColor = MAIN_COLOR.CGColor;
    self.statusLabel.text = @"进行中";
    self.statusLabel.textAlignment = NSTextAlignmentCenter;
}

@end
