//
//  UIColor+PKColor.m
//  PKResManager
//
//  Created by zhongsheng on 12-11-27.
//
//

#import "UIColor+PKColor.h"
#import "PKResManagerKit.h"


@implementation UIColor (PKColor)

+ (UIColor *)colorForKey:(id)key
{
    return [UIColor colorForKey:key style:PKColorTypeNormal];
}

+ (UIColor *)shadowColorForKey:(id)key
{
    return [UIColor colorForKey:key style:PKColorTypeShadow];
}

+ (UIColor *)colorForKey:(id)key style:(PKColorType)type
{
    NSArray *keyArray = [key componentsSeparatedByString:@"-"];
    NSAssert1(keyArray.count == 2, @"module key name error!!! [color] ==> %@", key);
    
    NSString *moduleKey = keyArray[0];
    NSString *memberKey = keyArray[1];
    
    NSDictionary *moduleDict = ([PKResManager getInstance].resOtherCache)[moduleKey];
    // 容错处理读取默认配置
    if (moduleDict.count <= 0)
    {
        moduleDict = ([PKResManager getInstance].defaultResOtherCache)[moduleKey];
    }
    NSAssert1(moduleDict.count > 0, @"module not exist !!! [color] ==> %@", key);
    NSDictionary *memberDict = moduleDict[memberKey];
    // 容错处理读取默认配置
    if (memberDict.count <= 0) {
        moduleDict = ([PKResManager getInstance].defaultResOtherCache)[moduleKey];
        memberDict = moduleDict[memberKey];
    }
    NSAssert1(memberDict.count > 0, @"color not exist !!! [color] ==> %@", key);
    
    NSString *colorStr = memberDict[kColor];
    
    BOOL shadow = NO;
    if (type & PKColorTypeShadow) {
        shadow = YES;
        colorStr = memberDict[kShadowColor];
    }
    if (type & PKColorTypeHightLight) {
        colorStr = memberDict[kColorHL];
        if (shadow) {
            colorStr = memberDict[kShadowColorHL];
        }
    }
    
    NSNumber *redValue;
    NSNumber *greenValue;
    NSNumber *blueValue;
    NSNumber *alphaValue;
    NSArray *colorArray = [colorStr componentsSeparatedByString:@","];
    if (colorArray != nil && colorArray.count == 3) {
        redValue = @([colorArray[0] floatValue]);
        greenValue = @([colorArray[1] floatValue]);
        blueValue = @([colorArray[2] floatValue]);
        alphaValue = @1.0f;
    } else if (colorArray != nil && colorArray.count == 4) {
        redValue = @([colorArray[0] floatValue]);
        greenValue = @([colorArray[1] floatValue]);
        blueValue = @([colorArray[2] floatValue]);
        alphaValue = @([colorArray[3] floatValue]);
    } else {
        return nil;
    }
    
    if ([alphaValue floatValue]<=0.0f) {
        return [UIColor clearColor];
    }
    return [UIColor colorWithRed:(CGFloat)([redValue floatValue]/255.0f)
                           green:(CGFloat)([greenValue floatValue]/255.0f)
                            blue:(CGFloat)([blueValue floatValue]/255.0f)
                           alpha:(CGFloat)([alphaValue floatValue])];
}


+ (UIColor *)colorForKey:(id)key alpha:(CGFloat)alpha style:(PKColorType)type
{
    UIColor *styleColor = [UIColor colorForKey:key style:type];
    if (alpha > 0.0f && alpha <= 1.0f)
    {
        CGColorRef alphaColorRef = CGColorCreateCopyWithAlpha(styleColor.CGColor,alpha);
        styleColor = [UIColor colorWithCGColor:alphaColorRef];
        CGColorRelease(alphaColorRef);
    }
    return styleColor;
}

+ (UIColor *)colorForKey:(id)key alpha:(CGFloat)alpha
{
    return [UIColor colorForKey:key alpha:alpha style:PKColorTypeNormal];
}

+ (UIColor *)shadowColorForKey:(id)key alpha:(CGFloat)alpha
{
    return [UIColor colorForKey:key alpha:alpha style:PKColorTypeShadow];
}

@end
