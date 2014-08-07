//
//  KGDiscoverViewController.m
//  KelpGang
//
//  Created by Andy on 14-8-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGDiscoverViewController.h"
#import "KGDiscoverCell.h"

@interface KGDiscoverViewController ()

@property(nonatomic, strong) NSArray *datasource;

@end

@implementation KGDiscoverViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.datasource = @[@"http://www.geekpics.net/images/2012/09/16/jlR.jpg",
                        @"http://it-eproducts.com/images/3-1347760443.jpg",
                        @"http://i.imgbox.com/adznyVlI.jpg",
                        @"http://img14.poco.cn/mypoco/myphoto/20130303/01/17323654220130303015619030.jpg",
                        @"https://umfgea.bn1.livefilestore.com/y2p05SNB6HWB4lytSmmpSsH8SbSF77FGd8xpeJjcWu9UsLIyhQcsj4RJjYgzNUh8nTYj5XmmKZIHcJEdvfSogY1eG2iBUqpqknIVtee2roboe0/m9.jpg?psid=1",
                        @"http://ww3.sinaimg.cn/large/703be3b1jw1e2yw7ec64xj.jpg",
                        @"http://i1154.photobucket.com/albums/p534/zmingcx/U300S_6.jpg"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.datasource count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGDiscoverCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kDiscoverCell" forIndexPath:indexPath];
    NSString *imageUrl = self.datasource[indexPath.row];
    [cell.pictureView setImageWithURL:[NSURL URLWithString:imageUrl] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    return cell;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 120;
}

#pragma mark - Navigation

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    
}


@end
