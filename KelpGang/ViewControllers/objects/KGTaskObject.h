//
//  KGCreateTaskRequest.h
//  KelpGang
//
//  Created by Andy on 14-8-11.
//  Copyright (c) 2014年 renren. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface KGTaskObject : NSObject

@property (nonatomic, assign) NSInteger taskId;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGFloat gratuity;
@property (nonatomic, strong) NSDate *deadline;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *imageArr;
@property (nonatomic, strong) NSString *expectCountry;
@property (nonatomic, assign) CGFloat maxMoney;

@end
