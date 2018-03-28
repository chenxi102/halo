//
//  HWBaseViewController.h
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWUIHelper.h"


@interface HWBaseViewController : UIViewController

@property (nonatomic, copy) NSString * title;

- (void)showSVProgressHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay;
- (void)showSuccess_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;
- (void)showfailure_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay;
- (void)dissSVProgressHUD;
- (void)safeBack ;
@end
