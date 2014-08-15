//
//  XMPPManager.m
//  KelpGang
//
//  Created by Andy on 14-3-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import "XMPPManager.h"

#import "DDLog.h"
#import "DDTTYLogger.h"
#import "KGChatCellInfo.h"
#import "KGChatViewController.h"

// Log levels: off, error, warn, info, verbose
#if DEBUG
static const int ddLogLevel = LOG_LEVEL_VERBOSE;
#else
static const int ddLogLevel = LOG_LEVEL_INFO;
#endif

NSString *const kXMPPmyJID = @"kXMPPmyJID";
NSString *const kXMPPmyPassword = @"kXMPPmyPassword";

@interface XMPPManager()


@end

@implementation XMPPManager

@synthesize xmppStream;
@synthesize xmppReconnect;
@synthesize xmppRoster;
@synthesize xmppRosterStorage;
@synthesize xmppAutoPing;
@synthesize isXmppConnected;
//@synthesize xmppvCardTempModule;
//@synthesize xmppvCardAvatarModule;
//@synthesize xmppCapabilities;
//@synthesize xmppCapabilitiesStorage;

+ (XMPPManager *)sharedInstance {

    static dispatch_once_t pred;
    static XMPPManager *manager;

    dispatch_once(&pred, ^{
        manager = [[self alloc] init];
    });
    return manager;
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Core Data
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (NSManagedObjectContext *)managedObjectContext_roster
{
	return [xmppRosterStorage mainThreadManagedObjectContext];
}

//- (NSManagedObjectContext *)managedObjectContext_capabilities
//{
//	return [xmppCapabilitiesStorage mainThreadManagedObjectContext];
//}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Private
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)setupStream
{
	NSAssert(xmppStream == nil, @"Method setupStream invoked multiple times");

	// Setup xmpp stream
	//
	// The XMPPStream is the base class for all activity.
	// Everything else plugs into the xmppStream, such as modules/extensions and delegates.

	xmppStream = [[XMPPStream alloc] init];

#if !TARGET_IPHONE_SIMULATOR
	{
		// Want xmpp to run in the background?
		//
		// P.S. - The simulator doesn't support backgrounding yet.
		//        When you try to set the associated property on the simulator, it simply fails.
		//        And when you background an app on the simulator,
		//        it just queues network traffic til the app is foregrounded again.
		//        We are patiently waiting for a fix from Apple.
		//        If you do enableBackgroundingOnSocket on the simulator,
		//        you will simply see an error message from the xmpp stack when it fails to set the property.

		xmppStream.enableBackgroundingOnSocket = YES;
	}
#endif

	// Setup reconnect
	//
	// The XMPPReconnect module monitors for "accidental disconnections" and
	// automatically reconnects the stream for you.
	// There's a bunch more information in the XMPPReconnect header file.

	xmppReconnect = [[XMPPReconnect alloc] init];

	// Setup roster
	//
	// The XMPPRoster handles the xmpp protocol stuff related to the roster.
	// The storage for the roster is abstracted.
	// So you can use any storage mechanism you want.
	// You can store it all in memory, or use core data and store it on disk, or use core data with an in-memory store,
	// or setup your own using raw SQLite, or create your own storage mechanism.
	// You can do it however you like! It's your application.
	// But you do need to provide the roster with some storage facility.

	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] init];
    //	xmppRosterStorage = [[XMPPRosterCoreDataStorage alloc] initWithInMemoryStore];

	xmppRoster = [[XMPPRoster alloc] initWithRosterStorage:xmppRosterStorage];

	xmppRoster.autoFetchRoster = YES;
	xmppRoster.autoAcceptKnownPresenceSubscriptionRequests = YES;

	// Setup vCard support
	//
	// The vCard Avatar module works in conjuction with the standard vCard Temp module to download user avatars.
	// The XMPPRoster will automatically integrate with XMPPvCardAvatarModule to cache roster photos in the roster.

//	xmppvCardStorage = [XMPPvCardCoreDataStorage sharedInstance];
//	xmppvCardTempModule = [[XMPPvCardTempModule alloc] initWithvCardStorage:xmppvCardStorage];

//	xmppvCardAvatarModule = [[XMPPvCardAvatarModule alloc] initWithvCardTempModule:xmppvCardTempModule];

	// Setup capabilities
	//
	// The XMPPCapabilities module handles all the complex hashing of the caps protocol (XEP-0115).
	// Basically, when other clients broadcast their presence on the network
	// they include information about what capabilities their client supports (audio, video, file transfer, etc).
	// But as you can imagine, this list starts to get pretty big.
	// This is where the hashing stuff comes into play.
	// Most people running the same version of the same client are going to have the same list of capabilities.
	// So the protocol defines a standardized way to hash the list of capabilities.
	// Clients then broadcast the tiny hash instead of the big list.
	// The XMPPCapabilities protocol automatically handles figuring out what these hashes mean,
	// and also persistently storing the hashes so lookups aren't needed in the future.
	//
	// Similarly to the roster, the storage of the module is abstracted.
	// You are strongly encouraged to persist caps information across sessions.
	//
	// The XMPPCapabilitiesCoreDataStorage is an ideal solution.
	// It can also be shared amongst multiple streams to further reduce hash lookups.

