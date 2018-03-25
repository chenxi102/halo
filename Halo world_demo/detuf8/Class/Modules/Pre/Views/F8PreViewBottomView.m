//
//  F8PreViewBottomView.m
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8PreViewBottomView.h"


@interface F8PreViewBottomView ()

@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CAGradientLayer *cLayer;

@property (nonatomic, copy) void (^action_First)(void);
@property (nonatomic, copy) void (^action_Two)(void);
@property (nonatomic, copy) void (^action_Three)(void);


@end

@implementation F8PreViewBottomView

- (void)dealloc{
    DeBugLog(@"F8PreViewBottomView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    
    @weak(self)
    _backView = [UIView new];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    //------主按钮-------
    _mainBTN = [[UIButton alloc]init];
    [self addSubview:_mainBTN];
    [_mainBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.centerY.equalTo(@0).offset(4);
        make.width.equalTo(@60);
        make.height.equalTo(@60);
    }];
    [_mainBTN setBackgroundImage:[UIImage imageNamed:@"拍摄"] forState:UIControlStateNormal];
    _mainBTN.hidden = NO;
    
    //------相册-------
    _albumBTN = [[UIButton alloc]init];
    [self addSubview:_albumBTN];
    [_albumBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self)
        make.centerY.equalTo(self.mainBTN.mas_centerY);
        make.left.equalTo(@([AppUtil convertUnitWidthStand:35]));
        make.width.equalTo(@30);
        make.height.equalTo(@30);
    }];
    [_albumBTN setBackgroundImage:[UIImage imageNamed:@"相册"] forState:UIControlStateNormal];
    _albumBTN.hidden = NO;
    
    //------播放器模式-------
    _playerModeBTN = [[UIButton alloc]init];
    [self addSubview:_playerModeBTN];
    [_playerModeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self)
        make.centerY.equalTo(self.mainBTN.mas_centerY);
        make.right.equalTo(@(-[AppUtil convertUnitWidthStand:35]));
        make.width.equalTo(@32);
        make.height.equalTo(@32);
    }];
    [_playerModeBTN setBackgroundImage:[UIImage imageNamed:@"普通"] forState:UIControlStateNormal];
    [_playerModeBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self)
        [self playerModeNeedChanged:YES];
    }];
    _playerModeBTN.hidden = NO;
    [self playerModeNeedChanged:NO];
    
    //------模式-------
    _cameraModeView = [F8CameraModeView new];
    _cameraModeView.backgroundColor = RGB_A(7,7,7,0.58);
    _cameraModeView.layer.masksToBounds = YES;
    _cameraModeView.layer.cornerRadius = 14.5;
    [self addSubview:_cameraModeView];
    [_cameraModeView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerX.top.equalTo(@0);
        make.width.equalTo(@144);
        make.height.equalTo(@29);
    }];
    
    _cameraModeView.modeBlock = ^(F8CameraType type) {
        @strong(self)
        if (self.modeBlock) self.modeBlock(type);
        
        self.cameraModeView.cameraType = type;
        F8CameraModeStruct cameraModeStruct;
        cameraModeStruct = [F8SocketAPI shareInstance].cameraInfo.cameraModeStruct;
        cameraModeStruct.mode = type;
        [F8SocketAPI shareInstance].cameraInfo.cameraModeStruct = cameraModeStruct;
        [self refreshStates:cameraModeStruct];
    };
    
    //------录像计时-------
    self.timeCountLAB = [F8CameraTimerLabelAndRot new];
    self.timeCountLAB.layer.masksToBounds = YES;
    self.timeCountLAB.layer.cornerRadius = 13.5;
    [self addSubview: self.timeCountLAB];
    [self.timeCountLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self)
        make.centerX.equalTo(self.mas_centerX);
        make.top.equalTo(@0);
        make.width.equalTo(@105);
        make.height.equalTo(@27);
    }];
    self.timeCountLAB.hidden = YES;
}

- (void)layoutSubviews {
    if (!_cLayer) {
        _cLayer = [CAGradientLayer layer];
        _cLayer.frame = self.bounds;
        _cLayer.startPoint = CGPointMake(0, 0);
        _cLayer.endPoint = CGPointMake(0, 1);
        _cLayer.colors = @[(id)RGB_A(0, 0, 0, 0).CGColor, (id)RGB_A(0, 0, 0, 1).CGColor];
        [_backView.layer addSublayer:_cLayer];
    }
}

- (void)refreshStates:(F8CameraModeStruct)__struct {
    
    switch (__struct.mode) {
        case F8CameraType_photo:
        {
            self.cameraModeView.cameraType = F8CameraType_photo;
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"拍摄"] forState:UIControlStateNormal];
        }
            break;
        case F8CameraType_video:
        {
            self.cameraModeView.cameraType = F8CameraType_video;
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"录像"] forState:UIControlStateNormal];
        }
            break;
        case F8CameraType_live:
        {
            self.cameraModeView.cameraType = F8CameraType_live;
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"直播"] forState:UIControlStateNormal];
        }
            break;
        default:
            break;
    }
    
    
    switch (__struct.state) {
        case F8CameraShotState_None:
        {
            [self.timeCountLAB stopTimer];
            self.timeCountLAB.hidden = YES;
            self.cameraModeView.hidden = NO;
            self.albumBTN.hidden = NO;
        }
            break;
        case F8CameraShotState_Photo:
        {
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"等待"] forState:UIControlStateNormal];
        }
            break;
        case F8CameraShotState_StartVideo:
        {
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"等待"] forState:UIControlStateNormal];
        }
            break;
        case F8CameraShotState_VideoIng:
        {
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"录像中"] forState:UIControlStateNormal];
            self.albumBTN.hidden = YES;
            self.timeCountLAB.hidden = NO;
            self.cameraModeView.hidden = YES;
            [self.timeCountLAB startTimer];
        }
            break;
        case F8CameraShotState_StopVideo:
        {
            [self.mainBTN setBackgroundImage:[UIImage imageNamed:@"等待"] forState:UIControlStateNormal];
            self.timeCountLAB.hidden = NO;
            self.cameraModeView.hidden = YES;
            [self.timeCountLAB stopTimer];
        }
            break;
        case F8CameraShotState_TimeRecording:
        {
            
        }
            break;
        case F8CameraShotState_TimePhoto:
        {
            
        }
            break;
        case F8CameraShotState_Live:
        {
            
        }
            break;
        case F8CameraShotState_LiveStart:
        {
            
        }
            break;
        case F8CameraShotState_LiveIng:
        {
            
        }
            break;
        case F8CameraShotState_shrinkIng:
        {
            
        }
            break;
        default:
            break;
    }
}

- (void)playerModeNeedChanged:(BOOL)abool
{
    if (abool) {
       
    }else
    {
       
    }
}


@end




