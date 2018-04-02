//
//  HWFieldOutputViewController.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/24.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWFieldOutputViewController.h"
#import "HWStealFieldViewController.h"
#import "HWDrawLotteryViewController.h"
#import "HWHttpService.h"
#import "HWMasonry.h"
#import "HWOreImageView.h"
#import "HWDataHandle.h"
#import "HWModel.h"
#import "HWButton.h"
#import "HWAssetsDetailedView.h"


@interface HWFieldOutputViewController ()
@property (nonatomic, strong) UILabel * currentSocreLAB;
@property (nonatomic, strong) HWModel * DataModel;
@property (nonatomic, copy) NSArray <NSNumber*>* oreCenterPoint;              // 矿石中心点
@property (nonatomic, strong) NSMutableArray <oreListModel *>* oreModelListMutArr; // 当前需要显示矿石模型数组：  涉及到翻页。
@property (nonatomic, strong) NSMutableArray <HWOreImageView *>* oreBtnMutArr;   // 矿石按钮 数组

@property (nonatomic, strong) HWButton * myResourceBTN;                    // 我的资产
@property (nonatomic, strong) HWButton * myDetailedBTN;                    // 明细

@property (nonatomic, strong) UIButton * stealBTN;                         // 偷矿
@property (nonatomic, strong) UIButton * getLuckBTN;                       // 抽奖
@property (nonatomic, assign) NSInteger curentPage;                        // 八个一页 当前哪一页
@property (nonatomic, assign) NSInteger totalPage;                         // 八个一页 总共多少页

@end

@implementation HWFieldOutputViewController


// MARK: LIFE CYCLE
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning]; }
- (void)dealloc {NSLog(@"%@  %s", [self class], __func__);}
- (void)viewDidAppear:(BOOL)animated {[super viewDidAppear:animated];}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
//    [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    [self.view.layer setContents:(id)[HWUIHelper imageWithCameradispatchName:@"底图"].CGImage];
    self.title = [HWHttpService shareInstance].selfOreTitle;
    self.curentPage = 1;
    self.oreBtnMutArr = [NSMutableArray array];
    self.oreModelListMutArr = [NSMutableArray array];
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
    for (int i = 0; i<OreCountPerView; i++) {
        NSInteger index =  i+ (self.curentPage-1) * OreCountPerView;
        if (index >= self.DataModel.ownOreList.count){
            break;
        }
        
        [self.oreModelListMutArr addObject:self.DataModel.ownOreList[index]];
    }
    
    if (self.DataModel.ownOreList.count == 0) {
        [self showSVAlertHUDWithStatus:@"暂无数据" delay:2];
        return;
    }
    
    for (int i = 0; i < OreCountPerView; i++) {
        // MARK: 点击采矿
        HWOreImageView * ore = [[HWOreImageView alloc] initWithClickBLock:^(HWOreImageView* sender, oreListModel * model) {
            @HWstrong(self);
            @HWweak(self);
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
            });
            __weak typeof(sender)wsend = sender;
            [HWDataHandle reapOre:model res:^(BOOL b, NSString * m) {
                @HWstrong(self);
                __strong typeof(wsend)sender = wsend;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        [self dissSVProgressHUD];
                    if (b) {
                        [sender setOreNum:0.];
                        [self.myResourceBTN popOutsideWithDuration:.5];
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            [sender setIsShake:NO];
                            sender.hidden = YES;
                            
                            // 清理数据， 判断是否需要翻页
                            [self.oreModelListMutArr removeObject:model];
                            if (self.oreModelListMutArr.count != 0) {
                                return ;
                            }
                            if (self.curentPage < self.totalPage) {
                                self.curentPage ++;
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self setUpOre];
                                });
                            }
                        });
                    } else {
                        [self showSVAlertHUDWithStatus:m delay:2];
                        NSLog(@"%@", m);
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.6 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                            
                            [sender setIsShake:NO];
                            sender.hidden = YES;
                            // 清理数据， 判断是否需要翻页
                            [self.oreModelListMutArr removeObject:model];
                            if (self.oreModelListMutArr.count != 0) {
                                return ;
                            }
                            if (self.curentPage < self.totalPage) {
                                self.curentPage ++;
                                
                                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                                    [self setUpOre];
                                });
                            }
                        });
                    }
                });
            }];
        }];
        
        [self.view addSubview:ore];
        [self.oreBtnMutArr addObject:ore];
        [ore HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
            @HWstrong(self);
            make.size.HWMAS_equalTo((CGSize){50, 58});
            make.centerX.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.x - HWSCREEN_WIDTH/2);
            make.centerY.HWMAS_equalTo(self.oreCenterPoint[i].CGPointValue.y - HWSCREEN_HEIGHT/2);
        }];
        
        // 配置数据
        if (self.oreModelListMutArr.count>i) {
            ore.model = self.oreModelListMutArr[i];
        } else {
            ore.hidden = YES;
            [ore setIsShake:NO];
        }
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self dissSVProgressHUD];
    });
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
    _myResourceLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
    _myResourceLAB.textColor = [UIColor whiteColor];
    _myResourceLAB.textAlignment = NSTextAlignmentCenter;
    _myResourceLAB.text = [HWHttpService shareInstance].selfOre_userAssetsStr;;
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
    _myDetailedLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
    _myDetailedLAB.textColor = [UIColor whiteColor];
    _myDetailedLAB.textAlignment = NSTextAlignmentCenter;
    _myDetailedLAB.text = [HWHttpService shareInstance].selfOre_assetsRecordStr;
    [self.view addSubview:_myDetailedLAB];
    [_myDetailedLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.myDetailedBTN.HWMAS_centerX);
        make.top.equalTo(self.myDetailedBTN.HWMAS_bottom).offset(5);
    }];
}

