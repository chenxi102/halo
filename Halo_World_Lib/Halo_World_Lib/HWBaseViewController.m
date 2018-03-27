
//
//  HWBaseViewController.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWBaseViewController.h"
#import "HWMasonry.h"

@interface HWBaseViewController ()
@property (nonatomic, strong) UILabel * NavLAB;
@property (nonatomic, strong) UIButton * NavbackBTN;
@end

@implementation HWBaseViewController
- (void)viewWillDisappear:(BOOL)animated {[super viewWillDisappear:animated];}
- (void)viewDidLoad
{
    [super viewDidLoad];
    [self.view.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"底图"].CGImage];
    [self initNavBar];
    if (!self.navigationController.navigationBarHidden) {
        [self.navigationController setNavigationBarHidden:NO];
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
    [NavbackBTN setImage:[HWUIHelper imageWithCameradispatchName:@"返回键"] forState:(UIControlStateNormal)];
    [NavbackV addSubview:NavbackBTN];
    [NavbackBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(@0).offset(10);
        make.size.HWMAS_equalTo((CGSize){15.5, 20.5});
    }];
    self.NavbackBTN = NavbackBTN;
    [NavbackBTN addTarget:self action:@selector(safeBack) forControlEvents:(UIControlEventTouchUpInside)];
    
    UILabel * NavLAB = [UILabel new];
    NavLAB.text = @"财富星球";
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
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


@end
