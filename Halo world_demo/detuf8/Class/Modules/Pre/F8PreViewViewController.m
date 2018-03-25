//
//  F8PreViewViewController.m
//  detuf8
//
//  Created by Seth on 2018/3/1.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8PreViewViewController.h"
#import "F8PreViewNavView.h"
#import "F8PreViewSidebarView.h"
#import "F8PreViewBottomView.h"
#import "F8ParamSetView.h"


@interface F8PreViewViewController ()
@property (nonatomic, strong) F8PreViewNavView * navV;
@property (nonatomic, strong) F8PreViewSidebarView * sliderV;
@property (nonatomic, strong) F8PreViewBottomView * bottomV;

@end

@implementation F8PreViewViewController
- (void)dealloc {
    DeBugLog(@"F8PreViewViewController dealloc");
}
- (BOOL)prefersStatusBarHidden{return YES;}
- (void)didReceiveMemoryWarning {[super didReceiveMemoryWarning];}

// MARK: ======== LIFY CYCLE ===================================================================
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    [super connectCamera];
    [self initPlayerView];
    [self initNavBar];
    [self initSidebar];
    [self initBottombar];
    [self initPreiewState];
    //  1.注册相机推送的消息 2.注册监听与相机连接的socket状态
    {
        [[F8SocketAPI shareInstance] registerTargad:self CameraNotify:@selector(cameraNotify:)];
        [[F8SocketAPI shareInstance] registerTargad:self CameraExceptionNotify:@selector(CameraExceptionNotify:)];
    }
}

// MARK: INIT UI
- (void)initNavBar {
    @weak(self)
    F8PreViewNavView *navV = [F8PreViewNavView new];
    navV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.view addSubview:navV];
    [navV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.equalTo(@0);
        make.height.equalTo(@45.5);
    }];
    _navV = navV;
    
    navV.backAction = ^{
        @strong(self);
        [self previewSafeBack];
    };
}

- (void)initSidebar {
    @weak(self)
    F8PreViewSidebarView * rightSlider = [F8PreViewSidebarView new];
    rightSlider.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.view addSubview:rightSlider];
    [rightSlider mas_makeConstraints:^(MASConstraintMaker *make) {
        make.bottom.top.right.equalTo(@0);
        make.width.equalTo(@44);
    }];
    _sliderV = rightSlider;
    // MARK: 侧边栏点击事件
    // 曝光
    rightSlider.action_First = ^{
        @strong(self);
        @weak(self);
        if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_live) {
            [self.view showXHToastCenterWithText:@"开发中"];
            return ;
        }
        F8ParamSetView * paramSet = [[F8ParamSetView alloc] initWithParamSetViewType:ParamCellType_expView res:^(ParamCommandType t, int rval) {
            @strong(self);
            [self performBlock:^{
                [self dissSVProgressHUD];
            } afterDelay:0.01];
        } clickStartBlock:^(ParamCommandType t, float value) {
            @strong(self);
            [self performBlock:^{
                [self showSVProgressHUDWithStatus:nil delay:10];
            } afterDelay:0.01];
        }];
        
        [self.view addSubview:paramSet];
        [paramSet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    };
    // 画质
    rightSlider.action_Two = ^{
        @strong(self);
        @weak(self);
        if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_live) {
            [self.view showXHToastCenterWithText:@"开发中"];
            return ;
        }
        F8ParamSetView * paramSet = [[F8ParamSetView alloc] initWithParamSetViewType:ParamCellType_imgView res:^(ParamCommandType t, int rval) {
            @strong(self);
            [self performBlock:^{
                [self dissSVProgressHUD];
            } afterDelay:0.01];
        } clickStartBlock:^(ParamCommandType t, float value) {
            @strong(self);
            [self performBlock:^{
                [self showSVProgressHUDWithStatus:nil delay:10];
            } afterDelay:0.01];
        }];
        
        [self.view addSubview:paramSet];
        [paramSet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    };
    // 基础
    rightSlider.action_Three = ^{
        @strong(self);
        @weak(self);
        if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_live) {
            [self.view showXHToastCenterWithText:@"开发中"];
            return ;
        }
        F8ParamSetView * paramSet = [[F8ParamSetView alloc] initWithParamSetViewType:ParamCellType_resView res:^(ParamCommandType t, int rval) {
            @strong(self);
            [self performBlock:^{
                if (t == ParamCommandType_contentType) {
                    [self navRefresh];
                }
                [self dissSVProgressHUD];
            } afterDelay:0.01];
        } clickStartBlock:^(ParamCommandType t, float value) {
            @strong(self);
            [self performBlock:^{
                [self showSVProgressHUDWithStatus:nil delay:10];
            } afterDelay:0.01];
        }];
        
        [self.view addSubview:paramSet];
        [paramSet mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(@0);
        }];
    };
}

