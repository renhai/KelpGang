//
//  KGRecentContactsController.m
//  KelpGang
//
//  Created by Andy on 14-4-18.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGRecentContactsController.h"
#import "KGRecentContactsCell.h"
#import "KGRecentContactObject.h"

@interface KGRecentContactsController ()

@property(nonatomic, strong) NSMutableArray *contacts;

@end

@implementation KGRecentContactsController

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
    [self setLeftBarbuttonItem];

    self.contacts = [[NSMutableArray alloc] init];
    [self mockData];

    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)mockData {
    KGRecentContactObject *obj1 = [[KGRecentContactObject alloc]init];
    obj1.uid = 1;
    obj1.uname = @"任海";
    obj1.gender = MALE;
    obj1.headUrl = @"";
    obj1.lastMsg = @"这位朋友特别热心，帮带的东西很好，下次继续合作。";
    obj1.lastMsgTime = [NSDate date];
    obj1.hasRead = NO;
    [self.contacts addObject:obj1];

    KGRecentContactObject *obj2 = [[KGRecentContactObject alloc]init];
    obj2.uid = 2;
    obj2.uname = @"王小花";
    obj2.gender = FEMALE;
    obj2.headUrl = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=d21da2634f4a20a4311e3bc7a46a9822/3b87e950352ac65c81339c02fbf2b21193138a89.jpg";
    obj2.lastMsg = @"这位朋友特别热心";
    obj2.lastMsgTime = [NSDate dateWithTimeIntervalSinceNow:-1000000];
    obj2.hasRead = YES;
    [self.contacts addObject:obj2];

    for (NSInteger i = 0; i < 20; i ++) {
        KGRecentContactObject *obj = [[KGRecentContactObject alloc]init];
        obj.uid = i;
        obj.uname = [NSString stringWithFormat:@"帮帮用户%i", i];
        obj.gender = i % 2;
        obj.headUrl = @"http://b.hiphotos.baidu.com/image/w%3D2048/sign=d21da2634f4a20a4311e3bc7a46a9822/3b87e950352ac65c81339c02fbf2b21193138a89.jpg";
        obj.lastMsg = [NSString stringWithFormat:@"%i这位朋友特别热心，帮带的东西很好，下次继续合作。", i];
        obj.lastMsgTime = [NSDate date];
        obj.hasRead = i % 2;
        [self.contacts addObject:obj];
    }
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.contacts.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *reuseIdentifier = @"kRecentContactsCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:reuseIdentifier];
    if (!cell) {
        cell = [[KGRecentContactsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:reuseIdentifier];
    } else {
        DLog(@"cell reused!!!!!!!!!!!");
    }
    KGRecentContactObject *obj = self.contacts[indexPath.row];
    if ([cell isKindOfClass:[KGRecentContactsCell class]]) {
        [cell performSelector:@selector(configCell:) withObject:obj];
    }
    return cell;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];

    UIViewController *chatViewController = [self.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
    [self.navigationController pushViewController:chatViewController animated:YES];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 68.0;
}


@end
