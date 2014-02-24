//
//  PKResManager.m
//  TestResManager
//
//  Created by zhong sheng on 12-7-13.
//  Copyright (c) 2012年 . All rights reserved.
//

#import "PKResManager.h"
#import "PKResManagerKit.h"

static const void* RetainNoOp(CFAllocatorRef allocator, const void *value) { return value; }
static void ReleaseNoOp(CFAllocatorRef allocator, const void *value) { }
NSMutableArray* CreateNonRetainingArray() {
    CFArrayCallBacks callbacks = kCFTypeArrayCallBacks;
    callbacks.retain = RetainNoOp;
    callbacks.release = ReleaseNoOp;
    return (NSMutableArray*)CFBridgingRelease(CFArrayCreateMutable(nil, 0, &callbacks));
}

@interface PKResManager (/*private*/)
@property (nonatomic, strong) NSMutableArray *styleChangedHandlers; // delegates
@property (nonatomic, strong) NSMutableArray *resObjectsArray;
@property (nonatomic, strong) NSMutableArray *defaultStyleArray;
@property (nonatomic, strong) NSMutableArray *customStyleArray;

- (NSString *)getDocumentsDirectoryWithSubDir:(NSString *)subDir;
- (BOOL)isBundleURL:(NSString *)URL;
- (BOOL)isDocumentsURL:(NSString *)URL;
- (NSUInteger)styleTypeIndexByName:(NSString *)name;
- (void)saveCustomStyleArray;
- (NSMutableArray*)getSavedStyleArray;
@end

@implementation PKResManager

// public
@synthesize
styleBundle = _styleBundle,
defaultResOtherCache = _defaultResOtherCache,
resImageCache = _resImageCache,
resOtherCache = _resOtherCache,
allStyleArray = _allStyleArray,
styleName = _styleName,
styleType = _styleType,
isLoading = _isLoading;

// private
@synthesize
styleChangedHandlers = _styleChangedHandlers,
resObjectsArray = _resObjectsArray,
defaultStyleArray = _defaultStyleArray,
customStyleArray = _customStyleArray;

- (void)dealloc
{
    [self.styleChangedHandlers removeAllObjects];
    if (_allStyleArray.count>0) {
        [_allStyleArray removeAllObjects];
        _allStyleArray= nil;
    }
}

- (void)addChangeStyleObject:(id)object
{
    if (![self.resObjectsArray containsObject:object])
    {
        @synchronized(self.resObjectsArray)
        {
            [self.resObjectsArray addObject:object];
        }
    }
}

