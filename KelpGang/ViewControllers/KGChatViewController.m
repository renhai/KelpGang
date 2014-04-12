//
//  KGChatViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatViewController.h"
#import "KGChatTextMessageCell.h"
#import "KGChatTextField.h"
#import "KGMessageObject.h"


@interface KGChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet KGChatTextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;

@property (nonatomic, strong) NSMutableArray *messageArr;

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

//    [self mockData];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//TEST
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-view-background"]];
    if (!self.messageArr || self.messageArr.count == 0) {
        [self initHeaderView];
    }

    [self initGoodsView];
    [self initChatTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.messageArr && self.messageArr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)mockData {
    self.messageArr = [[NSMutableArray alloc] init];
    KGMessageObject *obj1 = [[KGMessageObject alloc]init];
    obj1.content = @"帮带的东西很好，希望还能继续合作，剩了不少钱，还是海带划算啊。。。。";
    obj1.type = MessageTypeOther;

    KGMessageObject *obj2 = [[KGMessageObject alloc]init];
    obj2.content = @"剩了不少钱，还是海带划算啊";
    obj2.type = MessageTypeMe;

    KGMessageObject *obj3 = [[KGMessageObject alloc]init];
    obj3.content = @"剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊";
    obj3.type = MessageTypeMe;

    [self.messageArr addObject:obj1];
    [self.messageArr addObject:obj2];
    [self.messageArr addObject:obj3];
}

- (void)initChatTextField {
    self.chatTextField.borderStyle = UITextBorderStyleNone;
    self.chatTextField.layer.cornerRadius = 15;
    self.chatTextField.layer.borderWidth = LINE_HEIGHT;
    self.chatTextField.layer.borderColor = RGBCOLOR(211, 220, 224).CGColor;
}

-(void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(81, 15, 158, 30)];
    view.backgroundColor = RGBACOLOR(0, 0, 0, 0.12);
    view.layer.cornerRadius = 4;

    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.text = @"可以开始聊天了";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:10];
    [topLabel sizeToFit];
    [topLabel setTop:2];
    [topLabel setLeft:(view.width - topLabel.width) / 2.0];
    [view addSubview:topLabel];

    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.text = @"别忘了填写商品信息生成订单哦";
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = [UIFont systemFontOfSize:10];
    [bottomLabel sizeToFit];
    [bottomLabel setTop:topLabel.bottom + 2];
    [bottomLabel setLeft:(view.width - bottomLabel.width) / 2.0];
    [view addSubview:bottomLabel];
    [headerView addSubview:view];

    self.tableView.tableHeaderView = headerView;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.messageArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    cell = [[KGChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kChatMessageOtherCell"];
    cell.backgroundColor = [UIColor clearColor];
    KGChatTextMessageCell *mCell = (KGChatTextMessageCell *)cell;
    KGMessageObject *msgObj = self.messageArr[indexPath.row];
    [mCell configCell:msgObj];

    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGMessageObject *msgObj = self.messageArr[indexPath.row];
    return [self cellHeight:msgObj];
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
    CGRect endRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    CGFloat ty = - endRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformMakeTranslation(0, ty);
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top-ty - self.topView.height, 0, 0, 0)];
    }];

}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    CGRect beginRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat ty = - beginRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        self.view.transform = CGAffineTransformIdentity;
        [self.tableView setContentInset:UIEdgeInsetsMake(self.tableView.contentInset.top + ty + self.topView.height, 0, 0, 0)];
    }];
}


#pragma UITextFieldDelegate

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    KGMessageObject *obj = [[KGMessageObject alloc]init];
    obj.content = textField.text;
    obj.type = MessageTypeMe;
    if (!self.messageArr) {
        self.messageArr = [[NSMutableArray alloc]init];
    }
    [self.messageArr addObject:obj];
    [self.tableView beginUpdates];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.messageArr.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    textField.text = @"";
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

- (CGFloat)cellHeight: (KGMessageObject *) msgObj {
    NSString *content = msgObj.content;
    CGSize constraint = CGSizeMake(kMessageLableMaxWidth, 20000.0f);
    CGSize labelSize = [content sizeWithFont:[UIFont systemFontOfSize:16] constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
    return labelSize.height + kMessageLabelMarginTop + kMessageLabelMarginBottom;
}

@end
