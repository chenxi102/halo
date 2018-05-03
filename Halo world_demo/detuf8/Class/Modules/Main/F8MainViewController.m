//
//  F8MainViewController.m
//  detuf8
//
//  Created by Seth on 2017/12/28.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8MainViewController.h"
#import "F8MainViewMode.h"
#import "F8PreViewViewController.h"

#import "HWFieldOutputViewController.h"
#import "HWHttpService.h"

@interface F8MainViewController ()
@property (nonatomic, strong) UIButton * mainButton;

@end

@implementation F8MainViewController

// MARK: LIFE CYCLE
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning]; }
- (void)dealloc { DeBugLog(@"dealloc"); }
- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
    [self refreshDataAndUIDisplay];
}
- (void)viewDidLoad {
    [super viewDidLoad];

    [HWHttpService shareInstance].host = @"http://118.26.132.162:8011";
//    [HWHttpService shareInstance].userid = @"79ac16da-6c5c-4f4f-aa4a-32297dcf36c8";
//    [HWHttpService shareInstance].userid = @"79ac16da-6c5c-4f4f-585452565";
//    [HWHttpService shareInstance].userid = @"f77ef322-f617-4c79-8df7-7e25de8cf545";
//    [HWHttpService shareInstance].userid = @"fb7055e6-08de-4af4-94a5-324be6c9f59d";
    [HWHttpService shareInstance].userid = @"0e03f4c0-9310-401c-9f20-37560af0ffab";
    
    [HWHttpService shareInstance].selfOre_methodVCClassStr = @"MethodVCClassStr";
    [HWHttpService shareInstance].reapOre_weburlStr = [NSString stringWithFormat:@"http://cjia.htsleep.com/index.html#/?userId=%@&host=%@",[HWHttpService shareInstance].userid, [HWHttpService shareInstance].host];
    [HWHttpService shareInstance].selfOreTitle = @"财富星球";
    [HWHttpService shareInstance].selfOre_userScoreStr = @"原力值";
    [HWHttpService shareInstance].selfOre_userAssetsStr = @"我的资产";
    [HWHttpService shareInstance].selfOre_userAssetsRecordtr = @"收支明细";
    [HWHttpService shareInstance].selfOre_methodStr = @"攻略秘籍";
    [HWHttpService shareInstance].stealOreTitle = @"偷星星";
    [HWHttpService shareInstance].stealOre_userScoreStr = @"我的算力";
    [HWHttpService shareInstance].stealOre_userAssetsStr = @"我的资产";
    [HWHttpService shareInstance].stealOre_methodStr = @"攻略秘籍";
    [HWHttpService shareInstance].luckOreTitle = @"摘星星";
    [HWHttpService shareInstance].reapOreTitle = @"摘星星";
    
    //MARK: UI
    {
        [self setupNav];
        [self setupMainBtn];
        [self registerNotify];
        self.view.backgroundColor = [UIColor grayColor];
    }
    
}

- (void)setupPlayer {
    
   
}

// MARK: SET UP UI
- (void)setupNav {
    UIView * navBackGround = [UIView new];
    navBackGround.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:navBackGround];
    [navBackGround mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@102);
    }];
    
    UIImageView * maxIconIMGV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MAX"]];
    [navBackGround addSubview:maxIconIMGV];
    [maxIconIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.bottom.equalTo(@-23);
    }];
    
    UILabel * maxTipLAB = [UILabel new];
    maxTipLAB.text = @"DETU MAX";
    maxTipLAB.font = [UIFont fontWithName:@"PingFangSC-Semibold" size:28];
    maxTipLAB.textColor = RGB_A(50, 52, 52, 1);
    [navBackGround addSubview:maxTipLAB];
    [maxTipLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@80);
        make.bottom.equalTo(@-21.5);
        make.height.equalTo(@36);
    }];
    
    UIButton * setBtn = [UIButton new];
    [setBtn setImage:[UIImage imageNamed:@"setting"] forState:UIControlStateNormal];
    [navBackGround addSubview:setBtn];
    [setBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.bottom.equalTo(@-32);
        make.width.height.equalTo(@30);
    }];
    @weak(self)
    [setBtn addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self)
        DeBugLog(@"set button click ...");
        [self.view showXHToastCenterWithText:@"开发中"];
    }];
}

