
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
#import "HWAssetsDetailedTableView.h"
#import "HWDataHandle.h"
#import "HWSVProgressHUD.h"
@interface HWAssetsDetailedView()

//@property (nonatomic, strong) F8assetsDetailedView * assetsDetailedView;
//@property (nonatomic, assign) F8ParamSetViewType paramSetViewType;
//@property (nonatomic, strong) UILabel * titleLAB;
//
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) HWAssetsDetailedTableView * assetsDetailedView;

@end

@implementation HWAssetsDetailedView
- (void)dealloc{
    NSLog(@"F8ParamSetView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"收支明细底图"].CGImage];
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
                self.assetsDetailedView.datas_mut = m;
                self.assetsDetailedView.noneDatatipLab.hidden = YES;
            }else self.assetsDetailedView.noneDatatipLab.hidden = NO;
        });
    }];
}

- (void)setup {
    
    _assetsDetailedView = [HWAssetsDetailedTableView new];
    [_assetsDetailedView.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"框"].CGImage];
    _assetsDetailedView.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.05];
    
//    _assetsDetailedView.clipsToBounds = YES;
//    _assetsDetailedView.layer.cornerRadius = 13;
    [self addSubview: _assetsDetailedView];
//    _assetsDetailedView.transform = CGAffineTransformMakeTranslation(0, 500);
    [_assetsDetailedView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.right.equalTo(@-30);
        make.top.equalTo(@90);
        make.bottom.equalTo(@-90);
    }];
    [self.assetsDetailedView.backBTN addTarget:self action:@selector(disappear) forControlEvents:UIControlEventTouchUpInside];
    self.assetsDetailedView.transform = CGAffineTransformMakeTranslation(0, HWSCREEN_HEIGHT);
    self.alpha = 0;
}

- (void)disappear
{
    [UIView animateWithDuration:.3 animations:^{
        self.assetsDetailedView.transform = CGAffineTransformMakeTranslation(0, HWSCREEN_HEIGHT);
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
        self.assetsDetailedView.transform = CGAffineTransformIdentity;
//        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];  蒙层
        self.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

@end
