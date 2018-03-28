//
//  HWFieldOutputViewController.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/24.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWFieldOutputViewController.h"
#import "HWHttpService.h"
#import "HWMasonry.h"
#import "HWOreImageView.h"
#import "HWDataHandle.h"
#import "HWModel.h"
#import "HWButton.h"

@interface HWFieldOutputViewController ()
@property (nonatomic, strong) UILabel * currentSocreLAB;
@property (nonatomic, strong) HWModel * DataModel;
@property (nonatomic, copy) NSArray <NSNumber*>* oreCenterPoint;           // 矿石中心点
@property (nonatomic, strong) NSMutableArray * oreMutArr;                  // 矿石UI 数组

@property (nonatomic, strong) HWButton * myResourceBTN;                    // 我的资产
@property (nonatomic, strong) HWButton * myDetailedBTN;                    // 明细

@property (nonatomic, strong) UIButton * stealBTN;                         // 偷矿
@property (nonatomic, strong) UIButton * getLuckBTN;                       // 抽奖

@end

@implementation HWFieldOutputViewController


// MARK: LIFE CYCLE
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning]; }
- (void)dealloc { NSLog(@"dealloc"); }
- (void)viewDidAppear:(BOOL)animated {[super viewDidAppear:animated];}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oreCenterPoint = @[@((CGPoint){30, 220}),@((CGPoint){80, 180}),@((CGPoint){85, 270}),@((CGPoint){150, 210}),@((CGPoint){210, 165}),@((CGPoint){214.5, 255}),@((CGPoint){290, 220}),@((CGPoint){292.5, 300})];
    [self extracted] ;
    [self setUpScoreLab];
    [self setUpmiddleButton];
    [self setUpBottom];
}
// MARK: =====UI Set Up================================================================
// MARK: 算力
- (void)setUpScoreLab {
    UIImageView * imgv = [UIImageView new];
    imgv.image = [HWUIHelper imageWithCameradispatchName:@"算力值框"];
    [self.view addSubview:imgv];
    [imgv HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.right.equalTo(@-10);
        make.top.equalTo(@(isIPhoneX?85:74));
        make.height.equalTo(@30);
        make.width.equalTo(@110);
    }];
    
    _currentSocreLAB = [UILabel new];
    _currentSocreLAB.text = @"当前算力: 0";
    _currentSocreLAB.textAlignment = NSTextAlignmentCenter;
    _currentSocreLAB.textColor = [UIColor whiteColor];
    _currentSocreLAB.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
    _currentSocreLAB.font = [UIFont systemFontOfSize:12];
    [_currentSocreLAB.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"算力值框"].CGImage];
    //    _currentSocreLAB.backgroundColor = [UIColor colorWithPatternImage:[HWUIHelper imageWithCameradispatchName:@"算力值框"]];
    [imgv addSubview:_currentSocreLAB];
    [_currentSocreLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}

// MARK: 矿石
- (void)setUpOre {
    
    @HWweak(self);
    NSInteger count = 8;
    if (self.DataModel.oreList.count > self.oreCenterPoint.count) {
        count = self.oreCenterPoint.count;
    }else if (self.DataModel.oreList.count < self.oreCenterPoint.count) {
        count = self.DataModel.oreList.count;
    }
    for (int i = 0; i < count; i++) {
        // MARK: 点击采矿
        HWOreImageView * ore = [[HWOreImageView alloc] initWithClickBLock:^(HWOreImageView* sender, oreListModel * model) {
            @HWstrong(self);
            @HWweak(self);
            __weak typeof(sender)wsend = sender;
            [HWDataHandle reapOre:model res:^(BOOL b, NSString * m) {
                @HWstrong(self);
                __strong typeof(wsend)sender = wsend;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (b) {
                        [sender setOreNum:0.];
                        [self.myResourceBTN popOutsideWithDuration:.5];
                    } else {
                        NSLog(@"%@", m);
                    }
                });
            }];
        }];
        [self.view addSubview:ore];
        [ore HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
            @HWstrong(self);
            make.size.HWMAS_equalTo((CGSize){42.5, 58});
            make.left.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.x);
            make.top.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.y);
        }];
        ore.model = self.DataModel.oreList[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dissSVProgressHUD];
        });
    }
}
//MARK: 我的资产、明细 UI
- (void)setUpmiddleButton {
    _myResourceBTN = [HWButton new];
    [_myResourceBTN setImage:[HWUIHelper imageWithCameradispatchName:@"我的财富"] forState:(UIControlStateNormal)];
    [self.view addSubview:_myResourceBTN];
    [_myResourceBTN addTarget:self action:@selector(myResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myResourceBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@30);
        make.width.height.equalTo(@52);
        make.bottom.equalTo(@-120);
    }];
}

//MARK: 偷矿 抽奖 UI
- (void)setUpBottom {
    
}

//MARK: 加载数据
- (void)extracted {
    @HWweak(self);
    [self showSVProgressHUDWithStatus:@"" delay:10];
    [HWDataHandle loadUserSelfFieldOutputNum:^(BOOL abool, HWModel* model) {
        @HWstrong(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (abool) {
                self.DataModel = model;
                _currentSocreLAB.text = [NSString stringWithFormat:@"当前算力: %.1f", model.score];
                [self setUpOre];
            }
        });
    }];
}

- (void)refreshData {
    
}

// MARK: ======ACTION===============================================================
- (void)myResourceClick:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
}
- (void)safeBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
