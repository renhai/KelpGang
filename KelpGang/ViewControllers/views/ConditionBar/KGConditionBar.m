//
//  KGConditionBar.m
//  KelpGang
//
//  Created by Andy on 14-3-9.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGConditionBar.h"
#import "KGConditionBarItem.h"
#import "KGSecondLevelMenuView.h"
#import "KGMainMenuTableViewCell.h"
#import "KGSubMenuTableViewCell.h"
#import "KGCommonConditionCell.h"

static NSString * const kContinentKey = @"continent";
static NSString * const kCountryKey = @"country";
static NSString * const kRegionKey = @"region";
static NSString * const kCityKey = @"city";

@interface KGConditionBar()

@property (nonatomic, strong) NSArray *countryArr;
@property (nonatomic, assign) NSInteger currContinentIndex;
@property (nonatomic, strong) NSMutableDictionary *conditionViews;
@property (nonatomic, assign) NSInteger currTapIndex;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, assign) NSInteger currRegionIndex;

@property (nonatomic, strong) UIView *maskView;


@end

@implementation KGConditionBar

- (void) dealloc {

}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

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
                            @{@"continent": @"大洋洲",@"country": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊", @"八个字的国家啊哈"]}];
        self.cityArr = @[@{@"region": @"热门城市",@"city": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                         @{@"region": @"华东",@"city": @[@"石家庄",@"邯郸",@"北京"]},
                         @{@"region": @"华北",@"city": @[@"英国",@"法国",@"意大利",@"德国"]},
                         @{@"region": @"华南",@"city": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                         @{@"region": @"西部",@"city": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                         @{@"region": @"其他",@"city": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
        self.timeArr = @[@"3天内", @"1周内", @"2周内", @"1月内", @"常驻"];
        self.conditionViews = [NSMutableDictionary dictionaryWithCapacity:3];
        self.currTapIndex = -1;

        CGFloat itemWidth = 320.0 / 3;
        NSArray *titles = @[@"目的国家", @"回国时间", @"所在城市"];
        for (NSInteger i = 0; i < 3; i ++) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGConditionBarItem" owner:self options:nil];
            KGConditionBarItem *item = [nibArr objectAtIndex:0];
            item.index = i + 1;
            item.textLabel.text = [titles objectAtIndex:i];
            item.indImgView.hidden = YES;
            item.tag = item.index;
            CGFloat x = i * itemWidth;
            CGRect frame = item.frame;
            frame.origin.x = x;
            [item setFrame:frame];
            UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(didTap:)];
            tapGesture.delegate = self;
            [item addGestureRecognizer:tapGesture];
            [self addSubview:item];
        }
    }
    return  self;
}

- (void)didTap: (UIGestureRecognizer *)gestureRecognizer {
    KGConditionBarItem *item = (KGConditionBarItem *)gestureRecognizer.view;
    if (self.currTapIndex == -1) {
        [self openConditionView:item.index];
    } else if (self.currTapIndex == item.index) {
        [self closeConditionView:item.index];
    } else {
        [self closeConditionView:self.currTapIndex];
        [self openConditionView:item.index];
    }
}

- (void)showMask: (CGRect) frame {
    self.maskView = [[UIView alloc]initWithFrame:frame];
    self.maskView.backgroundColor = [UIColor grayColor];
    self.maskView.alpha = 0.5;
    self.maskView.opaque = NO;

    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapMaskView:)];
    [self.maskView addGestureRecognizer:tapGesture];

    UIWindow *window = [UIApplication sharedApplication].keyWindow;
    if (!window) {
        window = [[UIApplication sharedApplication].windows objectAtIndex:0];
    }
    [[[window subviews] objectAtIndex:0] addSubview:self.maskView];
}

- (void)tapMaskView: (UITapGestureRecognizer *)tapGesture {
    [self closeConditionView:self.currTapIndex];
}

- (void) removeMask {
    [self.maskView removeFromSuperview];
}

- (void) closeConditionView: (NSInteger) index {
    UIView *currView = [self.conditionViews objectForKey:@(index)];
    if (currView) {
        [currView removeFromSuperview];
        [self removeMask];
    }
    KGConditionBarItem *item = (KGConditionBarItem *)[self viewWithTag:index];
    [item closeItem];
    self.currTapIndex = -1;
}