//	xmppCapabilitiesStorage = [XMPPCapabilitiesCoreDataStorage sharedInstance];
//    xmppCapabilities = [[XMPPCapabilities alloc] initWithCapabilitiesStorage:xmppCapabilitiesStorage];

//    xmppCapabilities.autoFetchHashedCapabilities = YES;
//    xmppCapabilities.autoFetchNonHashedCapabilities = NO;

	// Activate xmpp modules

	[xmppReconnect         activate:xmppStream];
	[xmppRoster            activate:xmppStream];
//	[xmppvCardTempModule   activate:xmppStream];
//	[xmppvCardAvatarModule activate:xmppStream];
//	[xmppCapabilities      activate:xmppStream];

	// Add ourself as a delegate to anything we may be interested in

	[xmppStream addDelegate:self delegateQueue:dispatch_get_main_queue()];
	[xmppRoster addDelegate:self delegateQueue:dispatch_get_main_queue()];

	// Optional:
	//
	// Replace me with the proper domain and port.
	// The example below is setup for a typical google talk account.
	//
	// If you don't supply a hostName, then it will be automatically resolved using the JID (below).
	// For example, if you supply a JID like 'user@quack.com/rsrc'
	// then the xmpp framework will follow the xmpp specification, and do a SRV lookup for quack.com.
	//
	// If you don't specify a hostPort, then the default (5222) will be used.

	[xmppStream setHostName:kChatHostName];
	[xmppStream setHostPort:kChatHostPort];


    xmppAutoPing = [[XMPPAutoPing alloc] init];
	xmppAutoPing.pingInterval = 30;
	xmppAutoPing.pingTimeout = 5;
	xmppAutoPing.targetJID = nil;
//    xmppAutoPing.respondsToQueries = YES;

	[xmppAutoPing activate:xmppStream];

	[xmppAutoPing addDelegate:self delegateQueue:dispatch_get_main_queue()];

	// You may need to alter these settings depending on the server you're connecting to
	allowSelfSignedCertificates = NO;
	allowSSLHostNameMismatch = NO;
}

- (void)teardownStream
{
	[xmppStream removeDelegate:self];
	[xmppRoster removeDelegate:self];

	[xmppReconnect         deactivate];
	[xmppRoster            deactivate];
//	[xmppvCardTempModule   deactivate];
//	[xmppvCardAvatarModule deactivate];
//	[xmppCapabilities      deactivate];

	[xmppStream disconnect];

	xmppStream = nil;
	xmppReconnect = nil;
    xmppRoster = nil;
	xmppRosterStorage = nil;
//	xmppvCardStorage = nil;
//    xmppvCardTempModule = nil;
//	xmppvCardAvatarModule = nil;
//	xmppCapabilities = nil;
//	xmppCapabilitiesStorage = nil;
}

// It's easy to create XML elments to send and to read received XML elements.
// You have the entire NSXMLElement and NSXMLNode API's.
//
// In addition to this, the NSXMLElement+XMPP category provides some very handy methods for working with XMPP.
//
// On the iPhone, Apple chose not to include the full NSXML suite.
// No problem - we use the KissXML library as a drop in replacement.
//
// For more information on working with XML elements, see the Wiki article:
// https://github.com/robbiehanson/XMPPFramework/wiki/WorkingWithElements

- (void)goOnline
{
	XMPPPresence *presence = [XMPPPresence presence]; // type="available" is implicit
	[[self xmppStream] sendElement:presence];
}

- (void)goOffline
{
	XMPPPresence *presence = [XMPPPresence presenceWithType:@"unavailable"];
	[[self xmppStream] sendElement:presence];
}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark Connect/disconnect
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (BOOL)connect
{
	if (![xmppStream isDisconnected]) {
		return YES;
	}

//	NSString *myJID = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyJID];
//	NSString *myPassword = [[NSUserDefaults standardUserDefaults] stringForKey:kXMPPmyPassword];

    NSString *myJID = [NSString stringWithFormat:@"%d@%@", APPCONTEXT.currUser.uid, kChatHostName];
    NSString *myPassword = APPCONTEXT.currUser.password;

	//
	// If you don't want to use the Settings view to set the JID,
	// uncomment the section below to hard code a JID and password.
	//
	// myJID = @"user@gmail.com/xmppframework";
	// myPassword = @"";

	if (myJID == nil || myPassword == nil) {
		return NO;
	}

	[xmppStream setMyJID:[XMPPJID jidWithString:myJID]];
	password = myPassword;

	NSError *error = nil;
	if (![xmppStream connectWithTimeout:XMPPStreamTimeoutNone error:&error])
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error connecting"
		                                                    message:@"See console for error details."
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Ok"
		                                          otherButtonTitles:nil];
		[alertView show];

		DDLogError(@"Error connecting: %@", error);

		return NO;
	}

	return YES;
}