- (void)removeChangeStyleObject:(id)object
{
    if ([self.resObjectsArray containsObject:object])
    {
        @synchronized(self.resObjectsArray)
        {
            [self.resObjectsArray removeObject:object];
        }
    }
}
- (void)swithToStyle:(NSString *)name
{
    [self swithToStyle:name onComplete:^(BOOL finished, NSError *error) {
        return ;
    }];
}
- (void)swithToStyle:(NSString *)name onComplete:(ResStyleCompleteBlock)block
{
    if ([_styleName isEqualToString:name]
        || name == nil )
    {
        NSError *error = [NSError errorWithDomain:PK_ERROR_DOMAIN code:PKErrorCodeUnavailable userInfo:nil];
        block(YES,error);
        return;
    }
    else if (_isLoading) {
        block(NO,nil);
        return;
    }
    DLog(@"start change style :%@",[NSDate date]);
    _isLoading = YES;
    block(NO,nil);
    
    _styleName = [name copy];
    
    // read resource bundle
    _styleBundle = [self bundleByStyleName:name];
    if (self.styleBundle == nil) {
        NSError *error = [NSError errorWithDomain:PK_ERROR_DOMAIN code:PKErrorCodeBundleName userInfo:nil];
        block(YES,error);
        _isLoading = NO;
        return;
    }
    
    // remove cache
    [_resImageCache removeAllObjects];
    [_resOtherCache removeAllObjects];
    
    // get plist dict
    NSString *plistPath=[self.styleBundle pathForResource:CONFIG_PLIST_PATH ofType:@"plist"];
    self.resOtherCache = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    //    DLog(@"resOtherCache:%@",self.resOtherCache);
    
    // thread issue
    NSMutableArray *holdResObjectArray = [NSMutableArray arrayWithArray:_resObjectsArray];
    DLog(@"all res object count:%d",holdResObjectArray.count);
    
    // change style
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0ul);
    dispatch_async(queue, ^{
        [holdResObjectArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
            if ([obj respondsToSelector:@selector(changeStyle:)])
            {
                
                dispatch_sync(dispatch_get_main_queue(), ^{
                    [obj changeStyle:self];
                });
                
            }
            else
            {
                DLog(@" change style failed ! => %@",obj);
            }
            __block double progress = (double)(idx+1) / (double)(holdResObjectArray.count);
            for(ResStyleProgressBlock progressBlock in self.styleChangedHandlers)
            {
                dispatch_sync(dispatch_get_main_queue(), ^{
                    progressBlock(progress);
                });
                
            }
        }];
        _isLoading = NO;
        
        // save
        dispatch_sync(dispatch_get_main_queue(), ^{
            // save
            NSData *data = [NSKeyedArchiver archivedDataWithRootObject:_styleName];
            [[NSUserDefaults standardUserDefaults] setObject:data forKey:kNowResStyle];
            // block
            block(YES,nil);
        });
        DLog(@"end change style :%@",[NSDate date]);
    });
    
    while (!_isLoading) {
        return;
    }
    
}
- (BOOL)containsStyle:(NSString *)name
{
    if ([self styleTypeIndexByName:name] != NSNotFound) {
        return YES;
    }
    return NO;
}
- (void)changeStyleOnProgress:(ResStyleProgressBlock)progressBlock
{
    ResStyleProgressBlock tempBlock = [progressBlock copy];
    [self.styleChangedHandlers addObject:tempBlock];
}

- (BOOL)deleteStyle:(NSString *)name
{
    NSUInteger index = [self styleTypeIndexByName:name];
    // default style ,can not delete
    if (index < self.defaultStyleArray.count
        || index == NSNotFound)
    {
        return NO;
    }
    
    NSDictionary *styleDict = (self.allStyleArray)[index];
    NSString *bundleName = [(NSString *)styleDict[kStyleURL]
                            substringFromIndex:DOCUMENTS_PREFIX.length];
    BOOL isDir=NO;
    NSError *error = nil;
    NSString *stylePath = [[self getDocumentsDirectoryWithSubDir:nil]
                           stringByAppendingFormat:@"/%@",bundleName];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    if (![fileManager fileExistsAtPath:stylePath isDirectory:&isDir] && isDir)
    {
        DLog(@" No such file or directory");
        return NO;
    }
    if (![fileManager removeItemAtPath:stylePath error:&error])
    {
        DLog(@" delete file error:%@",error);
        return NO;
    }
    
    [_allStyleArray removeObjectAtIndex:index];
    
    [self saveCustomStyleArray];
    
    DLog(@" %@",self.allStyleArray);
    
    // need reset
    if ([_styleName isEqualToString:name]) {
        [self resetStyle];
    }
    
    return YES;
}

