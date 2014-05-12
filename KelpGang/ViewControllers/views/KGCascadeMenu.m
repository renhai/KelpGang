//
//  KGCascadeMenu.m
//  KelpGang
//
//  Created by Andy on 14-4-4.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGCascadeMenu.h"
#import "KGCascadeMenuLeftCell.h"
#import "KGCascadeMenuRightCell.h"

static NSString * const kContinentKey = @"firstLevel";
static NSString * const kCountryKey = @"secondLevel";

@interface KGCascadeMenu () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) UITableView *leftTable;
@property (nonatomic, strong) UITableView *rightTable;
@property (nonatomic, strong) NSArray *data;
@property (nonatomic, assign) NSInteger currContinentIndex;

@end

@implementation KGCascadeMenu

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (id)initWithFrame:(CGRect)frame data: (NSArray *)data {
    self = [self initWithFrame:frame];
    if (self) {
        self.currContinentIndex = 0;
        self.data = data;
        self.leftTable = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, 140, frame.size.height) style:UITableViewStylePlain];
        self.leftTable.delegate = self;
        self.leftTable.dataSource = self;
        self.leftTable.backgroundColor = RGBCOLOR(233, 243, 243);
        self.leftTable.separatorStyle = UITableViewCellSeparatorStyleNone;
        NSIndexPath *firstRow= [NSIndexPath indexPathForRow:0 inSection:0];
        [self.leftTable selectRowAtIndexPath:firstRow animated:NO scrollPosition:UITableViewScrollPositionNone];
        [self tableView:self.leftTable didSelectRowAtIndexPath:firstRow];
        [self addSubview:self.leftTable];

        self.rightTable = [[UITableView alloc]initWithFrame:CGRectMake(140, 0, 180, frame.size.height) style:UITableViewStylePlain];
        self.rightTable.delegate = self;
        self.rightTable.dataSource = self;
        self.rightTable.separatorStyle = UITableViewCellSeparatorStyleNone;

        [self addSubview:self.rightTable];
    }
    return self;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.leftTable) {
        return [self.data count];
    } else if (tableView == self.rightTable) {
        NSDictionary *dic = [self.data objectAtIndex:self.currContinentIndex];
        return [[dic objectForKey:kCountryKey] count];
    }
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *leftTableViewCellReuseId = @"kCascadeMenuLeftTableViewCell";
    static NSString *rightTableViewCellReuseId = @"kCascadeMenuRightTableViewCell";

    UITableViewCell *cell;

    if (tableView == self.leftTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:leftTableViewCellReuseId];
        if (!cell) {
            cell = [[KGCascadeMenuLeftCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:leftTableViewCellReuseId];
        }
        KGCascadeMenuLeftCell *leftCell = (KGCascadeMenuLeftCell *)cell;
        [leftCell setLabelText:self.data[indexPath.row][kContinentKey]];
    } else if (tableView == self.rightTable) {
        cell = [tableView dequeueReusableCellWithIdentifier:rightTableViewCellReuseId];
        if (!cell) {
            cell = [[KGCascadeMenuRightCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:rightTableViewCellReuseId];
        }
        KGCascadeMenuRightCell *rightCell = (KGCascadeMenuRightCell *)cell;
        NSArray *cArr = [self.data[self.currContinentIndex] objectForKey:kCountryKey];
        [rightCell setLabelText:cArr[indexPath.row]];
    }
    return cell;
}

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (tableView == self.leftTable) {
        self.currContinentIndex = indexPath.row;
        [self.rightTable reloadData];
    } else if (tableView == self.rightTable) {
        UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        KGCascadeMenuRightCell *rightCell = (KGCascadeMenuRightCell *)cell;
        [self.delegate didSelectFilterViewCell:[rightCell labelText]];
    }

}


@end
