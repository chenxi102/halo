//
//  HWStealFieldViewController.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/24.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWStealFieldViewController.h"
#import "HWDrawLotteryViewController.h"
#import "HWHttpService.h"
#import "HWMasonry.h"
#import "HWOreImageView.h"
#import "HWDataHandle.h"
#import "HWModel.h"
#import "HWButton.h"

@interface HWStealFieldViewController ()

@property (nonatomic, strong) UILabel * currentSocreLAB;
@property (nonatomic, strong) HWModel * DataModel;
@property (nonatomic, copy) NSArray <NSNumber*>* oreCenterPoint;           // 矿石中心点
@property (nonatomic, strong) NSMutableArray <HWOreImageView*>* oreMutArr;                  // 矿石UI 数组

@property (nonatomic, strong) HWButton * myResourceBTN;                    // 我的资产
@property (nonatomic, strong) HWButton * myDetailedBTN;                    // 明细
@property (nonatomic, strong) HWButton * searchResourceBTN;                // 搜索资源

@property (nonatomic, strong) UIButton * stealBTN;                         // 偷矿
@property (nonatomic, strong) UIButton * getLuckBTN;                       // 抽奖

@end

@implementation HWStealFieldViewController


// MARK: LIFE CYCLE
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning]; }
- (void)dealloc { NSLog(@"dealloc"); }
- (void)viewDidAppear:(BOOL)animated {[super viewDidAppear:animated];}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.oreMutArr = [NSMutableArray array];
    self.title = @"偷矿";
    float tap = HWSCREEN_WIDTH/10;
    self.oreCenterPoint = @[@((CGPoint){tap, 300}),@((CGPoint){3*tap, 300-tap}),@((CGPoint){3*tap, 300+tap}),@((CGPoint){5*tap,  300-2*tap}),@((CGPoint){5*tap, 300}),@((CGPoint){7*tap, 300-tap}),@((CGPoint){7*tap, 300+tap}),@((CGPoint){9*tap, 300})];
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
    _currentSocreLAB.textColor = HWRGB(0, 253, 253);
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
    NSInteger count = OreCountPerView;
    if (self.DataModel.ownOreList.count > OreCountPerView) {
        count = OreCountPerView;
    }else if (self.DataModel.ownOreList.count < OreCountPerView) {
        count = self.DataModel.ownOreList.count;
    }
    
    if (self.DataModel.ownOreList.count == 0) {
        [self showSVAlertHUDWithStatus:@"暂无数据" delay:1.5];
        return;
    }
    
    for (int i = 0; i < count; i++) {
        // MARK: 点击采矿
        HWOreImageView * ore = [[HWOreImageView alloc] initWithClickBLock:^(HWOreImageView* sender, oreListModel * model) {
            @HWstrong(self);
            @HWweak(self);
            __weak typeof(sender)wsend = sender;
            if (![model.supportHandle isEqualToString:@"2"]) {
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                   [self showSVAlertHUDWithStatus:@"这个矿偷不了！" delay:1.5];
                });
                return ;
            }
            [HWDataHandle stealOre:model res:^(BOOL b, NSString * m) {
                @HWstrong(self);
                __strong typeof(wsend)sender = wsend;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if (b) {
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [sender setOreNum:0.];
                            [sender setIsShake:NO];
                            [self.myResourceBTN popOutsideWithDuration:.5];
                            sender.hidden = YES;
                        });
                    } else {
                        [self showSVAlertHUDWithStatus:m delay:2];
                        NSLog(@"%@", m);
                    }
                });
            }];
        }];
        [self.view addSubview:ore];
        [self.oreMutArr addObject:ore];
        
        [ore HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
            @HWstrong(self);
            make.size.HWMAS_equalTo((CGSize){42.5, 58});
            make.centerX.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.x - HWSCREEN_WIDTH/2);
            make.centerY.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.y - HWSCREEN_HEIGHT/2);
        }];
        ore.model = self.DataModel.ownOreList[i];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dissSVProgressHUD];
        });
    }
}
//MARK: 我的资产、明细 UI
- (void)setUpmiddleButton {
    @HWweak(self);
    _myResourceBTN = [HWButton new];
    [_myResourceBTN setImage:[HWUIHelper imageWithCameradispatchName:@"我的财富"] forState:(UIControlStateNormal)];
    [self.view addSubview:_myResourceBTN];
    [_myResourceBTN addTarget:self action:@selector(myResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myResourceBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.right.equalTo(@-72);
        make.width.height.equalTo(@50);
        make.top.equalTo(self.currentSocreLAB.HWMAS_bottom).offset(10);
    }];
    
    UILabel * _myResourceLAB = [UILabel new];
    _myResourceLAB.font = [UIFont systemFontOfSize:12];
    _myResourceLAB.textColor = [UIColor whiteColor];
    _myResourceLAB.textAlignment = NSTextAlignmentCenter;
    _myResourceLAB.text = @"我的资产";
    [self.view addSubview:_myResourceLAB];
    [_myResourceLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.myResourceBTN.HWMAS_centerX);
        make.top.equalTo(self.myResourceBTN.HWMAS_bottom).offset(5);
    }];
    
    _myDetailedBTN = [HWButton new];
    [_myDetailedBTN setImage:[HWUIHelper imageWithCameradispatchName:@"资产明细"] forState:(UIControlStateNormal)];
    [self.view addSubview:_myDetailedBTN];
    [_myDetailedBTN addTarget:self action:@selector(myDetailClick:) forControlEvents:UIControlEventTouchUpInside];
    [_myDetailedBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.right.equalTo(@-10);
        make.width.height.equalTo(@50);
        make.top.equalTo(self.currentSocreLAB.HWMAS_bottom).offset(10);
    }];
    
    UILabel * _myDetailedLAB = [UILabel new];
    _myDetailedLAB.font = [UIFont systemFontOfSize:12];
    _myDetailedLAB.textColor = [UIColor whiteColor];
    _myDetailedLAB.textAlignment = NSTextAlignmentCenter;
    _myDetailedLAB.text = @"资产明细";
    [self.view addSubview:_myDetailedLAB];
    [_myDetailedLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.myDetailedBTN.HWMAS_centerX);
        make.top.equalTo(self.myDetailedBTN.HWMAS_bottom).offset(5);
    }];
    
    
    _searchResourceBTN = [HWButton new];
    [_searchResourceBTN setImage:[HWUIHelper imageWithCameradispatchName:@"搜索附近矿产"] forState:(UIControlStateNormal)];
    [self.view addSubview:_searchResourceBTN];
    [_searchResourceBTN addTarget:self action:@selector(otherResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchResourceBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.left.equalTo(@25);
        make.width.height.equalTo(@52);
        make.bottom.equalTo(@-140);
    }];
}