- (void)initBottombar {
    
    F8PreViewBottomView * bottomV = [F8PreViewBottomView new];
    bottomV.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    [self.view addSubview:bottomV];
    [bottomV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.bottom.right.equalTo(@0);
        make.height.equalTo(@155.5);
    }];
    _bottomV = bottomV;

    // MARK: 切换拍录直播模式
    @weak(self)
    _bottomV.modeBlock = ^(F8CameraType type) {
        @strong(self)
        NSString * tempStr;
        switch (type) {
            case F8CameraType_photo:
                tempStr = @"拍照模式";
                break;
            case F8CameraType_video:
                tempStr = @"录像模式";
                break;
            case F8CameraType_live:
                tempStr = @"直播模式";
                break;
            default:
                break;
        }
        [self.view showXHToastTopWithText:tempStr];
    };
    
    [bottomV.mainBTN addTarget:self action:@selector(mainButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV.albumBTN addTarget:self action:@selector(albumButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    [bottomV.playerModeBTN addTarget:self action:@selector(playerButtonClick:) forControlEvents:UIControlEventTouchUpInside];
    
    [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state];
}

- (void)initPlayerView {
    
}

- (void)removeAndreleasePlayer {
   
}

// MARK: ======== UI refresh ===================================================================
// bottom view
- (void)cameraDataFresh:(F8CameraType)type state:(F8CameraShotState)state
 {
     F8CameraModeStruct cameraModeStruct ;
     cameraModeStruct.mode = type;
     cameraModeStruct.state = state;
     [F8SocketAPI shareInstance].cameraInfo.cameraModeStruct = cameraModeStruct;
    [self.bottomV refreshStates:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct];
     if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_VideoIng) {
         [self.sliderV setHidden:YES];
     }else {
         [self.sliderV setHidden:NO];
     }
}
// nav view
- (void)navRefresh{
    [self.navV refreshStates];
    [self removeAndreleasePlayer];
    [self initPlayerView];
}
//
// MARK: ======== 监听 ===========================================================================
// MARK: 相机推送监听
- (void)cameraNotify:(F8SocketModel *)e {
    if (e) {
        
    }
}
// MARK:   WIFI监听
- (void)registerNotify {
    @weak(self);
    // 接收WIFI状态改变的通知  非合格WIFI需要
    [[RACObserve([F8DeviceManager sharedInstance], curWifiName) skip:1]subscribeNext:^(id  _Nullable x) {
        @strong(self);
        if (![F8ActiveMonitor sharedInstance].ApplicationisActive) return ;
        [self performBlock:^{
            [self jugdeCameraConnectState];
        } afterDelay:0.01];
    }];
    
    // 接收APP前后台状态改变的通知  非合格WIFI需要刷新UI
    [[[NSNotificationCenter defaultCenter] rac_addObserverForName:applicationStateNotify object:nil] subscribeNext:^(NSNotification *notification) {
        @strong(self);
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
// MARK: 相机异常监听
- (void)CameraExceptionNotify:(NSNumber *)e {
    @weak(self)
    [self performBlock:^{
        @strong(self)
        if (e.intValue == SocketOfflineByWifiCut) {
            DeveloperMode(
                          [self showfailure_SVHUD_WithStatus:@"TEST:WIFI断线" delay:2];
                          );
            [self performBlock:^{
                [self previewSafeBack];
            } afterDelay:2];
        }else if (e.intValue == SocketOfflineByServer) {
            DeveloperMode(
                          [self showfailure_SVHUD_WithStatus:@"TEST:相机主动断开连接" delay:2];
                          );
            [self performBlock:^{
                [self previewSafeBack];
            } afterDelay:2];
        }
    } afterDelay:0.01];
}

- (void)jugdeCameraConnectState {
    // 连接了相机
    if ([F8DeviceManager sharedInstance].curConnDevice == F8WiFiType_F8)
    {
         // 没有切换相机
        if ([[F8DeviceManager sharedInstance].curWifiName isEqualToString:self.currentConnectWiFi] ) {
            
            // 相机已经连接 或者正在建立连接
            SocketType type = [F8SocketAPI shareInstance].socketType;
            if (type == SocketConnected ) {
                [self initPreiewState];
            }else if ( type == SocketConnecting) {
                DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:相机连接中" delay:2];)
                return ;
            }
            // 未连接
            else {
                [self connectCamera];
            }
        }
        // 切换了相机
        else
        {
            DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:已经切换相机" delay:2];)
            [self performBlock:^{
                [self previewSafeBack];
            } afterDelay:2];
        }
        
    }
    // 没有连接相机
    else  {
        DeveloperMode([self showfailure_SVHUD_WithStatus:@"TEST:相机未连接" delay:2];)
        [self performBlock:^{
            [self previewSafeBack];
        } afterDelay:2];
    }
}
// MARK: ======== ACTION ==========================================================
- (void)initPreiewState {
    [[F8SocketAPI shareInstance] getRecordStateWithResult:^(F8SocketModel * m) {
        if (m.rval == 0) {
            NSString * state = (NSString *)m.param;
            if ([state isEqualToString:@"start"]) {
               
                [[F8SocketAPI shareInstance] getRecordTimeWithResult:^(F8SocketModel * m) {
                    if (m.rval == 0) {
                        long  time = ((NSNumber *)m.param).longValue;
                        [F8SocketAPI shareInstance].cameraInfo.nowMovieRecordingTime = (int)time;
                        [self performBlock:^{
                            [self cameraDataFresh:F8CameraType_video state:F8CameraShotState_VideoIng];
                        } afterDelay:.02];
                    }
                }];
            } else {
                [F8SocketAPI shareInstance].cameraInfo.nowMovieRecordingTime = 0;
                [self performBlock:^{
                    [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_None];
                } afterDelay:.02];
            }
        }
    }];
}
// MARK: UI ACTION : 拍录直播点击事件分发
- (void)mainButtonClick:(UIButton *)sender {
    
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        
        if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_None) {
            
            if ([F8SocketAPI shareInstance].cameraInfo.timingPhoto != 0) {
                // timing Photo
                return;
            }
            [self takePhoto];
            // normal photo
        } else {
            DeBugLog(@"模式错误");
        }
        
    } else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_video) {
        
        if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_None) {
            
            if ([F8SocketAPI shareInstance].cameraInfo.timingRec != 0) {
                // timing video
                return;
            }
            // normal video
            [self startMakeMovie];
        }else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_VideoIng){
            // stop video
            [self stopMakeMovie];
        }else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_TimeRecording){
            // stop timing video
        }
    } else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_live) {
        [self.view showXHToastCenterWithText:@"开发中"];
    }
}

