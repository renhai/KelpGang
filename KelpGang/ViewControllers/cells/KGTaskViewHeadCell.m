//
//  KGTaskViewHeadCell.m
//  KelpGang
//
//  Created by Andy on 14-8-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskViewHeadCell.h"
#import "KGTaskObject.h"

@implementation KGTaskViewHeadCell

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
    [self.nameLabel sizeToFit];
    [self.descLabel sizeToFit];
    [self.deadlineLabel sizeToFit];
    [self.commissionLabel sizeToFit];
}

- (void)setObject: (KGTaskObject *)obj {
    [self.headImageView setImageWithURL:[NSURL URLWithString:APPCONTEXT.currUser.avatarUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.headImageView.layer.cornerRadius = self.headImageView.width / 2;
    NSString *tailStr = @"需要";
    NSString *nameText = [NSString stringWithFormat:@"%@ %@",APPCONTEXT.currUser.uname, tailStr];
    NSMutableAttributedString *attrString = [[NSMutableAttributedString alloc] initWithString: nameText];
    [attrString addAttribute: NSForegroundColorAttributeName value: RGB(211, 211, 211) range: [nameText rangeOfString:tailStr]];
    [attrString addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:13] range:[nameText rangeOfString:tailStr]];
    self.nameLabel.attributedText = attrString;
    self.descLabel.text = obj.title;
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"M/d";
    NSString *timestamp = [formattor stringFromDate:obj.deadline];
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@失效", timestamp];
    self.commissionLabel.text = [NSString stringWithFormat:@"跑腿费%0.1f%%", obj.gratuity];
}


@end