- (void) openConditionView: (NSInteger) index {
    self.currTapIndex = index;
    UIView *view = [self renderConditionView:index];
    if (view) {
        [self.canvasView addSubview:view];
        CGRect maskFrame = CGRectMake(0, NAVIGATIONBAR_IOS7_HEIGHT + view.frame.origin.y + view.frame.size.height, SCREEN_WIDTH, SCREEN_HEIGHT - NAVIGATIONBAR_IOS7_HEIGHT - self.frame.size.height - view.frame.size.height);
        [self showMask:maskFrame];
    }
    KGConditionBarItem *item = (KGConditionBarItem *)[self viewWithTag:index];
    [item openItem];
}

- (UIView *) renderConditionView: (NSInteger) index {
    if ([self.conditionViews objectForKey:@(index)]) {
        return [self.conditionViews objectForKey:@(index)];
    } else {
        CGFloat currY = self.frame.origin.y + self.frame.size.height;
        if (index == 1) {
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGSecondLevelMenuView" owner:self options:nil];
            KGSecondLevelMenuView *countryConditionView = [nibArr objectAtIndex:0];
            CGRect countryFrame = countryConditionView.frame;
            countryFrame.origin.y = currY;
            if (!iPhone5) {
                countryFrame.size.height -= 50;
            }
            countryConditionView.frame = countryFrame;
            NSIndexPath *firstRow= [NSIndexPath indexPathForRow:0 inSection:0];
            [countryConditionView.mainMenuTableView selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:countryConditionView.mainMenuTableView didSelectRowAtIndexPath:firstRow];
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
            NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGSecondLevelMenuView" owner:self options:nil];
            KGSecondLevelMenuView *cityConditionView = [nibArr objectAtIndex:0];
            CGRect cityFrame = cityConditionView.frame;
            cityFrame.origin.y = currY;
            if (!iPhone5) {
                cityFrame.size.height -= 50;
            }
            cityConditionView.frame = cityFrame;
            NSIndexPath *firstRow= [NSIndexPath indexPathForRow:0 inSection:0];
            [cityConditionView.mainMenuTableView selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
            [self tableView:cityConditionView.mainMenuTableView didSelectRowAtIndexPath:firstRow];
            self.currRegionIndex = 0;
            [self.conditionViews setObject:cityConditionView forKey:@(index)];
            return cityConditionView;
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
    if (self.currTapIndex == 1) {
        if (tableView.tag == 1) {
            return [self.countryArr count];
        } else if (tableView.tag == 2) {
            NSDictionary *dic = [self.countryArr objectAtIndex:self.currContinentIndex];
            return [[dic objectForKey:kCountryKey] count];
        }
    } else if (self.currTapIndex == 2) {
        return [self.timeArr count];
    } else if (self.currTapIndex == 3) {
        if (tableView.tag == 1) {
            return [self.cityArr count];
        } else if (tableView.tag == 2) {
            NSDictionary *dic = [self.cityArr objectAtIndex:self.currRegionIndex];
            return [[dic objectForKey:kCityKey] count];
        }
    }
    return 0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *kLeftTableViewCell = @"kMainMenuTableViewCell";
    static NSString *kRightTableViewCell = @"kSubMenuTableViewCell";
    static NSString *kTimeTableViewCell = @"kCommonConditionCell";

    UITableViewCell *cell = nil;
    if (self.currTapIndex == 1) {
        if (tableView.tag == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
            if (cell == nil) {
                NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGMainMenuTableViewCell" owner:self options:nil];
                cell = [nibArr objectAtIndex:0];
            }
            KGMainMenuTableViewCell *continentCell = (KGMainMenuTableViewCell *) cell;
            continentCell.continentLabel.text = [[self.countryArr objectAtIndex:[indexPath row]] objectForKey:kContinentKey];
        } else if (tableView.tag == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:kRightTableViewCell];
            if (cell == nil) {
                NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGSubMenuTableViewCell" owner:self options:nil];
                cell = [nibArr objectAtIndex:0];
            }
            KGSubMenuTableViewCell *countryCell = (KGSubMenuTableViewCell *) cell;
            countryCell.countryLabel.text = [[[self.countryArr objectAtIndex:self.currContinentIndex] objectForKey:kCountryKey] objectAtIndex:indexPath.row];
        }
    } else if (self.currTapIndex == 2) {
        cell = [tableView dequeueReusableCellWithIdentifier:kTimeTableViewCell];
        if (cell == nil) {
            NSArray *nibArr = [[NSBundle mainBundle] loadNibNamed:@"KGCommonConditionCell" owner:self options:nil];
            cell = [nibArr objectAtIndex:0];
            KGCommonConditionCell *timeCell = (KGCommonConditionCell *) cell;
            timeCell.timeLabel.text = [self.timeArr objectAtIndex: [indexPath row]];
            if (indexPath.row == self.timeArr.count - 1) {
                timeCell.splitLine.hidden = YES;
            }
        }
    } else if (self.currTapIndex == 3) {
        if (tableView.tag == 1) {
            cell = [tableView dequeueReusableCellWithIdentifier:kLeftTableViewCell];
            if (cell == nil) {
                NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGMainMenuTableViewCell" owner:self options:nil];
                cell = [nibArr objectAtIndex:0];
            }
            KGMainMenuTableViewCell *continentCell = (KGMainMenuTableViewCell *) cell;
            continentCell.continentLabel.text = [[self.cityArr objectAtIndex:[indexPath row]] objectForKey:kRegionKey];
        } else if (tableView.tag == 2) {
            cell = [tableView dequeueReusableCellWithIdentifier:kRightTableViewCell];
            if (cell == nil) {
                NSArray *nibArr = [[NSBundle mainBundle]loadNibNamed:@"KGSubMenuTableViewCell" owner:self options:nil];
                cell = [nibArr objectAtIndex:0];
            }
            KGSubMenuTableViewCell *countryCell = (KGSubMenuTableViewCell *) cell;
            countryCell.countryLabel.text = [[[self.cityArr objectAtIndex:self.currRegionIndex] objectForKey:kCityKey] objectAtIndex:indexPath.row];
        }
    }
    cell.selectedBackgroundView = [[UIView alloc] initWithFrame:cell.frame];
    cell.selectedBackgroundView.backgroundColor = [UIColor whiteColor];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger row = indexPath.row;
    NSInteger selectedIndex = self.currTapIndex;
    if (selectedIndex == 1) {
        if (tableView.tag == 1) {
            NSLog(@"item-%d is: %@", row, [[self.countryArr objectAtIndex:row] objectForKey:kContinentKey]);
            self.currContinentIndex = row;
            UIView *currView = [self.conditionViews objectForKey:@(selectedIndex)];
            if ([currView respondsToSelector:@selector(subMenuTableView)]) {
                UITableView *subTable = [currView performSelector:@selector(subMenuTableView) withObject:currView];
                [subTable reloadData];
            }
        } else if (tableView.tag == 2) {
            [self closeConditionView:selectedIndex];
            NSString *selectCountry = [[[self.countryArr objectAtIndex:self.currContinentIndex] objectForKey:kCountryKey] objectAtIndex:row];
            KGConditionBarItem *currItem = (KGConditionBarItem *)[self viewWithTag:selectedIndex];
            currItem.textLabel.text = selectCountry;
            [currItem relayout];
            [self.delegate didSelectCondition:selectedIndex item:selectCountry];
        }
    } else if (selectedIndex == 2) {
        [self closeConditionView:selectedIndex];
        NSString *selectTime = [self.timeArr objectAtIndex:row];
        KGConditionBarItem *currItem = (KGConditionBarItem *)[self viewWithTag:selectedIndex];

        currItem.textLabel.text = selectTime;
        [currItem relayout];
        [self.delegate didSelectCondition:selectedIndex item:selectTime];
    } else if (selectedIndex == 3) {
        if (tableView.tag == 1) {
            NSLog(@"item%d is: %@", row, [[self.cityArr objectAtIndex:row] objectForKey:kRegionKey]);
            self.currRegionIndex = row;
            UIView *currView = [self.conditionViews objectForKey:@(selectedIndex)];
            if ([currView respondsToSelector:@selector(subMenuTableView)]) {
                UITableView *subTable = [currView performSelector:@selector(subMenuTableView) withObject:currView];
                [subTable reloadData];
            }
        } else if (tableView.tag == 2) {
            [self closeConditionView:selectedIndex];
            NSString *selectCity = [[[self.cityArr objectAtIndex:self.currRegionIndex] objectForKey:kCityKey] objectAtIndex:row];
            KGConditionBarItem *currItem = (KGConditionBarItem *)[self viewWithTag:selectedIndex];

            currItem.textLabel.text = selectCity;
            [currItem relayout];
            [self.delegate didSelectCondition:selectedIndex item:selectCity];
        }
    }
    
}


@end
