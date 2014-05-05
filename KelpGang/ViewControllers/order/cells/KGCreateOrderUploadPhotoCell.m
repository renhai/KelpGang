//
//  KGCreateOrderUploadPhotoCell.m
//  KelpGang
//
//  Created by Andy on 14-4-29.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCreateOrderUploadPhotoCell.h"

@implementation KGCreateOrderUploadPhotoCell

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
    self.photoNameTextField.top = 7;
    self.photoNameTextField.left = 20;
    self.deleteAllPhotosButton.top = self.photoNameTextField.top;
    self.deleteAllPhotosButton.right = self.width - 20;
    self.photosView.top = self.photoNameTextField.bottom + 15;
}

@end
