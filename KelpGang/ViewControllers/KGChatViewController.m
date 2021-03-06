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
#import "IQKeyboardManager.h"
#import "KGTaskObject.h"
#import "FMDB.h"
#import "KGRecentContactObject.h"

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

@property (nonatomic, strong) NSMutableArray *datasource;
@property (nonatomic, assign) CGFloat currKeyboardHeight;
@property (nonatomic, strong) UIView *headerView;
@property (nonatomic, strong) NSMutableArray *taskList;
@property (nonatomic, strong) UIView *taskView;
@property (nonatomic, assign) BOOL taskViewDisplay;
@property (nonatomic, assign) NSInteger currSelectedTaskId;
@property (nonatomic, assign) BOOL hasMore;

@property (nonatomic, strong) NSString *toUserHeadUrl;
@property (nonatomic, strong) NSString *toUserName;
@property (nonatomic, assign) Gender toUserGender;



@end

@implementation KGChatViewController

- (void)dealloc
{
    NSLog(@"KGChatViewController dealloc");
    [self finishObserveObjectProperty];
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
    self.datasource = [[NSMutableArray alloc] init];
    self.hasMore = YES;
    [[XMPPManager sharedInstance] connect];
    [self startObserveObjectProperty];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-view-background"]];
    [self initHeaderView];
    [self initTopView];
    [self initChatTextField];

    [self queryUserInfo];
    [self queryTaskInfo];

    [self loadLatestMessage];
}

- (void)queryUserInfo {
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"host_id": @(self.toUserId)};
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/user/getUser2" params: params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResult:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            self.toUserName = [data valueForKeyPath:@"user_info.user_name"];
            self.toUserHeadUrl = [data valueForKeyPath:@"user_info.head_url"];
            NSString *genderStr = [data valueForKeyPath:@"user_info.user_sex"];
            self.toUserGender = [KGUtils convertGender:genderStr];
            [self setValue:self.toUserHeadUrl forKey:@"toUserHeadUrl"];
            [self setTitle:self.toUserName];
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];
}

- (void)queryTaskInfo {
    self.taskList = [[NSMutableArray alloc]init];
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey};
    [[KGNetworkManager sharedInstance]postRequest:@"/mobile/task/getTasks" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        if ([KGUtils checkResult:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            NSArray *taskInfo = data[@"task_info"];
            if (taskInfo) {
                for (NSDictionary *dic in taskInfo) {
                    KGTaskObject *task = [[KGTaskObject alloc]init];
                    task.taskId = [dic[@"taskId"] integerValue];
                    task.title = dic[@"title"];
                    @synchronized(self.taskList) {
                        [self.taskList addObject:task];
                    }
                }
            }
        }
    } failure:^(NSError *error) {
        DLog(@"%@", error);
    }];

}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.datasource && self.datasource.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    [[IQKeyboardManager sharedManager] setEnable:NO];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.chatTextField resignFirstResponder];
    [self.chatTextView resignFirstResponder];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    [[IQKeyboardManager sharedManager] setEnable:YES];
}

- (void)handleShowTime: (NSMutableArray *)msgArr {
    if (!msgArr) {
        return;
    }
    NSString *preTime = nil;
    for (KGChatCellInfo *chatCellInfo in msgArr) {
        chatCellInfo.showTime = ![preTime isEqualToString:chatCellInfo.time];
        preTime = chatCellInfo.time;

        if (chatCellInfo.cellType == Other) {
            chatCellInfo.headUrl = self.toUserHeadUrl ? self.toUserHeadUrl : @"";
        } else {
            chatCellInfo.headUrl = APPCONTEXT.currUser.avatarUrl;
        }
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
    self.chatTextView.inputAccessoryView = [[UIView alloc] init];
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
        @synchronized (self.taskList) {
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
                KGTaskObject *item = self.taskList[i];
                UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, currY, self.tableView.width, itemHeight)];
                [button setBackgroundImage:[UIImage imageWithColor:RGBACOLOR(0, 0, 0, 0.12)] forState:UIControlStateHighlighted];
                UIView *line = [KGUtils seperatorWithFrame:CGRectMake(0, button.height - LINE_HEIGHT, button.width, LINE_HEIGHT)];
                [button addSubview:line];
                UILabel *label = [[UILabel alloc]initWithFrame:CGRectZero];
                label.text = item.title;
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
    }
}