- (void)disconnect
{
	[self goOffline];
	[xmppStream disconnect];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPStream Delegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppStream:(XMPPStream *)sender socketDidConnect:(GCDAsyncSocket *)socket
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStream:(XMPPStream *)sender willSecureWithSettings:(NSMutableDictionary *)settings
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	if (allowSelfSignedCertificates)
	{
		[settings setObject:[NSNumber numberWithBool:YES] forKey:(NSString *)kCFStreamSSLAllowsAnyRoot];
	}

	if (allowSSLHostNameMismatch)
	{
		[settings setObject:[NSNull null] forKey:(NSString *)kCFStreamSSLPeerName];
	}
	else
	{
		NSString *expectedCertName = [xmppStream.myJID domain];

		if (expectedCertName)
		{
			[settings setObject:expectedCertName forKey:(NSString *)kCFStreamSSLPeerName];
		}
	}
}

- (void)xmppStreamDidSecure:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidConnect:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	isXmppConnected = YES;

	NSError *error = nil;

	if (![[self xmppStream] authenticateWithPassword:password error:&error])
	{
		DDLogError(@"Error authenticating: %@", error);
	}
}

- (void)xmppStreamDidAuthenticate:(XMPPStream *)sender
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	[self goOnline];
}

- (void)xmppStream:(XMPPStream *)sender didNotAuthenticate:(NSXMLElement *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (BOOL)xmppStream:(XMPPStream *)sender didReceiveIQ:(XMPPIQ *)iq
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	return NO;
}

- (void)xmppStream:(XMPPStream *)sender didReceiveMessage:(XMPPMessage *)message
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	// A simple example of inbound message handling.

	if ([message isChatMessageWithBody])
	{
		XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[message from]
		                                                         xmppStream:xmppStream
		                                               managedObjectContext:[self managedObjectContext_roster]];

		NSString *body = [[message elementForName:@"body"] stringValue];
		NSString *displayName = [user displayName];

        NSInteger notifyType = 0;//0：前台运营，非聊天页面 1：聊天页面 2：后台运行
		if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
		{
            UIWindow *window = [[UIApplication sharedApplication].delegate window];
            UITabBarController *rootViewController = (UITabBarController *)window.rootViewController;
            UIViewController *selectViewController = rootViewController.selectedViewController;
            if ([selectViewController isKindOfClass:[UINavigationController class]]) {
                UINavigationController *navController = (UINavigationController *) selectViewController;
                if ([navController.visibleViewController isKindOfClass:[KGChatViewController class]]) {
                    notifyType = 1;
                }
            } else {
                if ([selectViewController.presentedViewController isKindOfClass:[KGChatViewController class]]) {
                    notifyType = 1;
                }
            }
		} else {
            notifyType = 2;
        }

        switch (notifyType) {
            case 0: {
                MTStatusBarOverlay *overlay = [MTStatusBarOverlay sharedInstance];
                overlay.animation = MTStatusBarOverlayAnimationFallDown;
                overlay.detailViewMode = MTDetailViewModeCustom;
                overlay.frame = CGRectMake(200, 0, 150, 20);
                [overlay setDetailView:nil];
                overlay.delegate = self;

                if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")) {
                    overlay.defaultStatusBarImage = [UIImage imageWithColor:MAIN_COLOR];
                } else {
                    overlay.defaultStatusBarImage = nil;
                }
                overlay.hidesActivity = YES;
                [overlay postMessage:[NSString stringWithFormat:@"%@(1)", displayName] duration:10.0];
                break;
            }
            case 1: {
                KGMessageObject *msgObj = [[KGMessageObject alloc] init];
                msgObj.content = body;
                msgObj.from = displayName;
                msgObj.date = [NSDate date];
                msgObj.type = MessageTypeOther;
                KGChatCellInfo *chatCellInfo = [[KGChatCellInfo alloc] initWithMessage:msgObj];
                [[NSNotificationCenter defaultCenter]postNotificationName:kXMPPNewMsgNotifaction object:chatCellInfo];
                break;
            }
            case 2: {
                UILocalNotification *localNotification = [[UILocalNotification alloc] init];
                localNotification.alertAction = @"Ok";
                localNotification.alertBody = [NSString stringWithFormat:@"From: %@\n\n%@",displayName,body];
                [[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
                break;
            }
            default:
                break;
        }
	}
}

