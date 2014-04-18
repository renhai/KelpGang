//
//  XMPPManager.h
//  KelpGang
//
//  Created by Andy on 14-3-5.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

#import "XMPPFramework.h"
#import "XMPPRosterCoreDataStorage.h"
#import "MTStatusBarOverlay.h"


@interface XMPPManager : NSObject <XMPPStreamDelegate, XMPPRosterDelegate, XMPPAutoPingDelegate, MTStatusBarOverlayDelegate>{
	XMPPStream *xmppStream;
	XMPPReconnect *xmppReconnect;
    XMPPRoster *xmppRoster;
	XMPPRosterCoreDataStorage *xmppRosterStorage;
    XMPPAutoPing *xmppAutoPing;

//    XMPPvCardCoreDataStorage *xmppvCardStorage;
//	XMPPvCardTempModule *xmppvCardTempModule;
//	XMPPvCardAvatarModule *xmppvCardAvatarModule;
//	XMPPCapabilities *xmppCapabilities;
//	XMPPCapabilitiesCoreDataStorage *xmppCapabilitiesStorage;

	NSString *password;

	BOOL allowSelfSignedCertificates;
	BOOL allowSSLHostNameMismatch;

	BOOL isXmppConnected;
}

@property (nonatomic, strong, readonly) XMPPStream *xmppStream;
@property (nonatomic, strong, readonly) XMPPReconnect *xmppReconnect;
@property (nonatomic, strong, readonly) XMPPRoster *xmppRoster;
@property (nonatomic, strong, readonly) XMPPRosterCoreDataStorage *xmppRosterStorage;
@property (nonatomic, strong, readonly) XMPPAutoPing *xmppAutoPing;
@property (nonatomic, assign) BOOL isXmppConnected;

//@property (nonatomic, strong, readonly) XMPPvCardTempModule *xmppvCardTempModule;
//@property (nonatomic, strong, readonly) XMPPvCardAvatarModule *xmppvCardAvatarModule;
//@property (nonatomic, strong, readonly) XMPPCapabilities *xmppCapabilities;
//@property (nonatomic, strong, readonly) XMPPCapabilitiesCoreDataStorage *

- (NSManagedObjectContext *)managedObjectContext_roster;
//- (NSManagedObjectContext *)managedObjectContext_capabilities;

- (BOOL)connect;
- (void)disconnect;
- (void)setupStream;
- (void)teardownStream;

- (void)goOnline;
- (void)goOffline;

- (void)sendMessage:(XMPPElement *) message;

+ (XMPPManager *)sharedInstance;

@end