- (void)setupMainBtn {
    @weak(self)
    if (!_mainButton) {
        _mainButton = [UIButton new];
        [_mainButton setImage:[UIImage imageNamed:@"拍照icon"] forState:UIControlStateNormal];
        [_mainButton setTitleColor:[UIColor darkGrayColor] forState:UIControlStateNormal];
        [_mainButton setBackgroundColor:[UIColor whiteColor]];
        _mainButton.cornerRadius = 22;
        [self.view addSubview:_mainButton];
        [_mainButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@145);
            make.height.equalTo(@44);
            make.bottom.equalTo(@-59.5);
            make.centerX.equalTo(@0);
        }];
        // MARK:主按钮功能
        [_mainButton addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strong(self);
            DeBugLog(@"main button click ...");
            [self performBlock:^{
//                [HWHttpService shareInstance].userid = @"79ac16da-6c5c-4f4f-aa4a-32297dcf36c8";
//                [HWHttpService shareInstance].userid = @"79ac16da-6c5c-4f4f-585452565";
                HWFieldOutputViewController * vc = [HWFieldOutputViewController new];
                [self.navigationController pushViewController:vc animated:YES];
            } afterDelay:.01];
        }];
    }
}


// MARK: notify  ： 1. 判断wifi  2.判断socket状态
- (void)registerNotify {
    @weak(self);
    // 接收WIFI状态改变的通知  非合格WIFI需要
    [[RACObserve([F8DeviceManager sharedInstance], curWifiName) skip:1]subscribeNext:^(id  _Nullable x) {
        @strong(self);
        if (!self.isTopViewController) {return;}
        if (![F8ActiveMonitor sharedInstance].ApplicationisActive) return ;
        [self performBlock:^{
            [self jugdeCameraConnectState];
        } afterDelay:0.01];
    }];
    
    // 接收APP前后台状态改变的通知  非合格WIFI需要刷新UI
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:applicationStateNotify object:nil] subscribeNext:^(NSNotification *notification) {
        @strong(self);
        if (!self.isTopViewController) {return;}
        // 进入活跃
        if ([F8ActiveMonitor sharedInstance].activeState.applicationStatus == ApplicationStatus_becomeActive)
        {
            [self performBlock:^{
                [self jugdeCameraConnectState];
            } afterDelay:0.01];
        }else if ([F8ActiveMonitor sharedInstance].activeState.applicationStatus == ApplicationStatus_resignActive){    // 失去活跃
            
        }
    }];
}

// 连接入口
- (void)jugdeCameraConnectState{
    DeBugLog(@"jugdeCameraConnectState");
    // 首次打开APP 判断：1. 是否连接相机 2.是否是同一台相机 3.连接是否断开
    // 连接了相机
    if ([F8DeviceManager sharedInstance].curConnDevice == F8WiFiType_F8)
    {
        // 还没记录
        if (!self.currentConnectWiFi) {
            [self connectCamera];
            return ;
        }
        // 没有切换相机
        else if ([[F8DeviceManager sharedInstance].curWifiName isEqualToString:self.currentConnectWiFi] ) {
            
            // 相机已经连接 或者正在建立连接
            SocketType type = [F8SocketAPI shareInstance].socketType;
            if (type == SocketConnected || type == SocketConnecting) {
                [self refreshDataAndUIDisplay];
                return ;
            }
            
            [self connectCamera];
            return ;
        }
        // 切换了相机
        [self connectCamera];
    }
    // 没有连接相机
    else  {
        DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:相机未连接" delay:2];)
        [self refreshDataAndUIDisplay];
    }
}

