//
//  F8ParamSetHandle.m
//  detuf8
//
//  Created by Seth on 2018/3/14.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamSetHandle.h"

@implementation F8ParamSetHandle

+ (void)setParamCommandType:(ParamCommandType)type value:(float)value Res:(void(^)(int))res {
    
    switch (type) {
        case ParamCommandType_exp:
            [self setExp:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_iso:
            [self setISO:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_shutter:
            [self setShutter:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_wb:
            [self setWB:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_tep:
            [self setColorTemp:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_ev:
            [self setEV:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_hdr:
            [self setHDR:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_light:
            [self setBrightness:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_contrast:
            [self setContrast:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_sharpness:
            [self setSharpness:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_saturation:
            [self setSaturation:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_contentType:
            [self setContentType:value CommandType:ParamCommandType_exp Res:res];
            break;
        case ParamCommandType_resolution:
            [self setResolution:value CommandType:ParamCommandType_exp Res:res];
            break;
        default:
            break;
    }
}

// 复原所有曝光
+ (void)resetAllExpouseRes:(void(^)(int))res {
    
}

// 复原所有画质
+ (void)resetAllImageQualityRes:(void(^)(int))res {
    
}

// 复原所有照片设置
+ (void)resetAllPicSetRes:(void(^)(int))res {
    
}


+ (void)setISO:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool ISO:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicISO = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovISO = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setShutter:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool Shutter:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicShutter = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovShutter = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setExp:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPictureAEmode:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            [F8SocketAPI shareInstance].cameraInfo.exposure_mode = value;
        }
        if (res)res(m.rval);
    }];
}

+ (void)setWB:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    // 非自动
    if (value !=0 ) {
        // 自定义
        [[F8SocketAPI shareInstance] setPICorMOVIE:abool WB:1 WithResult:^(F8SocketModel *m) {
            if (m.rval == 0) {
                if (abool) {
                    [F8SocketAPI shareInstance].cameraInfo.PicWB = value;
                }else {
                    [F8SocketAPI shareInstance].cameraInfo.MovWB = value;
                }
                if (value != 1) {
                    if (abool) {
                        [F8SocketAPI shareInstance].cameraInfo.PicColorTemp = value;
                    }else {
                        [F8SocketAPI shareInstance].cameraInfo.MovColorTemp = value;
                    }
                    [self setColorTemp:value CommandType:type Res:nil];
                }
            }
            if (res)res(m.rval);
        }];
    }else
    {
        [[F8SocketAPI shareInstance] setPICorMOVIE:abool WB:0 WithResult:^(F8SocketModel *m) {
            if (m.rval == 0) {
                if (abool) {
                    [F8SocketAPI shareInstance].cameraInfo.PicWB = value;
                }else {
                    [F8SocketAPI shareInstance].cameraInfo.MovWB = value;
                }
            }
            if (res)res(m.rval);
        }];
    }
}

+ (void)setColorTemp:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool ColorTemp:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicColorTemp = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovColorTemp = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setEV:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool EV:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicEV = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovEV = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setHDR:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool HDR:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicHDR = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovHDR = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setSharpness:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool Sharpness:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicSharpness = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovSharpness = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setBrightness:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool Brightness:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicBrightness = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovBrightness = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setContrast:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool Contrast:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicContrast = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovContrast = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setSaturation:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setPICorMOVIE:abool Saturation:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            if (abool) {
                [F8SocketAPI shareInstance].cameraInfo.PicSaturation = value;
            }else {
                [F8SocketAPI shareInstance].cameraInfo.MovSaturation = value;
            }
        }
        if (res)res(m.rval);
    }];
}

+ (void)setContentType:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setCaptureEffect:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            [F8SocketAPI shareInstance].cameraInfo.contendMode = value;
        }
        if (res)res(m.rval);
    }];
}

+ (void)setResolution:(float)value CommandType:(ParamCommandType)type Res:(void(^)(int))res{
  
    [[F8SocketAPI shareInstance] setResolution:value WithResult:^(F8SocketModel *m) {
        if (m.rval == 0) {
            [F8SocketAPI shareInstance].cameraInfo.photoQuality = value;
        }
        if (res)res(m.rval);
    }];
}

// MARK: 重置
+ (void)restParamWithType:(F8ParamSetViewType)type Res:(void(^)(int))res  {
    switch (type) {
        case ParamCellType_expView:
            [self restExpourseRes:res];
            break;
        case ParamCellType_imgView:
            [self restPictureRes:res];
            break;
        case ParamCellType_resView:
            [self restBaseRes:res];
            break;
        default:
            break;
    }
}

// 曝光
+ (void)restExpourseRes:(void(^)(int))res  {
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setHeartBeatFireDate:-1];
    [[F8SocketAPI shareInstance] resetAE_PICorMOVIE:abool WithResult:^(F8SocketModel *a) {
        if (a.rval == 0) {
            [[F8SocketAPI shareInstance] resetAWB_PICorMOVIE:abool WithResult:^(F8SocketModel *b) {
                if (a.rval == 0) {
                    [[F8SocketAPI shareInstance] queryCameraStatesWithResult:^(F8SocketModel * c) {
                        if (res)res(c.rval);
                        [[F8SocketAPI shareInstance] setHeartBeatFireDate:3];
                    }];
                } else {
                    [[F8SocketAPI shareInstance] setHeartBeatFireDate:3];
                    if (res)res(a.rval);
                }
            }];
        }else {
            [[F8SocketAPI shareInstance] setHeartBeatFireDate:3];
            if (res)res(a.rval);
        }
    }];
}
// 画质
+ (void)restPictureRes:(void(^)(int))res  {
    BOOL abool = NO;
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo) {
        abool = YES;
    }
    [[F8SocketAPI shareInstance] setHeartBeatFireDate:-1];
    [[F8SocketAPI shareInstance] resetPicTure_PICorMOVIE:abool WithResult:^(F8SocketModel * a) {
        if (a.rval == 0) {
            [[F8SocketAPI shareInstance] queryCameraStatesWithResult:^(F8SocketModel * c) {
                if (res)res(c.rval);
                [[F8SocketAPI shareInstance] setHeartBeatFireDate:3];
            }];
        } else {
            [[F8SocketAPI shareInstance] setHeartBeatFireDate:3];
            if (res)res(a.rval);
        }
    }];
}
// 基础
+ (void)restBaseRes:(void(^)(int))res  {
    
}

@end
