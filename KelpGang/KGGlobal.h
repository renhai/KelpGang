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
#define kChatHostName @"10.2.45.77"
#define kChatHostPort 5222
#define kChatHostURL @"10.2.45.77:5222"
#define kWebHTML5Url @"http://10.2.24.140"


