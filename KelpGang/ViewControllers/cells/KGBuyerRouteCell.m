//
//  KGBuyerRouteCell.m
//  KelpGang
//
//  Created by Andy on 14-6-13.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBuyerRouteCell.h"

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

- (void)setRouteInfo: (NSDictionary *)info {
    self.fromLabel.text = info[@"from"];
    self.toLabel.text = info[@"to"];
    if (!info[@"from"] || [@"" isEqualToString:info[@"from"]]) {
        self.toLabel.text = [NSString stringWithFormat:@"常驻%@", info[@"to"]];
    }
    self.descLabel.text = info[@"travel_desc"];
    double startTime = [info[@"travel_start_time"] doubleValue];
    NSDate *startDate = [NSDate dateWithTimeIntervalSince1970:startTime];
    double endTime = [info[@"travel_back_time"] doubleValue];
    NSDate *endDate = [NSDate dateWithTimeIntervalSince1970:endTime];
    NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
    [formatter setDateFormat:@"M.d"];
    NSString *durStr = [NSString stringWithFormat:@"%@-%@", [formatter stringFromDate:startDate], [formatter stringFromDate:endDate]];
    self.durationLabel.text = durStr;
}


@end
