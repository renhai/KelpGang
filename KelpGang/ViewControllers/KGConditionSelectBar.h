//
//  KGConditionSelectBar.h
//  KelpGang
//
//  Created by Andy on 14-3-2.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol KGConditionDelegate <NSObject>

@optional

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item;

@end

@interface KGConditionSelectBar : UIView

@property (weak, nonatomic) IBOutlet UIButton *countryBtn;
@property (weak, nonatomic) IBOutlet UIButton *timeBtn;
@property (weak, nonatomic) IBOutlet UIButton *sortBtn;
@property (weak, nonatomic) IBOutlet UIImageView *headLineImageView;
@property (weak, nonatomic) IBOutlet UIImageView *countryIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *timeIndicatorImageView;
@property (weak, nonatomic) IBOutlet UIImageView *sortIndicatorImageView;

@property (nonatomic, weak) UIView* canvasView;

@property (nonatomic, weak) id<KGConditionDelegate> delegate;

- (IBAction)btnTaped:(UIButton *)sender;

@end