- (void)tapTaskItem:(UIButton *)sender {
    KGTaskObject *item = self.taskList[sender.tag];
    self.currSelectedTaskId = item.taskId;
    NSLog(@"selected task index: %d, taskId: %d", sender.tag, item.taskId);
    [self.taskView removeFromSuperview];
    self.taskView = nil;
    self.taskViewDisplay = NO;
    UIImageView *arrowView = (UIImageView *)[self.topView viewWithTag:1003];
    arrowView.image = [UIImage imageNamed:@"right-arrow"];
    [arrowView sizeToFit];
    arrowView.centerY = self.topView.height / 2;

    UIButton *topButton = (UIButton *)[self.topView viewWithTag:1001];
    UILabel *label = (UILabel *)[topButton viewWithTag:1002];
    label.text = item.title;
    [topButton removeTarget:self action:@selector(tapTopView:) forControlEvents:UIControlEventTouchUpInside];
    [topButton addTarget:self action:@selector(createOrderAction:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)createOrderAction: (UIButton *)sender {
    UIStoryboard *board = [UIStoryboard storyboardWithName:@"order" bundle:nil];
    KGCreateOrderController *controller = [board instantiateViewControllerWithIdentifier:@"kCreateOrderController"];
    controller.title = @"创建订单";
    controller.buyerId = self.toUserId;
    controller.taskId = self.currSelectedTaskId;
    [self.navigationController pushViewController:controller animated:YES];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.datasource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    KGChatTxtMessageCell *cell = [tableView dequeueReusableCellWithIdentifier:@"kChatTxtMessageCell" forIndexPath:indexPath];
    KGChatCellInfo *chatCellInfo = self.datasource[indexPath.row];
    [cell configCell:chatCellInfo];

    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGChatCellInfo *msgObj = self.datasource[indexPath.row];
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
        if (self.datasource && self.datasource.count > 0) {
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0];
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
    // send message
    NSString *uuid = [XMPPStream generateUUID];
    NSString *toJID = [NSString stringWithFormat:@"%d@%@", self.toUserId, kChatHostName];
    XMPPMessage *message = [XMPPMessage messageWithType:@"chat" to:[XMPPJID jidWithString:toJID] elementID:uuid];

    XMPPElement *body = [XMPPElement elementWithName:@"body"];
    [body setStringValue:textField.text];
    [message addChild:body];

    XMPPElement *userinfo = [XMPPElement elementWithName:@"from_user"];
    [userinfo addAttributeWithName:@"from_id" integerValue:APPCONTEXT.currUser.uid];
    [userinfo addAttributeWithName:@"from_name" stringValue:APPCONTEXT.currUser.nickName];
    [userinfo addAttributeWithName:@"from_gender" integerValue:APPCONTEXT.currUser.gender];
    [message addChild:userinfo];

    NSXMLElement *receipt = [NSXMLElement elementWithName:@"request" xmlns:@"urn:xmpp:receipts"];
    [message addChild:receipt];

    [[XMPPManager sharedInstance] sendMessage:message];
    //send message end

    KGMessageObject *obj = [[KGMessageObject alloc]init];
    obj.fromUID = APPCONTEXT.currUser.uid;
    obj.toUID = self.toUserId;
    obj.uuid = uuid;
    obj.message = textField.text;
    obj.createTime = [NSDate date];
    obj.msgType = TEXT;
    obj.hasRead = 1;
    KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
    chatCellInfo.showIndicator = NO;
    [self.datasource addObject:chatCellInfo];

    [self handleShowTime:self.datasource];

    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionNone animated:YES];

    [self saveMessage:obj];

    KGRecentContactObject *recentObj = [[KGRecentContactObject alloc] init];
    recentObj.uid = self.toUserId;
    recentObj.gender = self.toUserGender;
    recentObj.uname = self.toUserName;
    recentObj.lastMsg = textField.text;
    recentObj.lastMsgTime = [NSDate date];
    recentObj.hasRead = 0;
    [self saveOrUpdateRecentContact:recentObj];

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
//    CGSize newSize = [self.chatTextView.text sizeWithFont:self.chatTextView.font constrainedToSize:CGSizeMake(self.chatTextView.width,9999) lineBreakMode:NSLineBreakByWordWrapping];
    
    CGRect newRect = [self.chatTextView.text boundingRectWithSize:CGSizeMake(self.chatTextView.width,9999) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName: self.chatTextView.font} context:nil];
    CGSize newSize = newRect.size;
    
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
        obj.message = textView.text;
        KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
        [self.datasource addObject:chatCellInfo];
        [self.tableView beginUpdates];
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0];
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
    [self.datasource addObject:chatCellInfo];
    [self handleShowTime:self.datasource];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.datasource.count - 1 inSection:0];
    [self.tableView reloadData];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionNone animated:YES];
}

#pragma UIScrollViewDelegate

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
    [self.view endEditing:YES];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    DLog("%@", scrollView);
    if (scrollView.contentOffset.y <= 0) {
        [self handleRefresh];
    }
}

- (void)addChatMessages:(NSArray *)moreMsgs completion:(void (^)(void))completionBlock {
    [self.datasource insertObjects:moreMsgs atIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, moreMsgs.count)]];

    [self.tableView reloadData];

    if (completionBlock) {
        completionBlock();
    }

    return;
}

- (void)handleRefresh {
    if (!self.hasMore) {
        return;
    }
    UIActivityIndicatorView *refreshView = (UIActivityIndicatorView *)[self.headerView viewWithTag:kHeaderRefreshViewTag];
    if (!refreshView.isAnimating) {
        [self startRefresh];
        [self performSelector:@selector(loadMoreMessage) withObject:nil afterDelay:1.0];
    }
}

