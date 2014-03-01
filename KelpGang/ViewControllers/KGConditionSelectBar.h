//
//  KGConditionSelectBar.h
//  KelpGang
//
//  Created by Andy on 14-3-2.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface KGConditionSelectBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *headIndicatorImageView;

@property (nonatomic, weak) UIView* canvasView;

- (IBAction)btnTaped:(UIButton *)sender;

@end
