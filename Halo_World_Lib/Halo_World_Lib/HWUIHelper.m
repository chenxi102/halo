//
//  HWUIHelper.m
//  qumengTest
//
//  Created by Seth on 2017/3/3.
//  Copyright © 2017年 Seth. All rights reserved.
//

#import "HWUIHelper.h"

@implementation HWUIHelper
+(NSBundle *)haloBundle{
    static NSBundle *bundle;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        NSString *path = [[NSBundle mainBundle]pathForResource:@"halo" ofType:@"bundle"];
        bundle = [NSBundle bundleWithPath:path] ;
    });
    return bundle;
}

+(UIImage *)imageWithCameradispatchGifName:(NSString *)name {
    if (name == nil)return nil;
    static NSMutableDictionary *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMutableDictionary new];
    });
    
    UIImage *image;
    image = cache[name];
    if (image) {
        return  image;
    }
    NSString *txt = name.pathExtension;
    if (txt.length == 0) {
        txt = @"gif";
    }
    NSString *path =  [[self haloBundle] pathForResource:name ofType:txt];
    NSData *data = [NSData dataWithContentsOfFile:path];
    image = [UIImage imageWithData:data];
    cache[name] = image;
    return image;
}

+(UIImage *)imageWithCameradispatchName:(NSString *)name{
    if (name == nil)return nil;
    static NSMutableDictionary *cache = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        cache = [NSMutableDictionary new];
    });
    int scaleint = 0;
    if ([UIScreen mainScreen].scale <=2) {
        scaleint = 2;
    } else {
        scaleint = 3;
     
    }
    NSString *scale = [NSString stringWithFormat:@"@%zix",scaleint];
    name = [name stringByAppendingString:scale];
    UIImage *image;
    image = cache[name];
    if (image) {
        return  image;
    }
    NSString *txt = name.pathExtension;
    if (txt.length == 0) {
        txt = @"png";
    }
    NSString *path =  [[self haloBundle] pathForResource:name ofType:txt];
    NSData *data = [NSData dataWithContentsOfFile:path];
    image = [UIImage imageWithData:data];
    cache[name] = image;
    return image;
}


+(CGFloat)convertUnitWidthStand:(CGFloat)unit
{
    CGFloat standarUnit = 375.;
    CGFloat standarUnitScale = [UIScreen mainScreen].bounds.size.width/standarUnit;
    return standarUnitScale*unit;
}

+(CGFloat)convertUnitHeigthStand:(CGFloat)unit
{
    CGFloat standarUnit = 667.;
    CGFloat standarUnitScale = [UIScreen mainScreen].bounds.size.height/standarUnit;
    return standarUnitScale*unit;
}

+ (UIImage *)imageWithZZNColor:(UIColor *)color alpha:(float )a {
    
    CGRect rect = CGRectMake(0, 0, 1, 1);
    
    UIGraphicsBeginImageContext(rect.size);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, [[color colorWithAlphaComponent:a] CGColor]);
    
    CGContextFillRect(context, rect);
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return image;
}

+ (UIAlertController *)dialogBoxShow:(NSString *)message title:(NSString *)title
{
    UIAlertAction * okAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
    }];
    UIAlertController * alert = [UIAlertController alertControllerWithTitle:title message:message preferredStyle:UIAlertControllerStyleAlert];

    [alert addAction:okAction];
    return alert;
}

@end