//MARK: 偷矿 抽奖 UI
- (void)setUpBottom {
    _stealBTN = [HWButton new];
    [_stealBTN setImage:[HWUIHelper imageWithCameradispatchName:@"偷币"] forState:(UIControlStateNormal)];
    [self.view addSubview:_stealBTN];
    [_stealBTN addTarget:self action:@selector(otherResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stealBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@44);
        make.width.equalTo(@73);
        make.height.equalTo(@54);
        make.bottom.equalTo(@-20);
    }];
    
    _getLuckBTN = [HWButton new];
    [_getLuckBTN setImage:[HWUIHelper imageWithCameradispatchName:@"挖矿"] forState:(UIControlStateNormal)];
    [self.view addSubview:_getLuckBTN];
    [_getLuckBTN addTarget:self action:@selector(getLuckClick:) forControlEvents:UIControlEventTouchUpInside];
    [_getLuckBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.right.equalTo(@-44);
        make.width.equalTo(@73);
        make.height.equalTo(@54);
        make.bottom.equalTo(@-20);
    }];
}

//MARK: 加载数据
- (void)extracted {
    @HWweak(self);
    [self showSVProgressHUDWithStatus:nil delay:20];
    [HWDataHandle loadOthersResource:^(BOOL abool, HWModel* model) {
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
// MARK: 我的资产点击事件
- (void)myResourceClick:(HWButton *)sender {
    
    [sender popOutsideWithDuration:0.5];
    Class cls = NSClassFromString(@"LKAssetVC");
    UIViewController * vc = [cls new];
    [self.navigationController pushViewController:vc animated:YES];
}
// MARK: 明细点击事件
- (void)myDetailClick:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
    Class cls = NSClassFromString(@"LKAssetVC");
    UIViewController * vc = [cls new];
    [self.navigationController pushViewController:vc animated:YES];
}
// MARK: 偷币点击事件
- (void)otherResourceClick:(HWButton *)sender {
    if (self.oreMutArr.count > 0) {
        for (HWOreImageView * m in self.oreMutArr) {
            [m setIsShake:NO];
            [m removeFromSuperview];
        }
        [self.oreMutArr removeAllObjects];
    }
    [self extracted];
}
// MARK: 抽奖点击事件
- (void)getLuckClick:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
    HWDrawLotteryViewController * vc = [HWDrawLotteryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)safeBack{
    for (HWOreImageView *_ in self.oreMutArr) {
        [_ setIsShake:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}
@end
