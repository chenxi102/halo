
//
//  HWBaseViewController.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWBaseViewController.h"
#import "HWMasonry.h"
#import "HWSVProgressHUD.h"

@interface HWBaseViewController ()

@end

@implementation HWBaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (UIStatusBarStyle)preferredStatusBarStyle {
    return UIStatusBarStyleLightContent;
}
- (void)viewWillDisappear:(BOOL)animated {[super viewWillDisappear:animated];}
- (void)viewDidLoad
{
    [super viewDidLoad];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)initNavBar
{
    UIView * NavbackV = [UIView new];
    NavbackV.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    [self.view addSubview:NavbackV];
    [NavbackV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.top.left.right.equalTo(@0);
        make.height.equalTo(@(isIPhoneX?75:64));
    }];
    
    UIButton * NavbackBTN = [UIButton new];
    UIImage * img = [HWUIHelper imageWithCameradispatchName:@"返回按钮"];
    [NavbackBTN setImage:img forState:(UIControlStateNormal)];
    [NavbackV addSubview:NavbackBTN];
    [NavbackBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(@0).offset(10);
        make.size.HWMAS_equalTo((CGSize){25, 25});
    }];
    self.NavbackBTN = NavbackBTN;
    
    @HWweak(self)
    UIControl * backC = [UIControl new];
    [NavbackV addSubview: backC];
    backC.backgroundColor = [UIColor clearColor];
    [backC HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self)
        make.centerX.equalTo(self.NavbackBTN.HWMAS_centerX);
        make.centerY.equalTo(self.NavbackBTN.HWMAS_centerY);
        make.size.HWMAS_equalTo((CGSize){44, 44});
    }];
    [backC addTarget:self action:@selector(safeBack) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel * NavLAB = [UILabel new];
    NavLAB.text = @"";
    NavLAB.textColor = [UIColor whiteColor];
    NavLAB.font = [UIFont systemFontOfSize:16];
    NavLAB.textAlignment = NSTextAlignmentCenter;
    [NavbackV addSubview:NavLAB];
    [NavLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0).offset(10);
    }];
    self.NavLAB = NavLAB;
}

- (void)setTitle:(NSString *)title {
    self.NavLAB.text = title;
}

- (void)safeBack{
    [self.NavbackBTN sendActionsForControlEvents:UIControlEventTouchUpInside];
}

//  纯文本
- (void)showSVAlertHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [HWSVProgressHUD setDefaultMaskType:HWSVProgressHUDMaskTypeNone];
    [HWSVProgressHUD showImage:[UIImage imageNamed:@""] status:str];
    [HWSVProgressHUD setFont:[UIFont fontWithName:@"Helvetica" size:15]];
    [HWSVProgressHUD setForegroundColor:HWRGB(0, 253, 253)];
    [HWSVProgressHUD dismissWithDelay:delay];
}

//  自定义图片
- (void)showSVCustomeHUDWithImage:(UIImage *)img Status:(NSString *)str delay:(NSTimeInterval)delay {
    [HWSVProgressHUD setDefaultMaskType:HWSVProgressHUDMaskTypeClear];
    [HWSVProgressHUD showImage:img status:str];
    [HWSVProgressHUD setBackgroundColor:[[UIColor clearColor]colorWithAlphaComponent:0]];
    [HWSVProgressHUD setImageViewSize:(CGSize){60, 60}];
    [HWSVProgressHUD dismissWithDelay:delay];
}

//  带菊花
- (void)showSVProgressHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [HWSVProgressHUD setDefaultMaskType:HWSVProgressHUDMaskTypeClear];
    [HWSVProgressHUD setStatus:str];
    [HWSVProgressHUD dismissWithDelay:delay];
}

//  带成功图标
- (void)showSuccess_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [HWSVProgressHUD setInfoImage:[UIImage imageNamed:@"Checkmark_ok"]];
    [HWSVProgressHUD setDefaultMaskType:HWSVProgressHUDMaskTypeClear];
//    [HWSVProgressHUD setBackgroundColor:[UIColor redColor]];
    [HWSVProgressHUD setImageViewSize:CGSizeMake(43, 43)];
    [HWSVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [HWSVProgressHUD showInfoWithStatus:str];
    [HWSVProgressHUD dismissWithDelay:delay];
}

//  带失败图标
- (void)showfailure_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [HWSVProgressHUD setInfoImage:[UIImage imageNamed:@"Checkmark_fail"]];
    [HWSVProgressHUD setDefaultMaskType:HWSVProgressHUDMaskTypeClear];
//    [HWSVProgressHUD setBackgroundColor:[UIColor redColor]];
    [HWSVProgressHUD setImageViewSize:CGSizeMake(43, 43)];
    [HWSVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [HWSVProgressHUD showInfoWithStatus:str];
    [HWSVProgressHUD dismissWithDelay:delay];
}

- (void)dissSVProgressHUD {
    [HWSVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
