//
//  KGTaskGoodsPhotoCell.m
//  KelpGang
//
//  Created by Andy on 14-9-12.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskGoodsPhotoCell.h"

@interface KGTaskGoodsPhotoCell ()

@end

@implementation KGTaskGoodsPhotoCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.contentView.backgroundColor = [UIColor whiteColor];

        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        UICollectionView *collectionView=[[UICollectionView alloc] initWithFrame:CGRectMake(10, 10, 300, 95) collectionViewLayout:layout];
        [collectionView setBackgroundColor:[UIColor clearColor]];
        self.photosView = collectionView;

        [self addSubview:self.photosView];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
}

- (void)setObject:(id)object {
    [super setObject:object];

    [self setNeedsLayout];
}

@end
