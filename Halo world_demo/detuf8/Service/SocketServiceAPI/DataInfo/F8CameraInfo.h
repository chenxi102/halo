//
//  F8CameraInfo.h
//  detuf8
//
//  Created by Seth on 2017/12/28.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F8Protocol.h"

/**
 * 拍照模式还是录制模式
 */
typedef enum : NSUInteger {
    F8CameraType_photo = 0,
    F8CameraType_video,
    F8CameraType_live
} F8CameraType;

/**
 * 拍摄状态
 */
typedef enum : NSUInteger{
    F8CameraShotState_None,
    F8CameraShotState_Photo,
    F8CameraShotState_StartVideo,
    F8CameraShotState_VideoIng,
    F8CameraShotState_StopVideo,
    F8CameraShotState_TimeRecording,
    F8CameraShotState_TimePhoto,
    F8CameraShotState_Live,
    F8CameraShotState_LiveStart,
    F8CameraShotState_LiveIng,
    F8CameraShotState_shrinkIng
}F8CameraShotState;

typedef struct {
    F8CameraType mode ;
    F8CameraShotState state ;
} F8CameraModeStruct;

@interface F8CameraInfo : NSObject

// 记录相机的模式
@property (nonatomic, assign) F8CameraModeStruct cameraModeStruct;
// 拍录返回的地址
@property (nonatomic, copy) NSArray *photosUrl;


// 测光模式
@property (nonatomic, assign) METERING_MODE_STATE metering_mode;
// 3A开关
@property (nonatomic, assign) BOOL cal_3a_switch;
// 标定
@property (nonatomic, copy) NSString *cailibrate;
// SD卡状态
@property (nonatomic, assign) SDCARD_STATE sdCardState;
// SD总内存
@property (nonatomic, assign) int totleSpace;
// SD剩余内存
@property (nonatomic, assign) int freeSpace;
@property (nonatomic, assign) int bat_current;
@property (nonatomic, assign) int bat_total;
// 是否插了适配器
@property (nonatomic, assign) BOOL adapter;

// 光源频率
@property (nonatomic, assign) int frequency;

// 缩时录影档位
@property (nonatomic, assign) int shrinkMode;

// MARK: =========================
// MARK: ISP

// 曝光模式 0 :手动 1: 自动 :   备注：视频模式没有
@property (nonatomic, assign) int exposure_mode;
// 快门时间
@property (nonatomic, assign) float PicShutter;
@property (nonatomic, assign) float MovShutter;

// 色温
@property (nonatomic, assign) float PicColorTemp;
@property (nonatomic, assign) float MovColorTemp;

// 开启/停止WDR
@property (nonatomic, assign) float PicWDR;
@property (nonatomic, assign) float MovWDR;

// EV档位
@property (nonatomic, assign) float PicEV;
@property (nonatomic, assign) float MovEV;

// iso档位
@property (nonatomic, assign) float PicISO;
@property (nonatomic, assign) float MovISO;

// 白平衡档位
@property (nonatomic, assign) float PicWB;
@property (nonatomic, assign) float MovWB;


// HDR
@property (nonatomic, assign) float PicHDR;
@property (nonatomic, assign) float MovHDR;

// 亮度
@property (nonatomic, assign) float PicBrightness;
@property (nonatomic, assign) float MovBrightness;

// 饱和度
@property (nonatomic, assign) float PicSaturation;
@property (nonatomic, assign) float MovSaturation;

// 对比度
@property (nonatomic, assign) float PicContrast;
@property (nonatomic, assign) float MovContrast;

// 锐度
@property (nonatomic, assign) float PicSharpness;
@property (nonatomic, assign) float MovSharpness;


// 内容类型 0 是2d 1是3d
@property (nonatomic,assign) int contendMode;

// 视频质量
@property (nonatomic,assign) int videoQuality;
// 照片质量
@property (nonatomic,assign) int photoQuality;

// MARK: =========================

// 现在拍摄模式，1为照片，2为视频, APP用来记录的模式
@property (nonatomic, assign) int nowRecordMode;
//// 是否显示实时预览
//@property (nonatomic, assign) BOOL isOpenedLiveStream;
// 相机录制时间
@property (nonatomic, assign) int nowMovieRecordingTime;
// 拍照倒计时时间
@property (nonatomic, assign) int nowDelayTakingPhotoTime;
// 录制倒计时时间
@property (nonatomic, assign) int nowDelayRecordingTime;
// 定时录像档位
@property (nonatomic, assign) int timingRec;
// 定时拍照档位
@property (nonatomic, assign) int timingPhoto;
// 循环拍照档位
@property (nonatomic, assign) int cyclePhoto;
// 关机档位
@property (nonatomic, assign) int powerOff;
// 电量档位
@property (nonatomic, assign) int battery;
// VF状态1是VF状态 0不是VF状态
@property (nonatomic,assign) int vfState;
// 序列号
@property (nonatomic, copy) NSString *seriesNumber;
// 固件版本
@property (nonatomic, copy) NSString *fwVersion;
// 路由应用版本
@property (nonatomic, copy) NSString *routerAppVer;
// 路由系统版本
@property (nonatomic, copy) NSString *routerSysVer;
// 相机固件
@property (nonatomic, copy) NSString *cameraSoftVer;
// 硬件标注
@property (nonatomic, copy) NSString *twinData;
// ssid
@property (nonatomic, copy) NSString * SSID;
// 密码
@property (nonatomic, copy) NSString * pwd;
// 视频分段
@property (nonatomic,copy) NSString *dtvideosplittime;

// 全屏LOG 数据
@property (nonatomic, strong) NSMutableString *dataStr;
@property (nonatomic, copy) NSString *curentStr;

// 数据初始化
- (void)initData;
// 重置
- (void)reset;
// 配置参数
- (void)saveCameraConfigData:(F8SocketModel*)m;
@end