- (void)xmppStream:(XMPPStream *)sender didReceivePresence:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@ - %@", THIS_FILE, THIS_METHOD, [presence fromStr]);
    NSString *presenceType = [presence type];
    NSString *myUsername = [[sender myJID] user];
    NSString *presenceFromUser = [[presence from] user];
    if (![presenceFromUser isEqualToString:myUsername])
    {
        if  ([presenceType isEqualToString:@"subscribe"])
        {
            [xmppRoster subscribePresenceToUser:[presence from]];
        }
    }
}

- (void)xmppStream:(XMPPStream *)sender didReceiveError:(id)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);
}

- (void)xmppStreamDidDisconnect:(XMPPStream *)sender withError:(NSError *)error
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	if (!isXmppConnected)
	{
		DDLogError(@"Unable to connect to server. Check xmppStream.hostName");
	}
}

- (void)xmppStream:(XMPPStream *)sender didSendMessage:(XMPPMessage *)message {

}

- (void)xmppStream:(XMPPStream *)sender didFailToSendMessage:(XMPPMessage *)message error:(NSError *)error {

}

////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
#pragma mark XMPPRosterDelegate
////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppRoster:(XMPPRoster *)sender didReceiveBuddyRequest:(XMPPPresence *)presence
{
	DDLogVerbose(@"%@: %@", THIS_FILE, THIS_METHOD);

	XMPPUserCoreDataStorageObject *user = [xmppRosterStorage userForJID:[presence from]
	                                                         xmppStream:xmppStream
	                                               managedObjectContext:[self managedObjectContext_roster]];

	NSString *displayName = [user displayName];
	NSString *jidStrBare = [presence fromStr];
	NSString *body = nil;

	if (![displayName isEqualToString:jidStrBare])
	{
		body = [NSString stringWithFormat:@"Buddy request from %@ <%@>", displayName, jidStrBare];
	}
	else
	{
		body = [NSString stringWithFormat:@"Buddy request from %@", displayName];
	}


	if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateActive)
	{
		UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:displayName
		                                                    message:body
		                                                   delegate:nil
		                                          cancelButtonTitle:@"Not implemented"
		                                          otherButtonTitles:nil];
		[alertView show];
	}
	else
	{
		// We are not active, so use a local notification instead
		UILocalNotification *localNotification = [[UILocalNotification alloc] init];
		localNotification.alertAction = @"Not implemented";
		localNotification.alertBody = body;
		
		[[UIApplication sharedApplication] presentLocalNotificationNow:localNotification];
	}
	
}

- (void)xmppRoster:(XMPPRoster *)sender didReceivePresenceSubscriptionRequest:(XMPPPresence *)presence {
    XMPPUserCoreDataStorageObject *user = [self.xmppRosterStorage
                                           userForJID:[presence from]
                                           xmppStream:self.xmppStream
                                           managedObjectContext:[self managedObjectContext_roster]];
    DDLogVerbose(@"didReceivePresenceSubscriptionRequest from user %@ ",
                 user.jidStr);
    [self.xmppRoster acceptPresenceSubscriptionRequestFrom:[presence from] andAddToRoster:YES];
}


////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////

- (void)xmppAutoPingDidSendPing:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

- (void)xmppAutoPingDidReceivePong:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}

- (void)xmppAutoPingDidTimeout:(XMPPAutoPing *)sender
{
	DDLogVerbose(@"%@: %@", [self class], THIS_METHOD);
}


- (void)sendMessage:(XMPPElement *) message {
    [xmppStream sendElement:message];
}

- (void)statusBarOverlayDidRecognizeGesture:(UIGestureRecognizer *)gestureRecognizer {
    [[MTStatusBarOverlay sharedInstance] hide];
    UIWindow *window = [[UIApplication sharedApplication].delegate window];
    UITabBarController *rootViewController = (UITabBarController *)window.rootViewController;
    UIViewController *chatViewController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"kChatViewController"];
    UIViewController *selectViewController = rootViewController.selectedViewController;
    if ([selectViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController *navController = (UINavigationController *) selectViewController;
        [navController popToRootViewControllerAnimated:NO];
        [rootViewController setSelectedIndex:3];
        navController = (UINavigationController *)(rootViewController.selectedViewController);
        UIViewController *recentContactsController = [rootViewController.storyboard instantiateViewControllerWithIdentifier:@"kRecentContactsController"];
        recentContactsController.hidesBottomBarWhenPushed = YES;
        [navController pushViewController:recentContactsController animated:NO];
        [navController pushViewController:chatViewController animated:YES];
    }
}


@end
