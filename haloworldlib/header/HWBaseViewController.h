//
//  HWBaseViewController.h
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWUIHelper.h"
#import "HWMasonry.h"
#define OreCountPerView      8    // 每个页面显示几个矿

@interface HWBaseViewController : UIViewController
@property (nonatomic, strong) UIButton * NavbackBTN;
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UILabel * NavLAB;
- (void)initNavBar;
//  自定义图片
- (void)showSVCustomeHUDWithImage:(UIImage *)img Status:(NSString *)str delay:(NSTimeInterval)delay;
// 纯文本
- (void)showSVAlertHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay;
// 菊花 + 文本
- (void)showSVProgressHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay;
// success + 文本
- (void)showSuccess_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;
// failure + 文本
- (void)showfailure_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;
// 隐藏
- (void)dissSVProgressHUD;
- (void)safeBack ;
@end
