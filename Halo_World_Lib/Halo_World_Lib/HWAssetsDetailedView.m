
//
//  HWAssetsDetailedView.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailedView.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"
#import "HWAssetsRecordTableView.h"
#import "HWAssetsDetailTableView.h"
#import "HWDataHandle.h"
#import "HWSVProgressHUD.h"
@interface HWAssetsDetailedView()

//@property (nonatomic, strong) F8assetsDetailedView * assetsDetailedView;
//@property (nonatomic, assign) F8ParamSetViewType paramSetViewType;
//@property (nonatomic, strong) UILabel * titleLAB;
//
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UIView * backGroundView;
@property (nonatomic, strong) HWAssetsRecordTableView * assetsRecordView;
@property (nonatomic, strong) HWAssetsDetailTableView * assetsDetailedView;


@property (nonatomic, strong) UIButton * backBTN;



@end

@implementation HWAssetsDetailedView
- (void)dealloc{
    NSLog(@"F8ParamSetView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
//        [self.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"收支明细底图"].CGImage];
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        [self setup];
        [self show];
        [self loadData];
//        [self addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    }
    return self;
}

- (void)loadData {
    @HWweak(self)
    [HWDataHandle loadUserSelfRecord:^(BOOL ab, NSString * s, NSMutableArray<HWRecordModel*>* m) {
        @HWstrong(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HWSVProgressHUD dismiss];
            if (ab&&m.count >0) {
                self.assetsRecordView.datas_mut = m;
                self.assetsRecordView.noneDatatipLab.hidden = YES;
            }
            else
            {
                self.assetsRecordView.noneDatatipLab.hidden = NO;
            }
        });
    }];
    
    [HWDataHandle loadUserSelfDetail:^(BOOL ab, NSString * s, NSMutableArray<HWRecordModel*>* m) {
        @HWstrong(self)
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [HWSVProgressHUD dismiss];
            if (ab&&m.count >0) {
                self.assetsDetailedView.datas_mut = m;
                self.assetsDetailedView.noneDatatipLab.hidden = YES;
            }
            else
            {
                self.assetsDetailedView.noneDatatipLab.hidden = NO;
            }
        });
    }];
}

- (void)setup {
    @HWweak(self)
    _backGroundView = [UIView new];
    [_backGroundView.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"我的资产弹窗背景"].CGImage];
    _backGroundView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    [self addSubview: _backGroundView];
    [_backGroundView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.equalTo(@-40);
        make.top.equalTo(@90);
        make.bottom.equalTo(@-90);
    }];
    
    _backBTN = [UIButton new];
    [_backBTN setBackgroundImage:[HWUIHelper imageWithCameradispatchName:@"关闭按钮"] forState:(UIControlStateNormal)];
    [_backGroundView addSubview:_backBTN];
    [_backBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self)
//        make.top.equalTo(self.backGroundView.HWMAS_top).offset(-15);
        make.top.equalTo(@-15);
//        make.right.equalTo(self.backGroundView.HWMAS_right).offset(15);
        make.right.equalTo(@15);
        make.width.height.equalTo(@40);
    }];
    
    UIButton *_backBTNMask = [UIButton new];
    _backBTNMask.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    [self addSubview:_backBTNMask];
    [_backBTNMask HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self)
        make.top.equalTo(self.backGroundView.HWMAS_top).offset(-20);
        make.right.equalTo(self.backGroundView.HWMAS_right).offset(20);
        make.width.height.equalTo(@60);
    }];
    
    
    _assetsDetailedView = [HWAssetsDetailTableView new];
    _assetsDetailedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.];
    [_backGroundView addSubview: _assetsDetailedView];
    [_assetsDetailedView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@0);
        make.height.equalTo(@160);
    }];
    
    _assetsRecordView = [HWAssetsRecordTableView new];
    _assetsRecordView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.];
    [_backGroundView addSubview: _assetsRecordView];
    [_assetsRecordView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self)
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(self.assetsDetailedView.HWMAS_bottom).offset(1);
        make.bottom.equalTo(@0);
    }];
    
    [_backBTNMask addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    self.backGroundView.transform = CGAffineTransformMakeTranslation(0, HWSCREEN_HEIGHT);
    self.alpha = 0;
}

- (void)disappear
{
    [UIView animateWithDuration:.3 animations:^{
        self.backGroundView.transform = CGAffineTransformMakeTranslation(0, HWSCREEN_HEIGHT);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)show {
    [UIView animateWithDuration:.5 animations:^{
        self.backGroundView.transform = CGAffineTransformIdentity;
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];  蒙层
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
