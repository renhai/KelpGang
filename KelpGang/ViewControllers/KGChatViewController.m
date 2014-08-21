//
//  KGChatViewController.m
//  KelpGang
//
//  Created by Andy on 14-3-8.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGChatViewController.h"
#import "KGChatTextField.h"
#import "KGChatCellInfo.h"
#import "XMPPManager.h"
#import "KGChatTxtMessageCell.h"
#import "KGCreateOrderController.h"

static const CGFloat kMaxChatTextViewHeight = 99.0;
static const NSInteger kHeaderTipViewTag = 1;
static const NSInteger kHeaderRefreshViewTag = 2;


@interface KGChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet KGChatTextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

@property (nonatomic, strong) NSMutableArray *chatCellInfoArr;
@property (nonatomic, assign) CGFloat currKeyboardHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *taskList;
@property (nonatomic, strong) UIView *taskView;
@property (nonatomic, assign) BOOL taskViewDisplay;

@end

@implementation KGChatViewController

- (void)dealloc
{
    NSLog(@"KGChatViewController dealloc");
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
    [self setLeftBarbuttonItem];
    [self setTitle:@"myrenhai"];
    self.chatCellInfoArr = [[NSMutableArray alloc] init];
    [self mockData];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-view-background"]];
    [self initHeaderView];
    [self initTopView];
    [self initChatTextField];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.chatCellInfoArr && self.chatCellInfoArr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatCellInfoArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.chatTextField resignFirstResponder];
    [self.chatTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)mockData {
    KGMessageObject *obj1 = [[KGMessageObject alloc]init];
    obj1.content = @"帮带的东西很好，希望还能继续合作，剩了不少钱，还是海带划算啊。。。。";
    obj1.type = MessageTypeOther;
    obj1.date = [NSDate dateWithTimeInterval:-200 sinceDate:[NSDate date]];
    KGChatCellInfo *chatCellInfo1 = [[KGChatCellInfo alloc] initWithMessage:obj1];

    KGMessageObject *obj2 = [[KGMessageObject alloc]init];
    obj2.content = @"剩了不少钱，还是海带划算啊";
    obj2.type = MessageTypeOther;
    obj2.date = [NSDate dateWithTimeInterval:-150 sinceDate:[NSDate date]];
    KGChatCellInfo *chatCellInfo2 = [[KGChatCellInfo alloc] initWithMessage:obj2];

    KGMessageObject *obj3 = [[KGMessageObject alloc]init];
    obj3.content = @"剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱";
    obj3.type = MessageTypeMe;
    obj3.date = [NSDate dateWithTimeInterval:-100 sinceDate:[NSDate date]];
    KGChatCellInfo *chatCellInfo3 = [[KGChatCellInfo alloc] initWithMessage:obj3];

    [self.chatCellInfoArr addObject:chatCellInfo1];
    [self.chatCellInfoArr addObject:chatCellInfo2];
    [self.chatCellInfoArr addObject:chatCellInfo3];

    [self handleShowTime:self.chatCellInfoArr];
}

- (void)handleShowTime: (NSMutableArray *)msgArr {
    if (!msgArr) {
        return;
    }
    NSString *preTime = nil;
    for (KGChatCellInfo *chatCellInfo in msgArr) {
        chatCellInfo.showTime = ![preTime isEqualToString:chatCellInfo.time];
        preTime = chatCellInfo.time;
    }
}

- (void)initChatTextField {
    self.chatTextField.layer.cornerRadius = self.chatTextView.height / 2;
    self.chatTextField.layer.borderWidth = LINE_HEIGHT;
    self.chatTextField.layer.borderColor = RGBCOLOR(211, 220, 224).CGColor;
    self.chatTextField.hidden = NO;
    self.chatTextField.inputAccessoryView = [[UIView alloc] init];

    self.chatTextView.layer.cornerRadius = 10;
    self.chatTextView.layer.borderWidth = LINE_HEIGHT;
    self.chatTextView.layer.borderColor = RGBCOLOR(211, 220, 224).CGColor;
    self.chatTextView.hidden = YES;
    self.chatTextField.inputAccessoryView = [[UIView alloc] init];
}