- (BOOL)saveStyle:(NSString *)styleId name:(NSString *)name version:(NSNumber *)version withBundle:(NSBundle *)bundle
{
    NSString *bundlePath = bundle.resourcePath;
    NSArray *elementArray = [bundlePath componentsSeparatedByString:@"/"];
    NSString *bundleName = [elementArray lastObject];
    if (bundleName != nil)
    {
        NSUInteger index = [self styleTypeIndexByName:name];
        NSDictionary *styleDict = [NSDictionary dictionaryWithObjects:@[styleId,
                                                                       name,
                                                                       [NSString stringWithFormat:@"%@%@/%@",DOCUMENTS_PREFIX,SAVED_STYLE_DIR,bundleName],
                                                                       version]
                                                              forKeys:@[kStyleID,
                                                                       kStyleName,
                                                                       kStyleURL,
                                                                       kStyleVersion]];
        // if exists ,replace
        if (index != NSNotFound)
        {
            _allStyleArray[index] = styleDict;
        }
        else
        {
            [_allStyleArray addObject:styleDict];
        }
        [self saveCustomStyleArray];
        
        // file operation
        NSError *error = nil;
        NSFileManager *fileManager = [NSFileManager defaultManager];
        NSString *customStylePath = [[self getDocumentsDirectoryWithSubDir:SAVED_STYLE_DIR]
                                     stringByAppendingFormat:@"/%@",bundleName];
        // if exist , overwrite
        if ([fileManager fileExistsAtPath:customStylePath])
        {
            NSError *updateError = nil;
            DLog(@" exist <%@> ,will overwrite",name);
            if (![fileManager removeItemAtPath:customStylePath error:&updateError])
            {
                DLog(@"updateError:%@",updateError);
            }
        }
        if (![fileManager copyItemAtPath:bundlePath toPath:customStylePath error:&error])
        {
            DLog(@"copy file error :%@",error);
            return NO;
        }
        DLog(@"saved: %@",self.allStyleArray);
        return YES;
    }
    return NO;
}

- (void)clearImageCache
{
    [_resImageCache removeAllObjects];
    //    [_resOtherCache removeAllObjects];
}
- (void)resetStyle
{
    // swith to default style
    _isLoading = NO;
    NSDictionary *defalutStyleDict = _defaultStyleArray[0];
    NSString *styleName = defalutStyleDict[kStyleName];
    [self swithToStyle:styleName];
}

- (UIImage *)previewImage
{
    return [self previewImageByStyleName:_styleName];
}
- (UIImage *)previewImageByStyleName:(NSString *)name
{
    UIImage *image = nil;
    NSBundle *bundle = [self bundleByStyleName:name];
    if (bundle!=nil) {
        NSString *imagePath = [bundle pathForResource:PREVIEW_PATH ofType:@"png"];
        image = [UIImage imageWithContentsOfFile:imagePath];
    }
    // TODO: image == nil
    return image;
}

- (NSMutableDictionary *)defaultResOtherCache
{
    if (!_defaultResOtherCache)
    {
        NSDictionary *defalutStyleDict = _defaultStyleArray[0];
        NSString *defaultStyleName = defalutStyleDict[kStyleName];
        NSBundle *tempBundle = [self bundleByStyleName:defaultStyleName];
        NSString *plistPath=[tempBundle pathForResource:CONFIG_PLIST_PATH ofType:@"plist"];
        _defaultResOtherCache = [NSMutableDictionary dictionaryWithContentsOfFile:plistPath];
    }
    return _defaultResOtherCache;
}

#pragma mark - Private

- (BOOL)isBundleURL:(NSString *)URL
{
    return [URL hasPrefix:BUNDLE_PREFIX];
}
- (BOOL)isDocumentsURL:(NSString *)URL
{
    return [URL hasPrefix:DOCUMENTS_PREFIX];
}
- (void)saveCustomStyleArray
{
    self.customStyleArray = [NSMutableArray arrayWithArray:self.allStyleArray];
    NSRange range;
    range.location = 0;
    range.length = self.defaultStyleArray.count;
    [self.customStyleArray removeObjectsInRange:range];
    NSData *data = [NSKeyedArchiver archivedDataWithRootObject:self.customStyleArray];
    [[NSUserDefaults standardUserDefaults] setObject:data forKey:kAllResStyle];
}
- (NSMutableArray*)getSavedStyleArray
{
    if (!_defaultStyleArray) {
        NSDictionary *lightDict = [NSDictionary dictionaryWithObjects:@[SYSTEM_STYLE_ID,
                                                                       SYSTEM_STYLE_NAME,
                                                                       SYSTEM_STYLE_URL,
                                                                       SYSTEM_STYLE_VERSION]
                                                              forKeys:@[kStyleID,
                                                                       kStyleName,
                                                                       kStyleURL,
                                                                       kStyleVersion]];
        _defaultStyleArray = [[NSMutableArray alloc] initWithObjects:lightDict, nil];
    }
    NSMutableArray *retArray = [NSMutableArray arrayWithArray:self.defaultStyleArray];
    NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kAllResStyle];
    NSArray *customStyleArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    [retArray addObjectsFromArray:customStyleArray];
    return retArray;
}

