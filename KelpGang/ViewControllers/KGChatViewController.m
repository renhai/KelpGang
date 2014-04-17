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
#import "KGChatObject.h"
#import "XMPPManager.h"


static const CGFloat kMaxChatTextViewHeight = 99.0;

@interface KGChatViewController () <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIButton *voiceBtn;
@property (weak, nonatomic) IBOutlet KGChatTextField *chatTextField;
@property (weak, nonatomic) IBOutlet UIButton *emotionBtn;
@property (weak, nonatomic) IBOutlet UIButton *addBtn;
@property (weak, nonatomic) IBOutlet UITextView *chatTextView;
@property (weak, nonatomic) IBOutlet UIView *bottomView;

//@property (nonatomic, strong) NSMutableArray *messageArr;
@property (nonatomic, strong) NSMutableArray *chatObjArr;
@property (nonatomic, assign) CGFloat currKeyboardHeight;

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
    self.chatObjArr = [[NSMutableArray alloc] init];
    [self mockData];

    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor clearColor];
//    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;//TEST
    self.tableView.backgroundView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"chat-view-background"]];

    [self initHeaderView];
    [self initGoodsView];
    [self initChatTextField];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillShow:) name:UIKeyboardWillShowNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyBoardWillHide:) name:UIKeyboardWillHideNotification object:nil];

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textChanged:) name: UITextViewTextDidChangeNotification object:nil];

    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(newMsgCome:) name:kXMPPNewMsgNotifaction object:nil];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (self.chatObjArr && self.chatObjArr.count > 0) {
        [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:self.chatObjArr.count - 1 inSection:0] atScrollPosition:UITableViewScrollPositionBottom animated:YES];
    }
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [self.chatTextField resignFirstResponder];
    [self.chatTextView resignFirstResponder];
}

- (void)mockData {
    KGMessageObject *obj1 = [[KGMessageObject alloc]init];
    obj1.content = @"帮带的东西很好，希望还能继续合作，剩了不少钱，还是海带划算啊。。。。";
    obj1.type = MessageTypeOther;
    obj1.date = [NSDate dateWithTimeInterval:-200 sinceDate:[NSDate date]];
    KGChatObject *chatObj1 = [[KGChatObject alloc] initWithMessage:obj1];

    KGMessageObject *obj2 = [[KGMessageObject alloc]init];
    obj2.content = @"剩了不少钱，还是海带划算啊";
    obj2.type = MessageTypeOther;
    obj2.date = [NSDate dateWithTimeInterval:-150 sinceDate:[NSDate date]];
    KGChatObject *chatObj2 = [[KGChatObject alloc] initWithMessage:obj2];

    KGMessageObject *obj3 = [[KGMessageObject alloc]init];
    obj3.content = @"剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊剩了不少钱，还是海带划算啊";
    obj3.type = MessageTypeMe;
    obj3.date = [NSDate dateWithTimeInterval:-100 sinceDate:[NSDate date]];
    KGChatObject *chatObj3 = [[KGChatObject alloc] initWithMessage:obj3];

    [self.chatObjArr addObject:chatObj1];
    [self.chatObjArr addObject:chatObj2];
    [self.chatObjArr addObject:chatObj3];

    [self handleShowTime];
}

- (void)handleShowTime {
    NSString *preTime = nil;
    for (KGChatObject *chatObj in self.chatObjArr) {
        chatObj.showTime = ![preTime isEqualToString:chatObj.time];
        preTime = chatObj.time;
    }
}

- (void)initChatTextField {
    self.chatTextField.layer.cornerRadius = self.chatTextView.height / 2;
    self.chatTextField.layer.borderWidth = LINE_HEIGHT;
    self.chatTextField.layer.borderColor = RGBCOLOR(211, 220, 224).CGColor;
    self.chatTextField.hidden = NO;

    self.chatTextView.layer.cornerRadius = 10;
    self.chatTextView.layer.borderWidth = LINE_HEIGHT;
    self.chatTextView.layer.borderColor = RGBCOLOR(211, 220, 224).CGColor;
    self.chatTextView.hidden = YES;
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
    [view setHeight:bottomLabel.bottom + 2];
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
    return self.chatObjArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;

    cell = [[KGChatTextMessageCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"kChatMessageOtherCell"];
    cell.backgroundColor = [UIColor clearColor];
    KGChatTextMessageCell *mCell = (KGChatTextMessageCell *)cell;
    KGChatObject *chatObj = self.chatObjArr[indexPath.row];
    [mCell configCell:chatObj];

    return cell;
}

#pragma UITableViewDelegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    KGChatObject *msgObj = self.chatObjArr[indexPath.row];
    return [msgObj cellHeight];
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
    CGRect beginRect = [note.userInfo[UIKeyboardFrameBeginUserInfoKey] CGRectValue];
    CGRect endRect = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
    NSLog(@"**** %@, %@ ****", NSStringFromCGRect(beginRect), NSStringFromCGRect(endRect));
    self.currKeyboardHeight = endRect.size.height;
    [UIView animateWithDuration:[note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue] animations:^{
        [self.bottomView setTop:self.view.height - self.bottomView.height - endRect.size.height];
        [self.tableView setContentInset:UIEdgeInsetsMake(0, 0, endRect.size.height, 0)];
        if (self.chatObjArr && self.chatObjArr.count > 0) {
            NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatObjArr.count - 1 inSection:0];
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
    KGChatObject *chatObj = [[KGChatObject alloc] initWithMessage:obj];
    chatObj.showIndicator = NO;
    [self.chatObjArr addObject:chatObj];

    [self handleShowTime];

    [self.tableView beginUpdates];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatObjArr.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];

    XMPPElement *body = [XMPPElement elementWithName:@"body"];
    [body setStringValue:textField.text];
    XMPPElement *mes = [XMPPElement elementWithName:@"message"];
    [mes addAttributeWithName:@"type" stringValue:@"chat"];
    [mes addAttributeWithName:@"to" stringValue:@"andy@pc-20120831ebrg"];
    [mes addAttributeWithName:@"from" stringValue:@"hai@pc-20120831ebrg"];
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

- (void)goBack:(UIBarButtonItem *)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
        KGChatObject *chatObj = [[KGChatObject alloc] initWithMessage:obj];
        [self.chatObjArr addObject:chatObj];
        [self.tableView beginUpdates];
        NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatObjArr.count - 1 inSection:0];
        [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationFade];
        [self.tableView endUpdates];
        [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
        textView.text = @"";

        self.chatTextView.height = 33;
        self.bottomView.height = 54;
        self.bottomView.top = self.view.height - self.bottomView.height - self.currKeyboardHeight;
        return NO;
    }
    return YES;
}


- (void)newMsgCome:(NSNotification *)notifacation {
    KGChatObject *chatObj = notifacation.object;
    [self.chatObjArr addObject:chatObj];
    [self handleShowTime];
    [self.tableView beginUpdates];
    NSIndexPath *lastRow = [NSIndexPath indexPathForRow:self.chatObjArr.count - 1 inSection:0];
    [self.tableView insertRowsAtIndexPaths:@[lastRow] withRowAnimation:UITableViewRowAnimationFade];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:lastRow atScrollPosition:UITableViewScrollPositionBottom animated:YES];
}


@end