- (void)loadMoreMessage {
    KGChatCellInfo *firstObj = [self.datasource firstObject];
    NSInteger lastId = firstObj.messageObj.msgId;
    NSArray *moreMsgs = [self queryMessage:lastId];
    if (!moreMsgs || [moreMsgs count] <= 0) {
        self.hasMore = NO;
    }

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

- (void)saveMessage: (KGMessageObject *) msg {
    NSString *dbFilePath = [KGUtils databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return;
    }
    [db setShouldCacheStatements:YES];

    [db executeUpdate:@"INSERT INTO message (uuid, from_uid, to_uid, msg, msg_type, create_time, has_read) VALUES (?,?,?,?,?,?,?)", msg.uuid, @(msg.fromUID), @(msg.toUID), msg.message, @(msg.msgType), msg.createTime, @(msg.hasRead)];

    [db close];

}

- (void)loadLatestMessage {
    NSArray *reverseArray = [self queryMessage:0];
    if (!reverseArray || reverseArray.count == 0) {
        self.hasMore = NO;
        return;
    }
    [self.datasource addObjectsFromArray:reverseArray];
    [self.tableView reloadData];
}

- (NSArray *)queryMessage: (NSInteger)lastId{
    if (lastId == 0) {
        lastId = NSIntegerMax;
    }
    NSMutableArray *resultList = [NSMutableArray new];
    NSString *dbFilePath = [KGUtils databaseFilePath];
    FMDatabase *db = [FMDatabase databaseWithPath:dbFilePath];
    if (![db open]) {
        NSLog(@"数据库打开失败");
        return nil;
    }
    [db setShouldCacheStatements:YES];

    FMResultSet *rs = [db executeQuery:@"select msg_id, uuid, from_uid, to_uid, msg, msg_type, create_time, has_read from message where ((from_uid = ? and to_uid = ?) or (from_uid = ? and to_uid = ?)) and msg_id < ? order by create_time desc limit 10", @(APPCONTEXT.currUser.uid), @(self.toUserId), @(self.toUserId), @(APPCONTEXT.currUser.uid), @(lastId)];

    while ([rs next]) {
        NSInteger msgId = [rs intForColumn:@"msg_id"];
        NSString *uuid = [rs stringForColumn:@"uuid"];
        NSInteger fromId = [rs intForColumn:@"from_uid"];
        NSInteger toId = [rs intForColumn:@"to_uid"];
        NSString *msg = [rs stringForColumn:@"msg"];
        MessageType msgType = [rs intForColumn:@"msg_type"];
        NSDate *createTime = [NSDate dateWithTimeIntervalSince1970:[rs doubleForColumn:@"create_time"]];
        NSInteger hasRead = [rs intForColumn:@"has_read"];

        KGMessageObject *obj = [[KGMessageObject alloc]init];
        obj.msgId = msgId;
        obj.uuid = uuid;
        obj.fromUID = fromId;
        obj.toUID = toId;
        obj.message = msg;
        obj.msgType = msgType;
        obj.createTime = createTime;
        obj.hasRead = hasRead;

        KGChatCellInfo *cellInfo = [[KGChatCellInfo alloc] initWithMessage:obj];
        [resultList addObject:cellInfo];
    }
    [db close];

    [self handleShowTime:resultList];
    NSArray *reverseArray = [[resultList reverseObjectEnumerator] allObjects];
    return reverseArray;
}

#pragma mark - Object Property Observer
- (void)startObserveObjectProperty {
    [self addObserver:self forKeyPath:@"toUserHeadUrl" options:NSKeyValueObservingOptionNew context:nil];
}

- (void)finishObserveObjectProperty {
    [self removeObserver:self forKeyPath:@"toUserHeadUrl"];
}
- (void)observeValueForKeyPath:(NSString *)keyPath
                      ofObject:(id)object
                        change:(NSDictionary *)change
                       context:(void *)context
{
    if ([keyPath isEqual:@"toUserHeadUrl"]) {
        [self handleShowTime:self.datasource];
        [self.tableView reloadData];
    }
}

- (void)saveOrUpdateRecentContact: (KGRecentContactObject *)obj {
    NSString *dbFilePath = [KGUtils databaseFilePath];
    FMDatabaseQueue *queue = [FMDatabaseQueue databaseQueueWithPath:dbFilePath];
    [queue inDatabase:^(FMDatabase *db) {

        FMResultSet *rs = [db executeQuery:@"select id from recent_contact where uid = ?;", @(obj.uid)];
        if ([rs next]) {
            [db executeUpdate:@"UPDATE recent_contact SET uname = ?, last_msg = ?, last_msg_Time = ?, has_read = ?, gender = ? WHERE uid = ?", obj.uname, obj.lastMsg, obj.lastMsgTime, @(obj.hasRead), @(obj.gender), @(obj.uid)];
        } else {
            [db executeUpdate:@"INSERT INTO recent_contact (uid, uname, last_msg, last_msg_Time, has_read, gender) VALUES (?,?,?,?,?,?)", @(obj.uid), obj.uname, obj.lastMsg, obj.lastMsgTime, @(obj.hasRead), @(obj.gender)];
        }
    }];
}

@end