-(void)initHeaderView {
    UIView *headerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 60)];

    UIView *tipView = [[UIView alloc] initWithFrame:CGRectMake(81, 15, 158, 30)];
    tipView.tag = kHeaderTipViewTag;
    tipView.backgroundColor = RGBACOLOR(0, 0, 0, 0.12);
    tipView.layer.cornerRadius = 4;
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    topLabel.backgroundColor = [UIColor clearColor];
    topLabel.text = @"可以开始聊天了";
    topLabel.textColor = [UIColor whiteColor];
    topLabel.font = [UIFont systemFontOfSize:10];
    [topLabel sizeToFit];
    [topLabel setTop:2];
    [topLabel setLeft:(tipView.width - topLabel.width) / 2.0];
    [tipView addSubview:topLabel];
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectZero];
    bottomLabel.backgroundColor = [UIColor clearColor];
    bottomLabel.text = @"别忘了填写商品信息生成订单哦";
    bottomLabel.textColor = [UIColor whiteColor];
    bottomLabel.font = [UIFont systemFontOfSize:10];
    [bottomLabel sizeToFit];
    [bottomLabel setTop:topLabel.bottom + 2];
    [bottomLabel setLeft:(tipView.width - bottomLabel.width) / 2.0];
    [tipView addSubview:bottomLabel];
    [tipView setHeight:bottomLabel.bottom + 2];

    UIActivityIndicatorView *indicatorView = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle: UIActivityIndicatorViewStyleGray];
    indicatorView.tag = kHeaderRefreshViewTag;
    indicatorView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin |UIViewAutoresizingFlexibleBottomMargin
    | UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin;
    indicatorView.top = (headerView.height - indicatorView.height) / 2;
    indicatorView.left = (headerView.width - indicatorView.width) / 2;

    [headerView addSubview:tipView];
    [headerView addSubview:indicatorView];
    self.headerView = headerView;
    self.tableView.tableHeaderView = self.headerView;
}

- (void)initTopView {
    UIButton *topButton = [[UIButton alloc] initWithFrame:self.topView.frame];
    [topButton setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.12)] forState:UIControlStateHighlighted];
    topButton.backgroundColor = RGB(246, 251, 249);
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"从我的任务选择";
    label.textColor = MAIN_COLOR;
    label.font = [UIFont systemFontOfSize:16];
    label.backgroundColor = CLEARCOLOR;
    [label sizeToFit];
    label.width = 270;
    [label setLeft:15];
    [label setCenterY:self.topView.height / 2];
    label.tag = 1002;
    [topButton addSubview:label];

    UIImageView *arrowView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"down-arrow-big"]];
    arrowView.centerY = self.topView.height / 2;
    arrowView.right = self.topView.width - 15;
    arrowView.tag = 1003;
    [topButton addSubview:arrowView];

    UIView *bottomLine = [KGUtils seperatorWithFrame:CGRectMake(0, topButton.height - LINE_HEIGHT, topButton.width, LINE_HEIGHT)];
    [topButton addSubview:bottomLine];

    [topButton addTarget:self action:@selector(tapTopView:) forControlEvents:UIControlEventTouchUpInside];
    topButton.tag = 1001;
    [self.topView addSubview:topButton];
}

- (void)tapTopView:(UIButton *) sender {
    CGFloat itemHeight = 35.0;
    if (self.taskViewDisplay) {
        [self.taskView removeFromSuperview];
        self.taskView = nil;
        self.taskViewDisplay = NO;
        UIImageView *arrowView = (UIImageView *)[self.topView viewWithTag:1003];
        arrowView.image = [UIImage imageNamed:@"down-arrow-big"];
    } else {
        NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                                 @"session_key": APPCONTEXT.currUser.sessionKey};
        [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
        [[KGNetworkManager sharedInstance]postRequest:@"/mobile/task/getTasks" params:params success:^(id responseObject) {
            DLog(@"%@", responseObject);
            [[HudHelper getInstance] hideHudInView:self.view];
            if ([KGUtils checkResult:responseObject]) {
                NSDictionary *data = responseObject[@"data"];
                self.taskList = data[@"task_info"];
                if (!self.taskList || self.taskList.count == 0) {
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"请先创建一个任务" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
                    [alert show];
                    return ;
                }
                CGFloat currY = 0;
                CGFloat containerHeight = MIN([self.taskList count] * itemHeight, 5 * itemHeight);
                UIScrollView *container = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, self.tableView.width, containerHeight)];
                container.scrollEnabled = YES;
                container.contentSize = CGSizeMake(self.tableView.width, [self.taskList count] * itemHeight);
                container.backgroundColor = RGB(246, 251, 249);
                container.opaque = NO;
                container.alpha = 0.95;
                for (NSInteger i = 0; i < self.taskList.count; i ++) {
                    NSDictionary *item = self.taskList[i];
                    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, currY, self.tableView.width, itemHeight)];
                    [button setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.12)] forState:UIControlStateHighlighted];
                    UIView *line = [KGUtils seperatorWithFrame:CGRectMake(0, button.height - LINE_HEIGHT, button.width, LINE_HEIGHT)];
                    [button addSubview:line];
                    UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
                    label.text = item[@"title"];
                    label.font = [UIFont systemFontOfSize:16];
                    label.textColor = RGBCOLOR(114, 114, 114);
                    label.backgroundColor = CLEARCOLOR;
                    [label sizeToFit];
                    label.width = 280;
                    label.left = 20;
                    label.centerY = itemHeight / 2;
                    [button addSubview:label];
                    currY += itemHeight;
                    button.tag = i;
                    [button addTarget:self action:@selector(tapTaskItem:) forControlEvents:UIControlEventTouchUpInside];
                    [container addSubview:button];
                }
                container.top = self.topView.bottom;
                self.taskView = container;
                [self.view addSubview:self.taskView];
                self.taskViewDisplay = YES;
                UIImageView *arrowView = (UIImageView *)[self.topView viewWithTag:1003];
                arrowView.image = [UIImage imageNamed:@"up-arrow-big"];
            }
        } failure:^(NSError *error) {
            DLog(@"%@", error);
            [[HudHelper getInstance] showHudOnView:self.view caption:@"系统错误,请稍后再试" image:nil acitivity:NO autoHideTime:1.6];

        }];

    }
}

