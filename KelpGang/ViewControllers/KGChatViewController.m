//
//  KGChatViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatViewController.h"
#import "KGChatTipCell.h"
#import "KGChatMessageOtherCell.h"


@interface KGChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet UITextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@end

@implementation KGChatViewController

- (void)dealloc
{
    NSLog(@"KGChatViewController dealloc");
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

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
    NAVIGATIONBAR_ADD_DEFAULT_BACKBUTTON_WITH_CALLBACK(goBack:);
    [self.navigationItem setTitle:@"myrenhai"];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-view-background"]];
    [self initGoodsView];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 20;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.row == 0) {
        cell = [[KGChatTipCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kChatTipCell"];
        cell.backgroundColor = [UIColor clearColor];
    } else {
        cell = [[KGChatMessageOtherCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kChatMessageOtherCell"];
        cell.backgroundColor = [UIColor clearColor];
    }
    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row == 0) {
        return 60;
    } else {
        return 60;
    }
}


- (void)initGoodsView {
    UIButton *topView = [[UIButton alloc] initWithFrame:self.topView.frame];
    [topView setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.12)] forState:UIControlStateHighlighted];
    topView.backgroundColor = [UIColor whiteColor];
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"美国版ipad mini 代购，快来大家快来买吧!";
    label.textColor = RGBCOLOR(33, 185, 162);
    label.font = [UIFont systemFontOfSize:16];
    [label sizeToFit];
    [label setWidth:130];
    [label setLeft:15];
    [label setTop:10];
    [topView addSubview:label];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"right-arrow"]];
    [arrowView setTop:13];
    [arrowView setLeft:293];
    [topView addSubview:arrowView];

    [topView addTarget:self action:@selector(tapHeader:) forControlEvents:UIControlEventTouchUpInside];
    [self.topView addSubview:topView];
}

- (void)tapHeader:(UIControl *) controll {
    UIViewController *controller = [[UIViewController alloc]init];
    controller.view.backgroundColor = [UIColor whiteColor];
    [self.navigationController pushViewController:controller animated:YES];
}


#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

#pragma mark - 键盘处理
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect rect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - rect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
    }];

}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
    }];
}


#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
