//
//  KGJourneyAddImgTableViewCell.m
//  KelpGang
//
//  Created by Andy on 14-3-19.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGJourneyAddImgTableViewCell.h"
#import "KGJourneyGoods.h"

@interface KGJourneyAddImgTableViewCell ()

@property (nonatomic, strong) KGJourneyGoods *goodsObj;

@end

@implementation KGJourneyAddImgTableViewCell

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

- (void)setupData: (KGJourneyGoods *) goods {
    for (UIView *subview in self.imgScrollView.subviews) {
        [subview removeFromSuperview];
    }
    if (!goods) {
        return;
    }
    self.imgNameTextField.text = goods.name;
    NSMutableArray *thumbs = goods.thumbs;
    NSInteger index = 0;
    for (UIImage *img in thumbs) {
        CGRect frame = CGRectMake((index ++) * (kImageContainerViewWidth), 0, kImageContainerViewWidth, kImageViewHeight);
        KGJourneyPictureContainerView *containerView = [[KGJourneyPictureContainerView alloc] initWithFrame:frame image:img];
        [self.imgScrollView addSubview:containerView];
    }
    UIView *addContainerView = [[UIView alloc] initWithFrame:CGRectMake((index ++) * (kImageContainerViewWidth), 0, kImageContainerViewWidth, kImageViewHeight)];
    UIImageView *addImgView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, kImageViewWidth, kImageViewHeight)];
    addImgView.image = [UIImage imageNamed:@"add_img"];
    [addContainerView addSubview:addImgView];
    [self.imgScrollView addSubview:addContainerView];
    self.imgScrollView.contentSize = CGSizeMake(index * kImageContainerViewWidth, kImageViewHeight);
    self.imgScrollView.contentInset = UIEdgeInsetsMake(0, 15, 0, 15);
    if (index > 3) {
        [self.imgScrollView setContentOffset:CGPointMake((index - 3) * kImageContainerViewWidth, 0) animated:YES];
    }

}



@end
