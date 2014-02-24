//
//  UIImage+PKImage.m
//  PKResManager
//
//  Created by zhongsheng on 12-11-27.
//
//

#import "UIImage+PKImage.h"
#import "PKResManagerKit.h"


@implementation UIImage (PKImage)

+ (UIImage *)imageForKey:(id)key
{
    return [UIImage imageForKey:key cache:YES];
}

+ (UIImage *)imageForKey:(id)key cache:(BOOL)needCache
{
    if (key == nil) {
        DLog(@" imageForKey:cache: key = nil");
        return nil;
    }
    // 去除扩展名
    if ([key hasSuffix:@".png"] || [key hasSuffix:@".jpg"]) {
        key = [key substringToIndex:((NSString*)key).length-4];
    }
    
    UIImage *image = ([PKResManager getInstance].resImageCache)[key];
    if (image == nil)
    {
        // no cache
        image = [UIImage imageForKey:key style:[PKResManager getInstance].styleName];
    }
    // cache
    if (image != nil && needCache)
    {
        ([PKResManager getInstance].resImageCache)[key] = image;
    }
    
    return image;
}

+ (UIImage *)imageForKey:(id)key style:(NSString *)name
{
    if (key == nil)
    {
        DLog(@" imageForKey:style: key = nil");
        return nil;
    }
    // 去除扩展名
    if ([key hasSuffix:@".png"] || [key hasSuffix:@".jpg"])
    {
        key = [key substringToIndex:((NSString*)key).length-4];
    }
    
    UIImage *image = nil;
    NSBundle *styleBundle = nil;
    // 不是当前style情况
    if (![name isEqualToString:[PKResManager getInstance].styleName])
    {
        styleBundle = [[PKResManager getInstance] bundleByStyleName:name];
    }
    else
    {
        styleBundle = [PKResManager getInstance].styleBundle;
    }
    
    image = [UIImage imageForKey:key inBundle:styleBundle];
    
    // @2x情况
    if (image == nil)
    {
        if (![key hasSuffix:@"@2x"]) {
            image = [UIImage imageForKey:[NSString stringWithFormat:@"%@@2x",key] inBundle:styleBundle];
        }else if ([key hasSuffix:@"@2x"]){
            image = [UIImage imageForKey:[key substringToIndex:((NSString*)key).length-3] inBundle:styleBundle];
        }
    }
    
    // 最后从mainBundle中找
    if (image == nil)
    {
        DLog(@" will get default style => %@",key);
        styleBundle = [NSBundle mainBundle];
        image = [UIImage imageForKey:key inBundle:styleBundle];
    }
    
    return image;
}

// 支持png和jpg，可扩展
+ (UIImage *)imageForKey:(id)key inBundle:(NSBundle *)bundle
{
    NSString *imagePath = [bundle pathForResource:key ofType:@"png"];
    if (![[NSFileManager defaultManager] fileExistsAtPath:imagePath]) {
        imagePath = [bundle pathForResource:key ofType:@"jpg"];
    }
    return [UIImage imageWithContentsOfFile:imagePath];
}
@end