- (void)tapTaskItem:(UIButton *)sender {
    NSLog(@"selected task index: %i, item: %@", sender.tag, self.taskList[sender.tag]);
    [self.taskView removeFromSuperview];
    self.taskView = nil;
    self.taskViewDisplay = NO;
    UIImageView *arrowView = (UIImageView *)[self.topView viewWithTag:1003];
    arrowView.image = [UIImage imageNamed:@"right-arrow"];
    [arrowView sizeToFit];
    arrowView.centerY = self.topView.height / 2;

    NSDictionary *item = self.taskList[sender.tag];
    UIButton *topButton = (UIButton *)[self.topView viewWithTag:1001];
    UILabel *label = (UILabel *)[topButton viewWithTag:1002];
    label.text = item[@"title"];
    [topButton removeTarget:self action:@selector(tapTopView:) forControlEvents:UIControlEventTouchUpInside];
    [topButton addTarget:self action:@selector(createOrderAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createOrderAction: (UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"order" bundle:nil];
    KGCreateOrderController *controller = [board instantiateViewControllerWithIdentifier:@"kCreateOrderController"];
    controller.title = @"创建订单";
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.chatCellInfoArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
//    UITableViewCell *cell;
//    cell = [tableView dequeueReusableCellWithIdentifier:@"kChatMessageOtherCell"];
//    if (!cell) {
//        cell = [[KGChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kChatMessageOtherCell"];
//    }
//    cell.backgroundColor = [UIColor clearColor];
//    KGChatTextMessageCell *mCell = (KGChatTextMessageCell *)cell;

    KGChatTxtMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kChatTxtMessageCell" forIndexPath:indexPath];
    KGChatCellInfo *chatCellInfo = self.chatCellInfoArr[indexPath.row];
    [cell configCell:chatCellInfo];

    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGChatCellInfo *msgObj = self.chatCellInfoArr[indexPath.row];
    return msgObj.cellHeight;
}

#pragma mark - 键盘处理
- (void)keyBoardWillShow:(NSNotification *)note{
    CGRect beginRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"**** %@, %@ ****", NSStringFromCGRect(beginRect), NSStringFromCGRect(endRect));
    self.currKeyboardHeight = endRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.bottomView setTop:self.view.height - self.bottomView.height - endRect.size.height];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, endRect.size.height, 0)];
        if (self.chatCellInfoArr && self.chatCellInfoArr.count > 0) {
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatCellInfoArr.count - 1 inSection:0];
            [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        }

    }];

}
#pragma mark 键盘即将退出
- (void)keyBoardWillHide:(NSNotification *)note{
    self.currKeyboardHeight = 0;
    CGRect beginRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGFloat ty = - beginRect.size.height;
    NSLog(@"#### %f ####", ty);
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.bottomView setTop:self.bottomView.top - ty];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, self.tableView.contentInset.bottom + ty, 0)];
    }];
}


#pragma UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField {
    return YES;
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    KGMessageObject *obj = [[KGMessageObject alloc]init];
    obj.content = textField.text;
    obj.type = MessageTypeMe;
    obj.date = [NSDate date];
    KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
    chatCellInfo.showIndicator = NO;
    [self.chatCellInfoArr addObject:chatCellInfo];

    [self handleShowTime:self.chatCellInfoArr];

    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatCellInfoArr.count - 1 inSection:0];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
    //碰到一个很奇怪的问题，在7.1环境会闪一下
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionNone animated:YES];

    NSString *myJID = [NSString stringWithFormat:@"%d@%@", APPCONTEXT.currUser.uid, kChatHostName];
    NSString *toJID = [NSString stringWithFormat:@"%d@%@", 2, kChatHostName];
    XMPPElement *body = [XMPPElement elementWithName:@"body"];
    [body setStringValue:textField.text];
    XMPPElement *mes = [XMPPElement elementWithName:@"message"];
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    [mes addAttributeWithName:@"to" stringValue:toJID];
    [mes addAttributeWithName:@"from" stringValue:myJID];
    [mes addChild:body];
    
    [[XMPPManager sharedInstance] sendMessage:mes];

    textField.text = @"";
    return YES;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)textChanged:(NSNotification *) note {
    NSLog(@"******* contentSize height: %f", self.chatTextView.contentSize.height);
    CGSize newSize = [self.chatTextView.text sizeWithFont:self.chatTextView.font constrainedToSize:CGSizeMake(self.chatTextView.width,9999) lineBreakMode:NSLineBreakByWordWrapping];
    NSLog(@"!!!!! newSize: %@", NSStringFromCGSize(newSize));
    CGFloat contentHeight = newSize.height + 16;
    if (![self.chatTextView.text isEqualToString:@""] && contentHeight <= kMaxChatTextViewHeight) {
        self.chatTextView.height = contentHeight;
        self.bottomView.height = self.chatTextView.height + 21;
        self.bottomView.top = self.view.height - self.bottomView.height - self.currKeyboardHeight;
    }
}

