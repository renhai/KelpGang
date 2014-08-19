//
//  KGBuyerRouteCell.m
//  KelpGang
//
//  Created by Andy on 14-6-13.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerRouteCell.h"
#import "KGJourneyObject.h"

@implementation KGBuyerRouteCell

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
    if (!self.fromLabel.text || [@"" isEqualToString:self.fromLabel.text]) {
        self.fromLabel.hidden = YES;
        self.airplaneLabel.hidden = YES;
        [self.toLabel sizeToFit];
        self.toLabel.left = self.fromLabel.left;
    } else {
        self.fromLabel.hidden = NO;
        self.airplaneLabel.hidden = NO;
        [self.fromLabel sizeToFit];
        self.airplaneLabel.left = self.fromLabel.right + 3;
        [self.toLabel sizeToFit];
        self.toLabel.left = self.airplaneLabel.right + 3;
    }
}

- (void)setRouteInfo: (KGJourneyObject *)info {
    self.fromLabel.text = info.fromCity;
    self.toLabel.text = info.toCountry;
    if (!info.fromCity || [@"" isEqualToString:info.fromCity]) {
        self.toLabel.text = [NSString stringWithFormat:@"常驻%@", info.toCountry];
    }
    self.descLabel.text = info.desc;
    NSDate *startDate = info.startDate;
    NSDate *endDate = info.backDate;
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M.d"];
    NSString *durStr = [NSString stringWithFormat:@"%@-%@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    self.durationLabel.text = durStr;
}


@end
