//
//  KGGlobal.h
//  KelpGang
//
//  Created by Andy on 14-3-7.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#define NAVIGATIONBAR_ADD_DEFAULT_BACKBUTTON_WITH_CALLBACK(callbackFunction) \
{ \
UIImage *normalImage = [UIImage imageNamed:@"nav_bar_item_back"];\
UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithImage:normalImage style:UIBarButtonItemStyleBordered target:self action:@selector(callbackFunction)];\
buttonItem.tintColor = [UIColor whiteColor];\
self.navigationItem.leftBarButtonItem = buttonItem;\
}
#define kPublishTask @"kPublishTask"
#define kXMPPNewMsgNotifaction @"xmppNewMsgNotifaction"
#define kChatHostName @"10.3.20.160"
#define kChatHostPort 5222
#define kWebHTML5Url @"http://10.2.24.140"
#define kWebServerBaseURL @"http://10.3.20.160:55641"

#define kTabBarIndexFind        0;
#define kTabBarIndexDiscover    1;
#define kTabBarIndexCreateTask  2;
#define kTabBarIndexHome        3;
#define kAvatarMale @"avatar-male"
#define kAvatarFemale @"avatar-female"
#define kHarfHeart @"half_heart"
#define kFullHeart @"full_heart"
#define kLoadingText @"Loading"
#define APPCONTEXT  [AppContext sharedInstance]
#define kCurrentUserId @"kCurrentUserId"
#define kCurrentSessionKey @"kCurrentSessionKey"
#define kPersistDir  @"persist"
#define kLoginUserKey   @"kX2UserKey"
#define kAlertViewTip   @"提示"
#define kUpdateAddress  @"kUpdateAddress"
#define kNetworkError   @"网络故障，请稍后重试"


typedef enum {
    MALE =      0,
    FEMALE =    1
} Gender;

typedef enum {
    WAITING_CONFIRM =       0,//待确认
    WAITING_PAID =          1,//待付款
    PURCHASING =            2,//采购中
    RETURNING =             3,//返程中
    WAITING_RECEIPT =       4,//等待买家确认收货
    WAITING_COMMENT =       5,//待评价
    COMPLETED =             6//已完成
} OrderStatus;


