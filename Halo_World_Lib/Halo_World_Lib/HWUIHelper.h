//
//  HWUIHelper.h
//  qumengTest
//
//  Created by 杜蒙 on 2017/3/3.
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  
#import "UIImage+Gif.h"

//强制横竖屏
#define CameraOrientationPortrait(portrait)\
SEL selector = NSSelectorFromString(@"setOrientation:");\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];\
[invocation setSelector:selector];\
[invocation setTarget:[UIDevice currentDevice]];\
int val = portrait;\
[invocation setArgument:&val atIndex:2];\
[invocation invoke];

//-----------------------------------------------------------------

//Application has localized display name     YES
//zh-Hant 繁体  zh-Hans 简体  en 英文
//en-CN英文  zh-Hans-CN简体    zh-Hant-CN繁体
/*
 获取系统的语言环境
 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
 NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
 NSString* preferredLang = [languages objectAtIndex:0];
 */

#define DTCameraSystemLanguage(key) \
({\
NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];\
static NSMutableDictionary *bundles = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
bundles = [NSMutableDictionary new];\
bundles[@"zh-Hant"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"zh-Hant" ofType:@"lproj"]];\
bundles[@"en"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"en" ofType:@"lproj"]];\
bundles[@"zh-Hans"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"zh-Hans" ofType:@"lproj"]];\
bundles[@"fr"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"fr" ofType:@"lproj"]];\
});\
NSBundle *bundle = nil;\
if (lang) {\
bundle = bundles[lang];\
} else {\
bundle = [NSBundle mainBundle];\
}\
NSString *value = [bundle localizedStringForKey:key value:nil table:@"InfoPlist"];\
(value);\
})\


#define DTCameraSetSystemLanguage \
NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];\
NSArray* languages = [defaults objectForKey:@"AppleLanguages"];\
NSString* preferredLang = [languages objectAtIndex:0];\
if ([preferredLang isEqualToString:@"zh-Hans-CN"]){\
[defaults setValue:@"zh-Hans" forKey:@"applanguage"];\
} else if ([preferredLang isEqualToString:@"zh-Hant-CN"]){\
[defaults setValue:@"zh-Hant" forKey:@"applanguage"];\
} else {\
[defaults setValue:@"en" forKey:@"applanguage"];\
}\
[defaults synchronize];\


// MARK: WeakSelf   StrongSelf
#define HWweak(...)   autoreleasepool {}__weak typeof(__VA_ARGS__) weakClass = __VA_ARGS__;
#define HWstrong(...)  autoreleasepool {}__strong typeof(__VA_ARGS__)__VA_ARGS__ = weakClass;


/**
 ===== UI ========================================================================================
 */
// MARK: color
//RGB颜色不透明
#define HWRGB(r,g,b)               [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:1]
//RGB   a-->颜色透明度
#define HWRGB_A(r,g,b,a)           [UIColor colorWithRed:r/255.0 green:g/255.0 blue:b/255.0 alpha:a]
//16进制颜色
#define HWHexColor(rgbValue)      [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]

#define HWSCREEN_WIDTH    [[UIScreen mainScreen] bounds].size.width //屏幕宽
#define HWSCREEN_HEIGHT   [[UIScreen mainScreen] bounds].size.height  //屏幕高

#define isIPhoneX     (HWSCREEN_WIDTH == 375.f && HWSCREEN_HEIGHT == 812.f)
#define IPhoneXTap      30.

@interface HWUIHelper : NSObject
//加载HWUIHelper模块的图片资源包里面的图片
+ (NSBundle *)haloBundle;
+ (UIImage *)imageWithCameradispatchGifName:(NSString *)name;
+ (UIImage *)imageWithCameradispatchName:(NSString *)name;
+ (CGFloat)convertUnitWidthStand:(CGFloat)unit;
+ (CGFloat)convertUnitHeigthStand:(CGFloat)unit;
+ (UIImage *)imageWithZZNColor:(UIColor *)color alpha:(float)a;
+ (UIAlertController *)dialogBoxShow:(NSString *)message title:(NSString *)title;
@end
