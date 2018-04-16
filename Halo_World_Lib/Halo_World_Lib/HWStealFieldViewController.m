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
#import "HWAssetsDetailedView.h"

@interface HWStealFieldViewController ()

@property (nonatomic, strong) UIView * backGroundView;                     // 背景图

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
- (void)dealloc {NSLog(@"%@  %s", [self class], __func__);}
- (void)viewDidAppear:(BOOL)animated {[super viewDidAppear:animated];}

- (void)viewDidLoad {
    self.backGroundView = [UIView new];
    [self.view addSubview:self.backGroundView];
    [self.backGroundView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    self.view.backgroundColor = [UIColor blackColor];
    [self.backGroundView.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"偷-背景图"].CGImage];
    
    [super viewDidLoad];
    
    self.oreMutArr = [NSMutableArray array];
    self.title = [HWHttpService shareInstance].stealOreTitle;
//    float tap = HWSCREEN_WIDTH/10;
    self.oreCenterPoint = @[@((CGPoint){99, 192.5}),@((CGPoint){153.5, 244}),@((CGPoint){225, 191.5}),@((CGPoint){295,  244}),@((CGPoint){79.5, 275.5}),@((CGPoint){145.5, 316}),@((CGPoint){211.5, 283}),@((CGPoint){292, 312.5})];

    [self extracted:YES] ;
//    [self setUpScoreLab];
    [self setUpmiddleButton];
    [self setUpBottom];
}
// MARK: =====UI Set Up================================================================
// MARK: 算力
- (void)setUpScoreLab {
    UIImageView * imgv = [UIImageView new];
    imgv.image = [HWUIHelper imageWithCameradispatchName:@"算力值框"];
    [self.backGroundView addSubview:imgv];
    [imgv HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.right.equalTo(@0);
        make.top.equalTo(@(isIPhoneX?85:74));
        make.height.equalTo(@30);
        make.width.equalTo(@125);
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
        [self showSVAlertHUDWithStatus:@"原力觉醒中···" delay:1.5];
        return;
    }
    
    for (int i = 0; i < count; i++) {
        // MARK: 点击采矿
        HWOreImageView * ore = [[HWOreImageView alloc] initWithClickBLock:^(HWOreImageView* sender, oreListModel * model) {
            @HWstrong(self);
            @HWweak(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
            });
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
                    [self dissSVProgressHUD];
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
        [self.backGroundView addSubview:ore];
        [self.oreMutArr addObject:ore];
        
        [ore HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
            @HWstrong(self);
            make.size.HWMAS_equalTo((CGSize){50, 58});
            make.centerX.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.x - HWSCREEN_WIDTH/2);
            make.centerY.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.y - HWSCREEN_HEIGHT/2);
        }];
        ore.model = self.DataModel.ownOreList[i];
    }
}
//MARK: 我的资产、明细 UI
- (void)setUpmiddleButton {
    @HWweak(self);
//    _myResourceBTN = [HWButton new];
//    [_myResourceBTN setImage:[HWUIHelper imageWithCameradispatchName:@"我的财富"] forState:(UIControlStateNormal)];
//    [self.view addSubview:_myResourceBTN];
//    [_myResourceBTN addTarget:self action:@selector(myResourceClick:) forControlEvents:UIControlEventTouchUpInside];
//    [_myResourceBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.left.equalTo(@24);
//        make.width.height.equalTo(@32);
//        //        make.top.equalTo(self.currentSocreLAB.HWMAS_bottom).offset(10);
//        make.top.equalTo(@(isIPhoneX?85:74));
//    }];
//    
//    UILabel * _myResourceLAB = [UILabel new];
//    _myResourceLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
//    _myResourceLAB.textColor = HWHexColor(0xfedb68);
//    _myResourceLAB.textAlignment = NSTextAlignmentCenter;
//    _myResourceLAB.text = [HWHttpService shareInstance].selfOre_userAssetsStr;;
//    [self.view addSubview:_myResourceLAB];
//    [_myResourceLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.centerX.equalTo(self.myResourceBTN.HWMAS_centerX);
//        make.top.equalTo(self.myResourceBTN.HWMAS_bottom).offset(10);
//    }];
//    
//    // 攻略秘籍
//    _myDetailedBTN = [HWButton new];
//    [_myDetailedBTN setImage:[HWUIHelper imageWithCameradispatchName:@"攻略秘籍按钮"] forState:(UIControlStateNormal)];
//    [self.view addSubview:_myDetailedBTN];
//    [_myDetailedBTN addTarget:self action:@selector(oreMethod:) forControlEvents:UIControlEventTouchUpInside];
//    [_myDetailedBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.left.equalTo(self.myResourceBTN.HWMAS_right).offset(28);
//        make.width.height.equalTo(@32);
//        make.top.equalTo(@(isIPhoneX?85:74));
//    }];
//    
//    UILabel * _myDetailedLAB = [UILabel new];
//    _myDetailedLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
//    _myDetailedLAB.textColor = HWHexColor(0x75dedd);
//    _myDetailedLAB.textAlignment = NSTextAlignmentCenter;
//    _myDetailedLAB.text = [HWHttpService shareInstance].selfOre_methodStr;
//    [self.view addSubview:_myDetailedLAB];
//    [_myDetailedLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.centerX.equalTo(self.myDetailedBTN.HWMAS_centerX);
//        make.top.equalTo(self.myDetailedBTN.HWMAS_bottom).offset(10);
//    }];
    
    // MARK: 搜索他人
    _searchResourceBTN = [HWButton new];
    [_searchResourceBTN setImage:[HWUIHelper imageWithCameradispatchName:@"换一换icon"] forState:(UIControlStateNormal)];
    [self.backGroundView addSubview:_searchResourceBTN];
    [_searchResourceBTN addTarget:self action:@selector(otherResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_searchResourceBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.top.equalTo(@65);
        make.width.height.equalTo(@33);
        make.right.equalTo(@-45);
    }];
    
    UILabel * _searchResourceLAB = [UILabel new];
    _searchResourceLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
    _searchResourceLAB.textColor = HWHexColor(0xfedb68);
    _searchResourceLAB.textAlignment = NSTextAlignmentCenter;
    _searchResourceLAB.text = @"换个星球偷";
    [self.backGroundView addSubview:_searchResourceLAB];
    [_searchResourceLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.searchResourceBTN.HWMAS_centerX);
        make.top.equalTo(self.searchResourceBTN.HWMAS_bottom).offset(5);
    }];
}