#pragma UITextViewDelegate

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    if ([text isEqualToString:@"\n"]) {
        KGMessageObject *obj = [[KGMessageObject alloc]init];
        obj.content = textView.text;
        obj.type = MessageTypeMe;
        KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
        [self.chatCellInfoArr addObject:chatCellInfo];
        [self.tableView beginUpdates];
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatCellInfoArr.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionNone animated:YES];
        textView.text = @"";

        self.chatTextView.height = 33;
        self.bottomView.height = 54;
        self.bottomView.top = self.view.height - self.bottomView.height - self.currKeyboardHeight;
        return NO;
    }
    return YES;
}


- (void)newMsgCome:(NSNotification *)notifacation {
    KGChatCellInfo *chatCellInfo = notifacation.object;
    [self.chatCellInfoArr addObject:chatCellInfo];
    [self handleShowTime:self.chatCellInfoArr];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatCellInfoArr.count - 1 inSection:0];
//    [self.tableView beginUpdates];
//    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationNone];
//    [self.tableView endUpdates];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

//- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
//    DLog(@"%@", scrollView);
//    LOGBOOL(decelerate);
//    if (scrollView.contentOffset.y <= 0) {
//
//    }
//}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DLog("%@", scrollView);
    if (scrollView.contentOffset.y <= 0) {
        [self handleRefresh];
    }
}

- (void)addChatMessages:(NSArray *)moreMsgs completion:(void (^)(void))completionBlock {
    [self.chatCellInfoArr insertObjects:moreMsgs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, moreMsgs.count)]];

    [self.tableView reloadData];

    if (completionBlock) {
        completionBlock();
    }

    return;
}

- (void)handleRefresh {
    UIActivityIndicatorView *refreshView = (UIActivityIndicatorView *)[self.headerView viewWithTag:kHeaderRefreshViewTag];
    if (!refreshView.isAnimating) {
        [self startRefresh];
        [self performSelector:@selector(loadData) withObject:nil afterDelay:1.0];
    }
}

- (void)loadData {
    NSMutableArray *moreMsgs = [[NSMutableArray alloc] init];
    for (NSInteger i = 0; i < 10; i ++) {
        KGMessageObject *obj = [[KGMessageObject alloc]init];
        obj.content = [NSString stringWithFormat:@"%i,帮带的东西很好%i", i, arc4random()];
        obj.type = i % 2;
        obj.date = [NSDate dateWithTimeInterval:-100*i sinceDate:[NSDate date]];
        KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
        [moreMsgs addObject:chatCellInfo];
    }
    [self handleShowTime:moreMsgs];

    CGSize contentSize = self.tableView.contentSize;
    __weak typeof (self) weakSelf = self;
    [self addChatMessages:moreMsgs completion:^ {
        CGFloat diffV = weakSelf.tableView.contentSize.height - contentSize.height;
        if (diffV > 0) {
            weakSelf.tableView.contentOffset = CGPointMake(weakSelf.tableView.contentOffset.x, weakSelf.tableView.contentOffset.y + diffV);
        }
        [weakSelf stopRefresh];
    }];
}

- (void)startRefresh {
    UIView *tipView = [self.headerView viewWithTag:kHeaderTipViewTag];
    tipView.hidden = YES;

    UIActivityIndicatorView *refreshView = (UIActivityIndicatorView *)[self.headerView viewWithTag:kHeaderRefreshViewTag];
    [refreshView startAnimating];
}

- (void)stopRefresh {
    UIView *tipView = [self.headerView viewWithTag:kHeaderTipViewTag];
    tipView.hidden = NO;

    UIActivityIndicatorView *refreshView = (UIActivityIndicatorView *)[self.headerView viewWithTag:kHeaderRefreshViewTag];
    [refreshView stopAnimating];
}

@end
