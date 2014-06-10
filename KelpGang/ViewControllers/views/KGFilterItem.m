//
//  KGFilterItem.m
//  KelpGang
//
//  Created by Andy on 14-4-3.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGFilterItem.h"
#import "KGCommonMenu.h"
#import "KGCascadeMenu.h"
#import "KGMaskView.h"

static CGFloat const kMaxTextLabelWidth = 80.0;
static CGFloat const kMaxTextLabelMarginLeft = 10.0;


@interface KGFilterItem () <KGFilterViewDelegate>

@property (nonatomic, strong) UILabel *textLabel;
@property (nonatomic, strong) UIImageView *arrowImgView;
@property (nonatomic, strong) UIImageView *indImgView;

@property (nonatomic, strong) KGFilterView *filterView;
@property (nonatomic, strong) KGMaskView *maskView;

@end

@implementation KGFilterItem

- (void)dealloc {
    NSLog(@"KGFilterItem dealloc");
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame text: (NSString *) text data:(NSArray *)data{
    self = [self initWithFrame:frame];
    if (self) {
        self.text = text;
        self.data = data;
        
        self.backgroundColor = [UIColor whiteColor];
        UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
        label.text = text;
        label.font = [UIFont systemFontOfSize:15];
        label.textColor = RGBCOLOR(33, 185, 162);
        label.lineBreakMode = NSLineBreakByTruncatingTail;
        [label sizeToFit];
        self.textLabel = label;
        [self addSubview:self.textLabel];

        UIImage *indImg = [UIImage imageNamed:@"head-indicator"];
        UIImageView *indImageView = [[UIImageView alloc]initWithImage:indImg];
        self.indImgView = indImageView;
        self.indImgView.hidden = YES;
        [self addSubview:self.indImgView];

        UIImage *downArrow = [UIImage imageNamed:@"arrow-down"];
        UIImageView *arrowImageView = [[UIImageView alloc]initWithImage:downArrow];
        self.arrowImgView = arrowImageView;
        [self addSubview:self.arrowImgView];

    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGRect labelFrame = self.textLabel.frame;
    labelFrame.origin.x = (self.width - labelFrame.size.width) / 2;
    if (labelFrame.origin.x < kMaxTextLabelMarginLeft) {
        labelFrame.origin.x = kMaxTextLabelMarginLeft;
    }
    labelFrame.origin.y = (self.height - labelFrame.size.height) / 2;
    labelFrame.size.width = labelFrame.size.width > kMaxTextLabelWidth ? kMaxTextLabelWidth : labelFrame.size.width;
    self.textLabel.frame = labelFrame;

    CGRect indFrame = self.indImgView.frame;
    indFrame.origin.x = (self.width - indFrame.size.width) / 2;
    indFrame.origin.y = self.height - indFrame.size.height + LINE_HEIGHT;
    self.indImgView.frame = indFrame;

    CGRect arrowFrame = self.arrowImgView.frame;
    arrowFrame.origin.x = labelFrame.origin.x + labelFrame.size.width + 3;
    arrowFrame.origin.y = (self.height - arrowFrame.size.height) / 2;
    self.arrowImgView.frame = arrowFrame;

//    if (!self.data) {
//        self.arrowImgView.hidden = YES;
//    }
}

- (void)openFilterView {
    if (!self.filterView) {
        CGFloat y = self.origin.y + self.height + 1;
        CGRect frame;
        if (self.type == KGFilterViewCommonStyle) {
            CGFloat height = iPhone5 ? 221 : 171;
            frame = CGRectMake(0, y, SCREEN_WIDTH, height);
            KGCommonMenu *menu = [[KGCommonMenu alloc]initWithFrame:frame data:self.data];
            menu.delegate = self;
            self.filterView = menu;
        } else {
            CGFloat height = iPhone5 ? 360 : 310;
            frame = CGRectMake(0, y, SCREEN_WIDTH, height);
            KGCascadeMenu *menu = [[KGCascadeMenu alloc] initWithFrame:frame data:self.data];
            menu.delegate = self;
            self.filterView = menu;
        }
    }
    [self.canvasView addSubview:self.filterView];

    CGRect maskFrame = CGRectMake(0, NAVIGATIONBAR_IOS7_HEIGHT + self.filterView.frame.origin.y + self.filterView.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT - self.frame.size.height - self.filterView.frame.size.height);
    [self showMask:maskFrame];
    self.indImgView.hidden = NO;
    UIImage *upArrow = [UIImage imageNamed:@"arrow-up"];
    self.arrowImgView.image = upArrow;
    
}

- (void)closeFilterView {
    if (self.filterView) {
        [self.filterView removeFromSuperview];
//        self.filterView = nil;
    }
    [self removeMask];
    self.indImgView.hidden = YES;
    UIImage *downArrow = [UIImage imageNamed:@"arrow-down"];
    self.arrowImgView.image = downArrow;
}

- (void)showMask: (CGRect) frame {
    self.maskView = [[KGMaskView alloc] initWithFrame:frame];
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView:)];
    [self.maskView addGestureRecognizer:tapGesture];

    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [window addSubview:self.maskView];
}

- (void)tapMaskView: (UITapGestureRecognizer *)tapGesture {
    [self closeFilterView];
}

- (void) removeMask {
    [self.maskView removeFromSuperview];
    self.maskView = nil;
}

#pragma KGFilterViewDelegate

- (void)didSelectFilterViewCell:(NSString *)item {
    self.textLabel.text = item;
    [self.textLabel sizeToFit];
    if (self.selectDoneBlock) {
        self.selectDoneBlock(self.index, item);
    }
}


@end
