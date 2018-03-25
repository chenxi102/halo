//
//  F8BaseViewController.h
//  Tire pressure tirePressure
//
//  Created by Seth Chen on 2017/12/10.
//  Copyright © 2017年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F8BaseViewController : UIViewController

@property (nonatomic, copy) NSString * currentConnectWiFi;  // 记录当前连接的WIFI
@property (nonatomic, assign) BOOL isTopViewController;   // 当前页面是否是显示页面

// language notify
- (void)languageChanged;
- (void)registerNotify;
//  带菊花
- (void)showSVProgressHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay;
//  带成功图标
- (void)showSuccess_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;
//  带失败图标
- (void)showfailure_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;

- (void)dissSVProgressHUD;
- (void)connectCamera;
@end
