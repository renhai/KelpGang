//
//  KGLeaveMessageController.m
//  KelpGang
//
//  Created by Andy on 14-9-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "KGLeaveMessageController.h"

@interface KGLeaveMessageController ()
@property (weak, nonatomic) IBOutlet UITextView *messageTV;

@end

@implementation KGLeaveMessageController

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
    [self setTitle:@"留言"];
    [self setLeftBarbuttonItem];
    [self setRightBarbuttonItemWithText:@"完成" selector:@selector(leaveMessageClicked:)];
    self.messageTV.text = self.oriMessage ? self.oriMessage : @"";
    [self.messageTV becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)leaveMessageClicked: (UIBarButtonItem *)sender {
    if (!self.messageTV.text || [@"" isEqualToString:self.messageTV.text]) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:kAlertViewTip message:@"留言不能为空" delegate:nil cancelButtonTitle:@"确定" otherButtonTitles:nil, nil];
        [alert show];
        return;
    }
    NSDictionary *params = @{@"user_id": @(APPCONTEXT.currUser.uid),
                             @"session_key": APPCONTEXT.currUser.sessionKey,
                             @"order_id": @(self.orderId),
                             @"leave_message": self.messageTV.text};
    [[HudHelper getInstance] showHudOnView:self.view caption:nil image:nil acitivity:YES autoHideTime:0.0];
    [[KGNetworkManager sharedInstance] postRequest:@"/mobile/order/addLeaveMessage" params:params success:^(id responseObject) {
        DLog(@"%@", responseObject);
        [[HudHelper getInstance] hideHudInView:self.view];
        if ([KGUtils checkResultWithAlert:responseObject]) {
            NSDictionary *data = responseObject[@"data"];
            NSString *leaveMsg = data[@"leave_message"];
            [self goBack:nil];
            if (self.block) {
                self.block(leaveMsg);
            }
        }
    } failure:^(NSError *error) {
        NSLog(@"%@", error);
    }];
}


@end