//MARK: - 拍照
- (void)takePhoto {
    
    [self performBlock:^{
        [self showSVProgressHUDWithStatus:nil delay:30];
    } afterDelay:0];
    [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_Photo];
    
    @weak(self)
    [[F8SocketAPI shareInstance] takePhotoWithResult:^(F8SocketModel * m) {
        @strong(self)
        [self performBlock:^{
            if (m.rval == 0) {
                [self showSuccess_SVHUD_WithStatus:@"拍照成功" delay:2];
            } else {
                if (m.rval == -10000) {
                    [self showfailure_SVHUD_WithStatus:@"拍照超时" delay:2];
                }else
                    [self showfailure_SVHUD_WithStatus:@"拍照失败" delay:2];
            }
            [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_None];
        } afterDelay:.01];
    }];
}

//MARK: - 开始录像
- (void)startMakeMovie {
    @weak(self)
    [self performBlock:^{
        [self showSVProgressHUDWithStatus:nil delay:10];
    } afterDelay:0];
    [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_StartVideo];
    [[F8SocketAPI shareInstance] recordStartWithResult:^(F8SocketModel * m) {
        @strong(self)
        [self performBlock:^{
            [SVProgressHUD dismissWithDelay:.5];
            if (m.rval == 0) {
                [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_VideoIng];
            } else {
                [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_None];
            }
        } afterDelay:.01];
    }];
}

//MARK: - 停止录像
- (void)stopMakeMovie {
    @weak(self)
    // 录制时间不能低于5秒
    float currentRecordTime = [NSString stringWithFormat:@"%f",[self.bottomV.timeCountLAB.cameraTimerLabel getTimeCounted]].floatValue;
    if (currentRecordTime < 5 && currentRecordTime > 0 && [F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.state == F8CameraShotState_VideoIng) {
        DeBugLog(@"录制时间不能低于5秒");
        [self.view showXHToastCenterWithText:@"录像时间太短"];
        return;
    }
    [self performBlock:^{
        [self showSVProgressHUDWithStatus:nil delay:20];
    } afterDelay:0];
    [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_StopVideo];
    
    [[F8SocketAPI shareInstance] recordStopWithResult:^(F8SocketModel * m) {
        @strong(self)
        [self performBlock:^{
            [SVProgressHUD dismissWithDelay:0];
            if (m.rval == 0) {
                [self showSuccess_SVHUD_WithStatus:@"录像成功" delay:2];
            } else {
                [self showfailure_SVHUD_WithStatus:@"录像失败" delay:2];
            }
            [self cameraDataFresh:[F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode state:F8CameraShotState_None];
        } afterDelay:.5];
    }];
}

//MARK: - 缩时录影
- (void)takeVideoWithShrinkStartOrStop:(BOOL)startOrStop {
    [self.view showXHToastCenterWithText:@"开发中"];
}

//MARK: - 相册点击
- (void)albumButtonClick:(UIButton *)sender {
    [self.view showXHToastCenterWithText:@"开发中"];
}

//MARK: - 播放器模式切换
- (void)playerButtonClick:(UIButton *)sender {
    [self performBlock:^{
        
    } afterDelay:.2];
}

//MARK: - 安全返回
- (void)previewSafeBack {
    [self performBlock:^{
        [[F8SocketAPI shareInstance] disRegisterTargad:self];
        [self removeAndreleasePlayer];
        [self.bottomV.timeCountLAB.cameraTimerLabel removeFromSuperview];
        [self.navigationController popViewControllerAnimated:YES];
    } afterDelay:.01];
}

// MARK: ======= Delegate ==========================================================

@end