- (void)connectCamera {
    DeBugLog(@"connectCamera");
    [super connectCamera];
    DeveloperMode([self showSVProgressHUDWithStatus:@"TEST:连接相机中···" delay:20];)
    [_mainButton setImage:nil forState:UIControlStateNormal];
    [_mainButton setTitle:@"连接中···" forState:UIControlStateNormal];
    [F8MainViewMode connectCameraWithCallBack:^(SocketType type) {
        
        [self performBlock:^{
            [self refreshDataAndUIDisplay];
            if (type != SocketConnected) {
                DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:连接失败" delay:2];)
            }
        } afterDelay:0.01];
        
    } queryAndSetOptionWithCallBack:^(EN_RET_CODE_LIST EN_RET_CODE_LIST) {
        
        [self performBlock:^{
            [self dissSVProgressHUD];
            if (EN_RET_CODE_LIST == 0) {
                [[F8SocketAPI shareInstance]  setHeartBeatFireDate:3];
            } else {
                DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:连接失败" delay:2];)
            }
            [self refreshDataAndUIDisplay];
            
        } afterDelay:0.01];

    }];
}

- (void)cameraNotify:(F8SocketModel *)e {
    if (!self.isTopViewController) {return;}
    if (e) {
        
    }
}

- (void)CameraExceptionNotify:(NSNumber *)e {
    if (!self.isTopViewController) {return;}
    [self performBlock:^{
        if (e.intValue == SocketOfflineByWifiCut) {
            [self refreshDataAndUIDisplay];
            DeveloperMode(
                          [self showfailure_SVHUD_WithStatus:@"TEST:WIFI短线" delay:2];
                          );
        }else if (e.intValue == SocketOfflineByServer) {
            [self refreshDataAndUIDisplay];
            DeveloperMode(
                          [self showfailure_SVHUD_WithStatus:@"TEST:相机主动断开连接" delay:2];
                          );
        }
    } afterDelay:0.01];
}


- (void)refreshDataAndUIDisplay {
    
    if ([F8DeviceManager sharedInstance].curConnDevice == F8WiFiType_F8)
    {
        if ([F8SocketAPI shareInstance].socketType == SocketConnected)
        {
            [_mainButton setImage:[UIImage imageNamed:@"拍照icon"] forState:UIControlStateNormal];
            [_mainButton setTitle:@"" forState:UIControlStateNormal];
        }
        else if([F8SocketAPI shareInstance].socketType == SocketConnecting)
        {
            [_mainButton setImage:nil forState:UIControlStateNormal];
            [_mainButton setTitle:@"连接中···" forState:UIControlStateNormal];
        }
        else
        {
            [_mainButton setImage:nil forState:UIControlStateNormal];
            [_mainButton setTitle:@"连接相机" forState:UIControlStateNormal];
        }
    }
    else {
        [_mainButton setImage:nil forState:UIControlStateNormal];
        [_mainButton setTitle:@"设置WIFI" forState:UIControlStateNormal];
    }
}

- (IBAction)connect:(id)sender {
    [[HWHttpService shareInstance] getUserSelfFieldOutputNum:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
}

- (IBAction)disConnect:(id)sender {
    [[HWHttpService shareInstance] reapFieldWithOreId:@"e5a80374-d371-4422-8664-56bf454d7e45" Call:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
}

- (IBAction)takeCapture:(id)sender {
    [[HWHttpService shareInstance] getOtherResourcesList:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
    
}

- (IBAction)takeVideo:(id)sender {
    [[HWHttpService shareInstance] stealFieldWithOreId:@"021fbbe7-5d3c-4ef7-989d-068a7142cdfb" Call:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
}

- (IBAction)stopVideo:(id)sender {
    
    [[HWHttpService shareInstance] getluckyBoxGetLuckWithTokenType:@"LET" costTokenNum:@"2"  Call:^(NSData * _Nullable d, NSError * _Nullable e) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:d options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
    
    return;
    [[HWHttpService shareInstance] getUserDetailWithTokenType:@"" Call:^(NSData * _Nullable d, NSError * _Nullable e) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:d options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
}

@end
