//
//  KGConditionSelectBar.m
//  KelpGang
//
//  Created by Andy on 14-3-2.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGConditionSelectBar.h"
#import "KGCountryConditionView.h"
#import "KGMainMenuTableViewCell.h"
#import "KGSubMenuTableViewCell.h"

static NSString * const kContinentKey = @"continent";
static NSString * const kCountryKey = @"country";
static NSString * const kRegionKey = @"region";
static NSString * const kCityKey = @"city";

@interface KGConditionSelectBar()

@property (nonatomic, strong) NSArray *countryArr;
@property (nonatomic, assign) NSInteger currContinentIndex;
@property (nonatomic, strong) NSMutableDictionary *conditionViews;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, strong) NSMutableDictionary *btnDic;
@property (nonatomic, strong) NSArray *timeConditions;
@property (nonatomic, strong) NSArray *sortConditions;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, assign) NSInteger currRegionIndex;


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
        self.countryArr = @[@{@"continent": @"热门国家",@"country": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]},
                            @{@"continent": @"亚洲",@"country": @[@"日本",@"韩国",@"泰国"]},
                            @{@"continent": @"欧洲",@"country": @[@"英国",@"法国",@"意大利",@"德国"]},
                            @{@"continent": @"非洲",@"country": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                            @{@"continent": @"北美洲",@"country": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                            @{@"continent": @"南美洲",@"country": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]},
                            @{@"continent": @"大洋洲",@"country": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊"]}];
        self.cityArr = @[@{@"region": @"热门城市",@"city": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                            @{@"region": @"华东",@"city": @[@"石家庄",@"邯郸",@"北京"]},
                            @{@"region": @"华北",@"city": @[@"英国",@"法国",@"意大利",@"德国"]},
                            @{@"region": @"华南",@"city": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                            @{@"region": @"西部",@"city": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                            @{@"region": @"其他",@"city": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
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
    UIImage *arrowDownImg = [UIImage imageNamed:@"arrow-down"];
    UIButton *btn = [self.btnDic objectForKey:@(index)];
    if (btn) {
        [btn setImage:arrowDownImg forState:UIControlStateNormal];
    }
//    self.headLineImageView.hidden = YES;
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
    self.currTapIndex = index;

    UIView *view = [self renderConditionView:index];
    if (view) {
        [self.canvasView addSubview:view];
    }
    UIImage *arrowUpImg = [UIImage imageNamed:@"arrow-up"];
    UIButton *btn = [self.btnDic objectForKey:@(index)];
    if (btn) {
        [btn setImage:arrowUpImg forState:UIControlStateNormal];
    }
//    self.headLineImageView.hidden = NO;

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
            NSIndexPath *firstRow= [NSIndexPath indexPathForRow:0 inSection:0];
            [countryConditionView.continentTableView selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:countryConditionView.continentTableView didSelectRowAtIndexPath:firstRow];
            self.currContinentIndex = 0;
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
//            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGSortConditionView" owner:self options:nil];
//            UITableView *sortTableView = [nibArr objectAtIndex:0];
//            CGRect timeFrame = sortTableView.frame;
//            timeFrame.origin.y = currY;
//            sortTableView.frame = timeFrame;
//            [self.conditionViews setObject:sortTableView forKey:@(index)];
//            return sortTableView;
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGCountryConditionView" owner:self options:nil];
            KGCountryConditionView *countryConditionView = [nibArr objectAtIndex:0];
            CGRect countryFrame = countryConditionView.frame;
            countryFrame.origin.y = currY;
            countryConditionView.frame = countryFrame;
            NSIndexPath *firstRow= [NSIndexPath indexPathForRow:0 inSection:0];
            [countryConditionView.continentTableView selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:countryConditionView.continentTableView didSelectRowAtIndexPath:firstRow];
            self.currRegionIndex = 0;
            [self.conditionViews setObject:countryConditionView forKey:@(index)];
            return countryConditionView;
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
        if (self.currTapIndex == 1) {
            return [self.countryArr count];
        } else if (self.currTapIndex == 3) {
            return [self.cityArr count];
        }
    } else if (tableView.tag == 2) {
        if (self.currTapIndex == 1) {
            NSDictionary *dic = [self.countryArr objectAtIndex:self.currContinentIndex];
            return [[dic objectForKey:kCountryKey] count];
        } else if (self.currTapIndex == 3) {
            NSDictionary *dic = [self.cityArr objectAtIndex:self.currRegionIndex];
            return [[dic objectForKey:kCityKey] count];
        }
    } else if (tableView.tag == 3) {
        return [self.timeConditions count];
    }
//    else if (tableView.tag == 4) {
//        return [self.sortConditions count];
//    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kLeftTableViewCell = @"kMainMenuTableViewCell";
    static NSString *kRightTableViewCell = @"kSubMenuTableViewCell";
    static NSString *kTimeTableViewCell = @"kTimeTableViewCell";
//    static NSString *kSortTableViewCell = @"kSortTableViewCell";

    UITableViewCell *cell = nil;
    if(tableView.tag == 1) {
        cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGMainMenuTableViewCell" owner:self options:nil];
            cell = [nibArr objectAtIndex:0];
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        KGMainMenuTableViewCell *continentCell = (KGMainMenuTableViewCell *) cell;
        if (self.currTapIndex == 1) {
            continentCell.continentLabel.text = [[self.countryArr objectAtIndex:[indexPath row]] objectForKey:kContinentKey];
        } else if (self.currTapIndex == 3) {
            continentCell.continentLabel.text = [[self.cityArr objectAtIndex:[indexPath row]] objectForKey:kRegionKey];
        }
    } else if (tableView.tag == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:kRightTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGSubMenuTableViewCell" owner:self options:nil];
            cell = [nibArr objectAtIndex:0];
        }
        cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
        cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
        KGSubMenuTableViewCell *countryCell = (KGSubMenuTableViewCell *) cell;
        if (self.currTapIndex == 1) {
            countryCell.countryLabel.text = [[[self.countryArr objectAtIndex:self.currContinentIndex] objectForKey:kCountryKey] objectAtIndex:indexPath.row];
        } else if (self.currTapIndex == 3) {
            countryCell.countryLabel.text = [[[self.cityArr objectAtIndex:self.currRegionIndex] objectForKey:kCityKey] objectAtIndex:indexPath.row];
        }
    } else if (tableView.tag == 3) {
        cell = [tableView dequeueReusableCellWithIdentifier:kTimeTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGTimeConditionView" owner:self options:nil];
            cell = [nibArr objectAtIndex:1];
            cell.textLabel.text = [self.timeConditions objectAtIndex: [indexPath row]];
        }
    }
//    else if (tableView.tag == 4) {
//        cell = [tableView dequeueReusableCellWithIdentifier:kSortTableViewCell];
//        if (cell == nil) {
//            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGSortConditionView" owner:self options:nil];
//            cell = [nibArr objectAtIndex:1];
//            cell.textLabel.text = [self.sortConditions objectAtIndex: [indexPath row]];
//        }
//    }

    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger selectedIndex = self.currTapIndex;
    if(tableView.tag == 1) {
        NSInteger row = indexPath.row;
        if (self.currTapIndex == 1) {
            NSLog(@"item%d is: %@", row, [[self.countryArr objectAtIndex:row] objectForKey:kContinentKey]);
            self.currContinentIndex = row;
            UIView *currView = [self.conditionViews objectForKey:@(self.currTapIndex)];
            if ([currView respondsToSelector:@selector(countryTableView)]) {
                UITableView *countryTableView = [currView performSelector:@selector(countryTableView) withObject:currView];
                [countryTableView reloadData];
            }
        } else if (self.currTapIndex == 3) {
            NSLog(@"item%d is: %@", row, [[self.cityArr objectAtIndex:row] objectForKey:kRegionKey]);
            self.currRegionIndex = row;
            UIView *currView = [self.conditionViews objectForKey:@(self.currTapIndex)];
            if ([currView respondsToSelector:@selector(countryTableView)]) {
                UITableView *countryTableView = [currView performSelector:@selector(countryTableView) withObject:currView];
                [countryTableView reloadData];
            }
        }
    } else if (tableView.tag == 2){
        if (self.currTapIndex == 1) {
            [self closeConditionView:self.currTapIndex];
            NSString *selectCountry = [[[self.countryArr objectAtIndex:self.currContinentIndex] objectForKey:kCountryKey] objectAtIndex:indexPath.row];
            [self.countryBtn setTitle:selectCountry forState:UIControlStateNormal];
            NSInteger offset = self.countryBtn.titleLabel.frame.origin.x + self.countryBtn.titleLabel.frame.size.width + 2;
            NSLog(@"offset: %d", offset);
            [self.countryBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
            [self.delegate didSelectCondition:selectedIndex item:selectCountry];
        } else if (self.currTapIndex == 3) {
            [self closeConditionView:self.currTapIndex];
            NSString *selectCountry = [[[self.cityArr objectAtIndex:self.currRegionIndex] objectForKey:kCityKey] objectAtIndex:indexPath.row];
            [self.sortBtn setTitle:selectCountry forState:UIControlStateNormal];
            NSInteger offset = self.sortBtn.titleLabel.frame.origin.x + self.sortBtn.titleLabel.frame.size.width + 2;
            NSLog(@"offset: %d", offset);
            [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
            [self.delegate didSelectCondition:selectedIndex item:selectCountry];
        }
    } else if (tableView.tag == 3) {
        [self closeConditionView:self.currTapIndex];
        NSString *selectTime = [self.timeConditions objectAtIndex:indexPath.row];
        [self.timeBtn setTitle:selectTime forState:UIControlStateNormal];
        NSInteger offset = self.timeBtn.titleLabel.frame.origin.x + self.timeBtn.titleLabel.frame.size.width + 2;
        NSLog(@"offset: %d", offset);
        [self.timeBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
        [self.delegate didSelectCondition:selectedIndex item:selectTime];
    }

//    else if (tableView.tag == 4) {
//        [self closeConditionView:self.currTapIndex];
//        NSString *selectSort = [self.sortConditions objectAtIndex:indexPath.row];
//        [self.sortBtn setTitle:selectSort forState:UIControlStateNormal];
//        NSInteger offset = self.sortBtn.titleLabel.frame.origin.x + self.sortBtn.titleLabel.frame.size.width + 2;
//        NSLog(@"offset: %d", offset);
//        [self.sortBtn setImageEdgeInsets:UIEdgeInsetsMake(0, offset, 0, 0)];
//        [self.delegate didSelectCondition:selectedIndex item:selectSort];
//    }

}

@end
