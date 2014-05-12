//
//  KGCommonMenu.m
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCommonMenu.h"
#import "KGCommonMenuCell.h"

@interface KGCommonMenu () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *data;

@end

@implementation KGCommonMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data: (NSArray *)data {
    self = [self initWithFrame:frame];
    if (self) {
        self.data = data;
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, frame.size.width, frame.size.height) style:UITableViewStylePlain];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.tableView.separatorColor = [UIColor clearColor];
        [self addSubview:self.tableView];
    }
    return self;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.data count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *reuseId = @"kCommonMenuCell";
    KGCommonMenuCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (!cell) {
        cell = [[KGCommonMenuCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseId];
        [cell setLabelText:self.data[indexPath.row]];
        if (indexPath.row == self.data.count - 1) {
            cell.bottomLine.hidden = YES;
        }
    }
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGCommonMenuCell *cell = (KGCommonMenuCell *)[tableView cellForRowAtIndexPath:indexPath];
    [self.delegate didSelectFilterViewCell:[cell labelText]];
}

@end