//MARK: 偷矿 抽奖 UI
- (void)setUpBottom {
    @HWweak(self)
    _stealBTN = [HWButton new];
    [_stealBTN setBackgroundImage:[HWUIHelper imageWithCameradispatchName:@"财富星球BUTTON"] forState:(UIControlStateNormal)];
    [_stealBTN setTitle:[HWHttpService shareInstance].selfOreTitle forState:UIControlStateNormal];
    [_stealBTN setTitleColor:HWHexColor(0xfedb68) forState:UIControlStateNormal];
    _stealBTN.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.backGroundView addSubview:_stealBTN];
    [_stealBTN addTarget:self action:@selector(myOreArealClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stealBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@36);
        make.width.equalTo(@114);
        make.height.equalTo(@44);
        make.bottom.equalTo(@-36);
    }];
    
//    UILabel * _stealLAB = [UILabel new];
//    _stealLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
//    _stealLAB.textColor = [UIColor whiteColor];
//    _stealLAB.textAlignment = NSTextAlignmentCenter;
//    _stealLAB.text = [HWHttpService shareInstance].selfOreTitle;
//    [self.backGroundView addSubview:_stealLAB];
//    [_stealLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.centerX.equalTo(self.stealBTN.HWMAS_centerX);
//        make.top.equalTo(self.stealBTN.HWMAS_bottom).offset(5);
//    }];
    
    _getLuckBTN = [HWButton new];
    [_getLuckBTN setBackgroundImage:[HWUIHelper imageWithCameradispatchName:@"摘星星BUTTON"] forState:(UIControlStateNormal)];
    [_getLuckBTN setTitle:[HWHttpService shareInstance].reapOreTitle forState:UIControlStateNormal];
    [_getLuckBTN setTitleColor:HWHexColor(0xd09cfc) forState:UIControlStateNormal];
    _getLuckBTN.titleLabel.font = [UIFont fontWithName:@"PingFangSC-Regular" size:16];
    [self.backGroundView addSubview:_getLuckBTN];
    [_getLuckBTN addTarget:self action:@selector(getLuckClick:) forControlEvents:UIControlEventTouchUpInside];
    [_getLuckBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.right.equalTo(@-36);
        make.width.equalTo(@114);
        make.height.equalTo(@44);
        make.bottom.equalTo(@-36);
    }];
    
//    UILabel * _getLuckLAB = [UILabel new];
//    _getLuckLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
//    _getLuckLAB.textColor = [UIColor whiteColor];
//    _getLuckLAB.textAlignment = NSTextAlignmentCenter;
//    _getLuckLAB.text = [HWHttpService shareInstance].reapOreTitle;
//    [self.backGroundView addSubview:_getLuckLAB];
//    [_getLuckLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        @HWstrong(self);
//        make.centerX.equalTo(self.getLuckBTN.HWMAS_centerX);
//        make.top.equalTo(self.getLuckBTN.HWMAS_bottom).offset(5);
//    }];
}

//MARK: 加载数据
- (void)extracted:(BOOL)isFirstLoad {
    @HWweak(self);
    [self showSVCustomeHUDWithImage:[HWUIHelper imageWithCameradispatchName:@"timg"] Status:nil delay:15];
    [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
    [HWDataHandle loadOthersResource:^(BOOL abool, HWModel* model) {
        @HWstrong(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dissSVProgressHUD];
            if (abool) {
                self.DataModel = model;
                _currentSocreLAB.text = [NSString stringWithFormat:@"当前算力: %.1f", model.score];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    @HWweak(self)
                    if (isFirstLoad) {
                        [self setUpOre];
                    }else{
                        [UIView transitionWithView:self.backGroundView duration:0.7 options:(UIViewAnimationOptionTransitionFlipFromRight) animations:nil completion:^(BOOL finished) {
                            @HWstrong(self);
                            [self setUpOre];
                        }];
                    }
                });
            }else {
                [self showSVAlertHUDWithStatus:@"原力觉醒中···" delay:1.5];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSVCustomeHUDWithImage:[HWUIHelper imageWithCameradispatchName:@"timg"] Status:nil delay:15];
        [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
    });
    HWAssetsDetailedView * assetsDetaileV = [HWAssetsDetailedView new];
    [self.backGroundView addSubview:assetsDetaileV];
    [assetsDetaileV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
// MARK: 攻略秘籍点击事件
- (void)oreMethod:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
    Class cls = NSClassFromString([HWHttpService shareInstance].selfOre_methodVCClassStr);
    UIViewController * vc = [cls new];
    [self.navigationController pushViewController:vc animated:YES];
}

// MARK: 偷币点击事件
- (void)otherResourceClick:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
    if (self.oreMutArr.count > 0) {
        for (HWOreImageView * m in self.oreMutArr) {
            [m setIsShake:NO];
            [m removeFromSuperview];
        }
        [self.oreMutArr removeAllObjects];
    }
    [self extracted:NO];
}

- (void)myOreArealClick:(HWButton *)sender {
    [self safeBack];
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
