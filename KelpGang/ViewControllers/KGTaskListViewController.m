//
//  KGTaskListViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-17.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGTaskListViewController.h"
#import "KGConditionBar.h"
#import "KGTaskListViewCell.h"
#import "UIImageView+WebCache.h"
#import "KGMaskView.h"

@interface KGTaskListViewController () <KGConditionDelegate>
@property (weak, nonatomic) IBOutlet KGConditionBar *conditionBar;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *rightBarButtonItem;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

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
    [self setRightBarButtonItems];

    self.conditionBar.canvasView = self.view;
    self.conditionBar.delegate = self;

    self.conditionBar.countryArr = @[@{@"continent": @"热门国家",@"country": @[@"日本",@"韩国",@"美国",@"法国",@"意大利",@"德国",@"加拿大",@"澳大利亚",@"泰国"]},
                                     @{@"continent": @"亚洲",@"country": @[@"日本",@"韩国",@"泰国"]},
                                     @{@"continent": @"欧洲",@"country": @[@"英国",@"法国",@"意大利",@"德国"]},
                                     @{@"continent": @"非洲",@"country": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                                     @{@"continent": @"北美洲",@"country": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                                     @{@"continent": @"南美洲",@"country": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]},
                                     @{@"continent": @"大洋洲",@"country": @[@"澳大利亚",@"新西兰",@"六个字的国家",@"七个字的国家啊", @"八个字的国家啊哈"]}];
    self.conditionBar.cityArr = @[@{@"region": @"热门城市",@"city": @[@"北京",@"上海",@"广州",@"深圳",@"武汉",@"长春",@"东莞",@"吉林",@"延吉"]},
                                  @{@"region": @"华东",@"city": @[@"石家庄",@"邯郸",@"北京"]},
                                  @{@"region": @"华北",@"city": @[@"英国",@"法国",@"意大利",@"德国"]},
                                  @{@"region": @"华南",@"city": @[@"南非",@"埃及",@"阿尔及利亚",@"刚果"]},
                                  @{@"region": @"西部",@"city": @[@"美国",@"加拿大",@"墨西哥",@"哥斯达黎加"]},
                                  @{@"region": @"其他",@"city": @[@"巴西",@"阿根廷",@"哥伦比亚",@"厄瓜多尔",@"委内瑞拉",@"乌拉圭"]}];
    self.conditionBar.timeArr = @[@"10%", @"20%", @"30%", @"40%", @"50%"];
    self.conditionBar.titles = @[@"目的国家", @"跑腿费", @"所在城市"];
    [self.conditionBar initBarItems];

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
    [self.conditionBar closeCurrPopView];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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


#pragma KGConditionDelegate

- (void) didSelectCondition:(NSInteger)index item: (NSString *) item {
    NSLog(@"selected index: %d, item : %@", index, item);
}

@end