- (NSUInteger)styleTypeIndexByName:(NSString *)name
{
    __block NSUInteger styleIndex = NSNotFound;
    [_allStyleArray enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
     {
         NSDictionary *styleDict = (NSDictionary *)obj;
         NSString *styleName = styleDict[kStyleName];
         if ([styleName isEqualToString:name])
         {
             styleIndex = idx;
             return;
         }
     }];
    
    return styleIndex;
}
//
- (NSString *)getDocumentsDirectoryWithSubDir:(NSString *)subDir
{
    NSString *newDirectory = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    if (subDir)
    {
        newDirectory = [newDirectory stringByAppendingPathComponent:subDir];
    }
    
    BOOL isDir = NO;
	BOOL isExist = [[NSFileManager defaultManager] fileExistsAtPath:newDirectory isDirectory:&isDir];
    NSError *error;
	if(!isDir){
		[[NSFileManager defaultManager] removeItemAtPath:newDirectory error:nil];
	}
	if(!isExist || !isDir){
        if(![[NSFileManager defaultManager] createDirectoryAtPath:newDirectory
                                      withIntermediateDirectories:NO attributes:nil error:&error])
        {
            DLog(@"create file error：%@",error);
        }
	}
    return newDirectory;
}
- (NSBundle *)bundleByStyleName:(NSString *)name
{
    NSInteger index = [self styleTypeIndexByName:name];
    if (index == NSNotFound) {
        return nil;
    }
    
    NSDictionary *styleDict = (self.allStyleArray)[index];
    NSString *bundleURL = styleDict[kStyleURL];
    NSString *filePath = nil;
    NSString *bundlePath = nil;
    
    DLog(@"bundleURL:%@",bundleURL);
    BOOL changeStyle = NO;
    if ([self.styleName isEqualToString:name])
    {
        changeStyle = YES;
    }
    if ([self isBundleURL:bundleURL])
    {
        if (changeStyle)
        {
            _styleType = ResStyleType_System;
        }
        
        filePath = [[NSBundle mainBundle] bundlePath];
        bundlePath = [NSString stringWithFormat:@"%@/%@",filePath,[bundleURL substringFromIndex:BUNDLE_PREFIX.length]];
    }
    else if([self isDocumentsURL:bundleURL])
    {
        if (changeStyle)
        {
            _styleType = ResStyleType_Custom;
        }
        filePath = [self getDocumentsDirectoryWithSubDir:nil];
        bundlePath = [NSString stringWithFormat:@"%@/%@",filePath,[bundleURL substringFromIndex:DOCUMENTS_PREFIX.length]];
    }
    else
    {
        DLog(@"na ni !!! bundleName:%@",bundleURL);
        if (changeStyle)
        {
            _styleType = ResStyleType_Unknow;
        }
        return nil;
    }
    
    return [NSBundle bundleWithPath:bundlePath];
}


#pragma mark - Singeton
- (id)init{
    self = [super init];
    if (self) {
        _styleChangedHandlers = [[NSMutableArray alloc] init];
        _resObjectsArray = CreateNonRetainingArray(); // 不retain的数组
        _resImageCache = [[NSMutableDictionary alloc] init];
        _resOtherCache = [[NSMutableDictionary alloc] init];
        
        // get all style ( will get defalut style array)
        _allStyleArray = [self getSavedStyleArray];
        
        // read
        NSData *data = [[NSUserDefaults standardUserDefaults] objectForKey:kNowResStyle];
        if (data!=nil) {
            _isLoading = NO;
            NSString *nowStyleName = [NSKeyedUnarchiver unarchiveObjectWithData:data];
            [self swithToStyle:nowStyleName];
        }else{
            [self resetStyle];
        }
        
    }
    return self;
}

+ (PKResManager*)getInstance{
    static dispatch_once_t pred = 0;
    __strong static id _sharedObject = nil;
    dispatch_once(&pred, ^{
        _sharedObject = [[self alloc] init]; // or some other init method
    });
    return _sharedObject;
}

@end
