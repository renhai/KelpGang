//
//  KGTaskDetailHeadCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskDetailHeadCell.h"
#import "KGTaskObject.h"

@interface KGTaskDetailHeadCell ()

@property (nonatomic, strong) UILabel *nameTailLabel;
@property (nonatomic, strong) UIView *bottomLine;


@end

@implementation KGTaskDetailHeadCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = RGB(246, 251, 249);

        UIImageView *headImageView = [[UIImageView alloc] initWithFrame:CGRectMake(15, 15, 60, 60)];
        headImageView.contentMode = UIViewContentModeScaleAspectFill;
        headImageView.clipsToBounds = YES;
        headImageView.layer.cornerRadius = headImageView.width / 2;
        self.headImageView = headImageView;

        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameLabel.font = [UIFont systemFontOfSize:16];
        nameLabel.backgroundColor = CLEARCOLOR;
        self.nameLabel = nameLabel;

        UILabel *nameTailLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        nameTailLabel.font = [UIFont systemFontOfSize:13];
        nameTailLabel.text = @"需要";
        nameTailLabel.backgroundColor = CLEARCOLOR;
        nameTailLabel.textColor = RGB(211, 211, 211);
        self.nameTailLabel = nameTailLabel;

        UILabel *descLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, 220, 40)];
        descLabel.font = [UIFont systemFontOfSize:16];
        descLabel.backgroundColor = CLEARCOLOR;
        descLabel.textColor = MAIN_COLOR;
        descLabel.numberOfLines = 0;
        descLabel.lineBreakMode = NSLineBreakByTruncatingTail;
        self.descLabel = descLabel;

        UILabel *fromLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        fromLabel.font = [UIFont systemFontOfSize:13];
        fromLabel.backgroundColor = CLEARCOLOR;
        fromLabel.textColor = RGB(149, 148, 148);
        self.fromLabel = fromLabel;

        UILabel *deadlineLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        deadlineLabel.font = [UIFont systemFontOfSize:13];
        deadlineLabel.backgroundColor = CLEARCOLOR;
        deadlineLabel.textColor = RGB(149, 148, 148);
        self.deadlineLabel = deadlineLabel;

        UILabel *graLabel = [[UILabel alloc]initWithFrame:CGRectZero];
        graLabel.font = [UIFont systemFontOfSize:14];
        graLabel.backgroundColor = CLEARCOLOR;
        graLabel.textColor = MAIN_COLOR;
        self.graLabel = graLabel;

        UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(0, 0, self.width, LINE_HEIGHT)];
        self.bottomLine = bottomLine;

        [self addSubview:self.headImageView];
        [self addSubview:self.nameLabel];
        [self addSubview:self.nameTailLabel];
        [self addSubview:self.descLabel];
        [self addSubview:self.fromLabel];
        [self addSubview:self.deadlineLabel];
        [self addSubview:self.graLabel];
        [self addSubview:self.bottomLine];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.nameLabel sizeToFit];
    self.nameLabel.left = self.headImageView.right + 15;
    self.nameLabel.top = self.headImageView.top;

    [self.nameTailLabel sizeToFit];
    self.nameTailLabel.left = self.nameLabel.right;
    self.nameTailLabel.centerY = self.nameLabel.centerY;

    [self.descLabel sizeToFit];
    self.descLabel.left = self.nameLabel.left;
    self.descLabel.top = self.nameLabel.bottom + 10;
    if (self.descLabel.height > 40) {
        self.descLabel.height = 40;
    }

    [self.fromLabel sizeToFit];
    self.fromLabel.left = self.nameLabel.left;
    self.fromLabel.bottom = self.height - 10;

    [self.deadlineLabel sizeToFit];
    self.deadlineLabel.left = self.fromLabel.right + 10;
    self.deadlineLabel.bottom = self.height - 10;

    [self.graLabel sizeToFit];
    self.graLabel.left = self.deadlineLabel.right + 10;
    self.graLabel.centerY = self.deadlineLabel.centerY;

    self.bottomLine.bottom = self.height;
}

- (void)setObject:(id)object {
    [super setObject:object];
    KGTaskObject *taskObj = object;

    [self.headImageView setImageWithURL:[NSURL URLWithString:taskObj.ownerHeadUrl] placeholderImage:[UIImage imageNamed:kAvatarMale] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    self.nameLabel.text = taskObj.ownerName;
    self.nameLabel.textColor = taskObj.ownerGender == MALE ? MAIN_COLOR : RGB(255, 133, 133);
    self.descLabel.text = taskObj.title;
    self.fromLabel.text = !taskObj.ownerCity || [@"" isEqualToString:taskObj.ownerCity]? @"未知城市" : taskObj.ownerCity;
    NSDateFormatter *formattor = [[NSDateFormatter alloc] init];
    formattor.dateFormat = @"M/d";
    NSString *timestamp = [formattor stringFromDate:taskObj.deadline];
    self.deadlineLabel.text = [NSString stringWithFormat:@"%@失效", timestamp];
    self.graLabel.text = [NSString stringWithFormat:@"跑腿费%0.1f%%", taskObj.gratuity];
    
    [self setNeedsLayout];
}

@end