//MARK: 偷矿 抽奖 UI
- (void)setUpBottom {
    @HWweak(self)
    _stealBTN = [HWButton new];
    [_stealBTN setImage:[HWUIHelper imageWithCameradispatchName:@"偷币"] forState:(UIControlStateNormal)];
    [self.view addSubview:_stealBTN];
    [_stealBTN addTarget:self action:@selector(otherResourceClick:) forControlEvents:UIControlEventTouchUpInside];
    [_stealBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@50);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(@-36);
    }];
    
    UILabel * _stealLAB = [UILabel new];
    _stealLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
    _stealLAB.textColor = [UIColor whiteColor];
    _stealLAB.textAlignment = NSTextAlignmentCenter;
    _stealLAB.text = [HWHttpService shareInstance].stealOreTitle;
    [self.view addSubview:_stealLAB];
    [_stealLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.stealBTN.HWMAS_centerX);
        make.top.equalTo(self.stealBTN.HWMAS_bottom).offset(5);
    }];
    
    _getLuckBTN = [HWButton new];
    [_getLuckBTN setImage:[HWUIHelper imageWithCameradispatchName:@"挖矿"] forState:(UIControlStateNormal)];
    [self.view addSubview:_getLuckBTN];
    [_getLuckBTN addTarget:self action:@selector(getLuckClick:) forControlEvents:UIControlEventTouchUpInside];
    [_getLuckBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.right.equalTo(@-50);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(@-36);
    }];
    
    UILabel * _getLuckLAB = [UILabel new];
    _getLuckLAB.font = [UIFont fontWithName:@"Helvetica" size:12];
    _getLuckLAB.textColor = [UIColor whiteColor];
    _getLuckLAB.textAlignment = NSTextAlignmentCenter;
    _getLuckLAB.text = [HWHttpService shareInstance].reapOreTitle;
    [self.view addSubview:_getLuckLAB];
    [_getLuckLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        @HWstrong(self);
        make.centerX.equalTo(self.getLuckBTN.HWMAS_centerX);
        make.top.equalTo(self.getLuckBTN.HWMAS_bottom).offset(5);
    }];
}

//MARK: 加载数据
- (void)extracted {
    @HWweak(self);
    [self showSVCustomeHUDWithImage:[HWUIHelper imageWithCameradispatchName:@"timg"] Status:nil delay:15];
    [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
    [HWDataHandle loadUserSelfFieldOutputNum:^(BOOL abool, HWModel* model) {
        @HWstrong(self);
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.01 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            if (abool) {
                self.DataModel = model;
                self.totalPage = (model.ownOreList.count+OreCountPerView-1)/OreCountPerView;
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self showSVCustomeHUDWithImage:[HWUIHelper imageWithCameradispatchName:@"timg"] Status:nil delay:15];
        [self showSVCustomeHUDWithImage:[UIImage imageWithGIFNamed:@"加载页面GIF"] Status:nil delay:15];
    });
    HWAssetsDetailedView * assetsDetaileV = [HWAssetsDetailedView new];
    [self.view addSubview:assetsDetaileV];
    [assetsDetaileV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
}
// MARK: 偷币点击事件
- (void)otherResourceClick:(HWButton *)sender {
    
    HWStealFieldViewController * vc = [HWStealFieldViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}
// MARK: 抽奖点击事件
- (void)getLuckClick:(HWButton *)sender {
    [sender popOutsideWithDuration:0.5];
    HWDrawLotteryViewController * vc = [HWDrawLotteryViewController new];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)safeBack{
    for (HWOreImageView *_ in self.oreBtnMutArr) {
        [_ setIsShake:NO];
    }
    [self.navigationController popViewControllerAnimated:YES];
}

@end
