//
//  UIColor+PKColor.h
//  PKResManager
//
//  Created by zhongsheng on 12-11-27.
//
//

#import <UIKit/UIKit.h>

typedef enum {
	PKColorTypeNormal						= 1,    // 普通
	PKColorTypeHightLight                   = 1<<1, // 高亮
	PKColorTypeShadow                       = 1<<2, // 阴影
} PKColorType;

@interface UIColor (PKColor)

+ (UIColor *)colorForKey:(id)key style:(PKColorType)type;

+ (UIColor *)colorForKey:(id)key;

+ (UIColor *)shadowColorForKey:(id)key;

+ (UIColor *)colorForKey:(id)key alpha:(CGFloat)alpha style:(PKColorType)type;

+ (UIColor *)colorForKey:(id)key alpha:(CGFloat)alpha;

+ (UIColor *)shadowColorForKey:(id)key alpha:(CGFloat)alpha;


@end
