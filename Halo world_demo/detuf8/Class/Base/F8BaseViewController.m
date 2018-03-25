//
//  F8BaseViewController.m
//  Tire pressure tirePressure
//
//  Created by Seth Chen on 2017/12/10.
//  Copyright © 2017年 JianYiMei. All rights reserved.
//

#import "F8BaseViewController.h"

@interface F8BaseViewController ()

@end

@implementation F8BaseViewController
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    self.isTopViewController = YES;
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    self.isTopViewController = NO;
}

- (void)viewDidLoad {
    
    [super viewDidLoad];
    [self.view.layer setContents:(id)[UIImage imageNamed:@"BGT"].CGImage];
    [self.view setBackgroundColor:[UIColor blackColor]];
    [self registerNotify];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(languageChanged) name:AppLanguageChangeNotify object:nil];
    
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:YES];
    }
    
//    [self.navigationController.navigationBar setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIColor whiteColor],NSForegroundColorAttributeName,[UIFont systemFontOfSize:18.0],NSFontAttributeName,nil]];
}

- (void)connectCamera {
    self.currentConnectWiFi = [F8DeviceManager sharedInstance].curWifiName;
}

- (void)languageChanged {
    
}

- (void)registerNotify {
    
}

//  带菊花
- (void)showSVProgressHUDWithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [SVProgressHUD setDefaultMaskType:SVProgressHUDMaskTypeClear];
    [SVProgressHUD showWithStatus:str];
    [SVProgressHUD dismissWithDelay:delay];
}

//  带成功图标
- (void)showSuccess_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"Checkmark_ok"]];
    [SVProgressHUD setImageViewSize:CGSizeMake(43, 43)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showInfoWithStatus:str];
    [SVProgressHUD dismissWithDelay:delay];
}

//  带失败图标
- (void)showfailure_SVHUD_WithStatus:(NSString *)str delay:(NSTimeInterval)delay {
    [SVProgressHUD setInfoImage:[UIImage imageNamed:@"Checkmark_fail"]];
    [SVProgressHUD setImageViewSize:CGSizeMake(43, 43)];
    [SVProgressHUD setFont:[UIFont systemFontOfSize:15]];
    [SVProgressHUD showInfoWithStatus:str];
    [SVProgressHUD dismissWithDelay:delay];
}

- (void)dissSVProgressHUD {
    [SVProgressHUD dismiss];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
