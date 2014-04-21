//
//  KGTaskListViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskListViewController.h"
#import "KGTaskListViewCell.h"
#import "UIImageView+WebCache.h"
#import "KGMaskView.h"
#import "KGFilterItem.h"
#import "KGFilterBar.h"

@interface KGTaskListViewController () <KGFilterBarDelegate>
@property (weak, nonatomic) IBOutlet UIView *conditionBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic, strong) NSArray *countryArr;
@property (nonatomic, strong) NSArray *cityArr;
@property (nonatomic, strong) NSArray *timeArr;
@property (nonatomic, strong) KGFilterBar *filterBar;

@end

@implementation KGTaskListViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self setLeftBarbuttonItem];
    [self setRightBarButtonItems];

    self.countryArr = @[@{@"firstLevel": @"热门国家",@"secondLevel": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]},
                                     @{@"firstLevel": @"亚洲",@"secondLevel": @[@"日本",@"韩国",@"泰国"]},
                                     @{@"firstLevel": @"欧洲",@"secondLevel": @[@"英国",@"法国",@"意大利",@"德国"]},
                                     @{@"firstLevel": @"非洲",@"secondLevel": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                                     @{@"firstLevel": @"北美洲",@"secondLevel": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                                     @{@"firstLevel": @"南美洲",@"secondLevel": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]},
                                     @{@"firstLevel": @"大洋洲",@"secondLevel": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊", @"八个字的国家啊哈"]}];
    self.cityArr = @[@{@"firstLevel": @"热门城市",@"secondLevel": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                                  @{@"firstLevel": @"华东",@"secondLevel": @[@"石家庄",@"邯郸",@"北京"]},
                                  @{@"firstLevel": @"华北",@"secondLevel": @[@"英国",@"法国",@"意大利",@"德国"]},
                                  @{@"firstLevel": @"华南",@"secondLevel": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                                  @{@"firstLevel": @"西部",@"secondLevel": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                                  @{@"firstLevel": @"其他",@"secondLevel": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
    [self initFilterBar];
}

- (void)initFilterBar {
    CGFloat itemWidth = 320.0 / 3;
    CGFloat itemHeight = self.conditionBar.height - 1;
    KGFilterItem *item1 = [[KGFilterItem alloc] initWithFrame:CGRectMake(0, 0, itemWidth, itemHeight) text:@"目的国家" data: self.countryArr];
    item1.canvasView = self.view;
    item1.index = 0;
    item1.type = KGFilterViewCascadeStyle;

    KGFilterItem *item2 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth, 0, itemWidth, itemHeight) text:@"跑腿费" data:nil];
    item2.canvasView = self.view;
    item2.index = 1;
    item2.type = KGFilterViewCommonStyle;

    KGFilterItem *item3 = [[KGFilterItem alloc] initWithFrame:CGRectMake(itemWidth * 2, 0, itemWidth, itemHeight) text:@"所在城市" data: self.cityArr];
    item3.canvasView = self.view;
    item3.index = 2;
    item3.type = KGFilterViewCascadeStyle;

    KGFilterBar *filterBar = [[KGFilterBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 37) items:@[item1, item2, item3]];
    filterBar.delegate = self;
    self.filterBar = filterBar;
    [self.conditionBar addSubview:self.filterBar];
}

- (void)setRightBarButtonItems {
    if (![KGUtils isHigherIOS7]) {
        UIBarButtonItem *negativeSpacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFixedSpace target:nil action:nil];
        negativeSpacer.width = 15;
        self.navigationItem.rightBarButtonItems = @[negativeSpacer, self.rightBarButtonItem];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.filterBar closeCurrFilterView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *CellIdentifier = @"kTaskListTableViewCell";

    KGTaskListViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[KGTaskListViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    cell.headImageView.clipsToBounds = YES;
    cell.headImageView.ContentMode = UIViewContentModeScaleAspectFill;
    cell.headImageView.layer.cornerRadius = cell.headImageView.frame.size.width / 2;
    [cell.headImageView setImageWithURL:[NSURL URLWithString:@"http://b.hiphotos.baidu.com/image/w%3D2048/sign=828c8a708544ebf86d71633fedc1d62a/5882b2b7d0a20cf4d8414dac74094b36adaf99f4.jpg"] placeholderImage:[UIImage imageNamed:@"test-head.jpg"]];
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


#pragma KGFilterBarDelegate

- (void) didSelectFilter:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
