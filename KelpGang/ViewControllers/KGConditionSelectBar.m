//
//  KGConditionSelectBar.m
//  KelpGang
//
//  Created by Andy on 14-3-2.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGConditionSelectBar.h"
#import "KGCountryConditionView.h"

@interface KGConditionSelectBar()

@property (nonatomic, strong) NSArray *continents;
@property (nonatomic, strong) NSDictionary *countrys;
@property (nonatomic, copy) NSString *currContinent;
@property (nonatomic, assign) NSInteger tableViewTag;
@property (nonatomic, strong) NSMutableDictionary *conditionViews;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, strong) NSMutableDictionary *btnDic;
@property (nonatomic, strong) NSArray *timeConditions;
@property (nonatomic, strong) NSArray *sortConditions;

@end

@implementation KGConditionSelectBar

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

-(id)initWithCoder:(NSCoder *)aDecoder {
    self = [super initWithCoder:aDecoder];
    if (self) {
        self.continents = @[@"热门国家", @"亚洲", @"欧洲", @"非洲", @"北美洲", @"南美洲", @"大洋洲"];
        self.countrys = @{@"热门国家":@[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"],
                          @"亚洲": @[@"日本",@"韩国",@"泰国"],
                          @"欧洲": @[@"英国",@"法国",@"意大利",@"德国"],
                          @"非洲": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"],
                          @"北美洲": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"],
                          @"南美洲": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"],
                          @"大洋洲": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊"]};
        self.timeConditions = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻"];
        self.sortConditions = @[@"按距离排序", @"按信用排序", @"按人气排序"];
        self.conditionViews = [NSMutableDictionary dictionaryWithCapacity:3];
        self.btnDic = [NSMutableDictionary dictionaryWithCapacity:3];
        self.currTapIndex = -1;
    }
    return self;
}

-(void)btnTaped:(UIButton *)sender {
    NSLog(@"btn tag: %d", sender.tag);
    if (![self.btnDic objectForKey:@(sender.tag)]) {
        [self.btnDic setObject:sender forKey:@(sender.tag)];
    }
    if (self.currTapIndex == -1) {
        [self openConditionView:sender.tag];
    } else if (self.currTapIndex == sender.tag) {
        [self closeConditionView:sender.tag];
    } else {
        [self closeConditionView:self.currTapIndex];
        [self openConditionView:sender.tag];
    }
}

- (void) closeConditionView: (NSInteger) index {
    UIView *currView = [self.conditionViews objectForKey:@(index)];
    if (currView) {
        [currView removeFromSuperview];
    }
    UIImage *arrowDownImg = [UIImage imageNamed:@"arrow-down.png"];
    UIButton *btn = [self.btnDic objectForKey:@(index)];
    if (btn) {
        [btn setImage:arrowDownImg forState:UIControlStateNormal];
    }
    self.headLineImageView.hidden = YES;
    self.currTapIndex = -1;

    if (index == 1) {
        self.countryIndicatorImageView.hidden = YES;
    } else if (index == 2) {
        self.timeIndicatorImageView.hidden = YES;
    } else if (index == 3) {
        self.sortIndicatorImageView.hidden = YES;
    }
}

- (void) openConditionView: (NSInteger) index {
    UIView *view = [self renderConditionView:index];
    if (view) {
        [self.canvasView addSubview:view];
    }
    UIImage *arrowUpImg = [UIImage imageNamed:@"arrow-up.png"];
    UIButton *btn = [self.btnDic objectForKey:@(index)];
    if (btn) {
        [btn setImage:arrowUpImg forState:UIControlStateNormal];
    }
    self.headLineImageView.hidden = NO;
    self.currTapIndex = index;

    if (index == 1) {
        self.countryIndicatorImageView.hidden = NO;
    } else if (index == 2) {
        self.timeIndicatorImageView.hidden = NO;
    } else if (index == 3) {
        self.sortIndicatorImageView.hidden = NO;
    }
}

- (UIView *) renderConditionView: (NSInteger) index {
    if ([self.conditionViews objectForKey:@(index)]) {
        return [self.conditionViews objectForKey:@(index)];
    } else {
        CGFloat currY = self.frame.origin.y + self.frame.size.height;
        if (index == 1) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
            KGCountryConditionView *countryConditionView = [nibArr objectAtIndex:0];
            CGRect countryFrame = countryConditionView.frame;
            countryFrame.origin.y = currY;
            countryConditionView.frame = countryFrame;
            [countryConditionView.continentTableView setSeparatorColor:[UIColor clearColor]];
            NSIndexPath *firstLine= [NSIndexPath indexPathForRow:0 inSection:0];
            [countryConditionView.continentTableView selectRowAtIndexPath:firstLine animated:YES scrollPosition:UITableViewScrollPositionNone];
            [self tableView:countryConditionView.continentTableView didSelectRowAtIndexPath:firstLine];
            self.currContinent = [self.continents objectAtIndex:0];

            [self.conditionViews setObject:countryConditionView forKey:@(index)];
            return countryConditionView;
        } else if (index == 2) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGTimeConditionView" owner:self options:nil];
            UITableView *timeTableView = [nibArr objectAtIndex:0];
            CGRect timeFrame = timeTableView.frame;
            timeFrame.origin.y = currY;
            timeTableView.frame = timeFrame;
            [self.conditionViews setObject:timeTableView forKey:@(index)];
            return timeTableView;
        } else {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGSortConditionView" owner:self options:nil];
            UITableView *sortTableView = [nibArr objectAtIndex:0];
            CGRect timeFrame = sortTableView.frame;
            timeFrame.origin.y = currY;
            sortTableView.frame = timeFrame;
            [self.conditionViews setObject:sortTableView forKey:@(index)];
            return sortTableView;
        }
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(tableView.tag == 1) {
        return [self.continents count];
    } else if (tableView.tag == 2) {
        return [[self.countrys objectForKey:self.currContinent] count];
    } else if (tableView.tag == 3) {
        return [self.timeConditions count];
    } else if (tableView.tag == 4) {
        return [self.sortConditions count];
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kLeftTableViewCell = @"kLeftTableViewCell";
    static NSString *kTimeTableViewCell = @"kTimeTableViewCell";
    static NSString *kSortTableViewCell = @"kSortTableViewCell";

    UITableViewCell *cell = nil;
    if(tableView.tag == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
            cell = [nibArr objectAtIndex:1];
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [self.continents objectAtIndex:[indexPath row]];
    } else if (tableView.tag == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
            cell = [nibArr objectAtIndex:1];
        }
        cell.backgroundColor = [UIColor whiteColor];
        cell.textLabel.text = [[self.countrys objectForKey:self.currContinent]objectAtIndex:[indexPath row]];
    } else if (tableView.tag == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:kTimeTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGTimeConditionView" owner:self options:nil];
            cell = [nibArr objectAtIndex:1];
            cell.textLabel.text = [self.timeConditions objectAtIndex: [indexPath row]];
        }
    } else if (tableView.tag == 4) {
        cell = [tableView dequeueReusableCellWithIdentifier:kSortTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGSortConditionView" owner:self options:nil];
            cell = [nibArr objectAtIndex:1];
            cell.textLabel.text = [self.sortConditions objectAtIndex: [indexPath row]];
        }
    }

    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectedIndex = self.currTapIndex;
    if(tableView.tag == 1) {
        NSInteger row = indexPath.row;
        NSLog(@"item%d is: %@", row, [self.continents objectAtIndex:row]);
        NSString *continent = [self.continents objectAtIndex:row];
        self.currContinent = continent;
        UIView *currView = [self.conditionViews objectForKey:@(self.currTapIndex)];
        if ([currView respondsToSelector:@selector(countryTableView)]) {
            UITableView *countryTableView = [currView performSelector:@selector(countryTableView) withObject:currView];
            [countryTableView reloadData];
        }
    } else if (tableView.tag == 2){
        [self closeConditionView:self.currTapIndex];
        NSString *selectCountry = [[self.countrys objectForKey:self.currContinent]objectAtIndex:[indexPath row]];
        [self.countryBtn setTitle:selectCountry forState:UIControlStateNormal];
        NSInteger offset = self.countryBtn.titleLabel.frame.origin.x + self.countryBtn.titleLabel.frame.size.width + 2;
        NSLog(@"offset: %d", offset);
        [self.countryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
        [self.delegate didSelectCondition:selectedIndex item:selectCountry];
    } else if (tableView.tag == 3) {
        [self closeConditionView:self.currTapIndex];
        NSString *selectTime = [self.timeConditions objectAtIndex:indexPath.row];
        [self.timeBtn setTitle:selectTime forState:UIControlStateNormal];
        NSInteger offset = self.timeBtn.titleLabel.frame.origin.x + self.timeBtn.titleLabel.frame.size.width + 2;
        NSLog(@"offset: %d", offset);
        [self.timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
        [self.delegate didSelectCondition:selectedIndex item:selectTime];
    } else if (tableView.tag == 4) {
        [self closeConditionView:self.currTapIndex];
        NSString *selectSort = [self.sortConditions objectAtIndex:indexPath.row];
        [self.sortBtn setTitle:selectSort forState:UIControlStateNormal];
        NSInteger offset = self.sortBtn.titleLabel.frame.origin.x + self.sortBtn.titleLabel.frame.size.width + 2;
        NSLog(@"offset: %d", offset);
        [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
        [self.delegate didSelectCondition:selectedIndex item:selectSort];
    }

}

@end
