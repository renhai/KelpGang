//
//  KGBaseMessageCell.m
//  KelpGang
//
//  Created by Andy on 14-4-16.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGBaseMessageCell.h"
#import "KGChatObject.h"

@implementation KGBaseMessageCell

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

- (void)configCell:(KGChatObject *) chatObj {
    self.chatObj = chatObj;
    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    [self addSubview:indicatorView];
    self.indicatorView = indicatorView;
    [self showMessageIndicator:chatObj.showIndicator];
}

- (void)showMessageIndicator: (BOOL)display {
    if (display) {
        [self.indicatorView startAnimating];
    } else {
        [self.indicatorView stopAnimating];
    }
}

@end
