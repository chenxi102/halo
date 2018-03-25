//
//  F8SocketAPI.h
//  detuf8
//
//  Created by Seth on 2017/12/26.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F8SocketHandle.h"
#import "F8CameraInfo.h"

@interface F8SocketAPI : NSObject
@property (atomic, strong)  F8CameraInfo * cameraInfo;
@property (atomic, assign, readonly) SocketType socketType;

+ (instancetype)shareInstance;
/*
 @abstract  : 注册成为Api的监听者，监听相机端推送过来的消息
 @prama     : targad : 监听者      notifySel : 监听方法 V@:*(F8SocketModel)
 @notice    : 一个类可以多次注册不同的方法，都会生效。 类销毁之前需要 : disRegisterTargad
 */
- (void)registerTargad:(id)targad CameraNotify:(SEL)notifySel;

/*
 @abstract  : 注册成为Api的监听者，监听相机端连接的状态
 @prama     : targad : 监听者      notifySel : 监听方法 V@:*(NSNumber)
 @notice    : 一个类可以多次注册不同的方法，都会生效。 类销毁之前需要 : disRegisterTargad
 */
- (void)registerTargad:(id)targad CameraExceptionNotify:(SEL)notifySel;
/*
 @abstract  : 注销监听者
 */
- (void)disRegisterTargad:(id)targad ;

// MARK: 设置心跳: -1 是暂停
- (void)setHeartBeatFireDate:(NSTimeInterval)time ;
// MARK: 断开socekt
- (void)disConnectSocket;
// MARK: 连接socekt
- (void)connectCameraWithResult:(socketConnectCallback)res;
// MARK: 查询相机的配置参数
- (void)queryCameraStatesWithResult:(socketDataCallback)res;
// MARK: 设置相机时间
- (void)setSystemTimeWithResult:(socketDataCallback)res;
// MARK: 获取拍录状态
- (void)getRecordStateWithResult:(socketDataCallback)res;
// MARK: 获取拍录时间
- (void)getRecordTimeWithResult:(socketDataCallback)res;
// MARK: 拍照
- (void)takePhotoWithResult:(socketDataCallback)res;
// MARK: 开启录像
- (void)recordStartWithResult:(socketDataCallback)res;
// MARK: 结束录像
- (void)recordStopWithResult:(socketDataCallback)res;
// MARK: 设置模式命令 0代表video模式，1代表picture模式
- (void)setMediaMode:(int)mode WithResult:(socketDataCallback)res;

// MARK: 设置AE : 图片模式ae模式，0 – 自动AE模式，1 – 手动AE 模式
- (void)setPictureAEmode:(int)ae WithResult:(socketDataCallback)res ;
// MARK: 设置ISO
- (void)setPICorMOVIE:(BOOL)PICorMOVI ISO:(int)iso WithResult:(socketDataCallback)res ;
// MARK: 设置图片视频的EV
- (void)setPICorMOVIE:(BOOL)PICorMOVI EV:(float)ev WithResult:(socketDataCallback)res ;
// MARK: 设置色温
- (void)setPICorMOVIE:(BOOL)PICorMOVI ColorTemp:(int)temp WithResult:(socketDataCallback)res ;
// MARK: 设置快门时间
- (void)setPICorMOVIE:(BOOL)PICorMOVI Shutter:(float)shutter WithResult:(socketDataCallback)res ;
// MARK: 设置WB
- (void)setPICorMOVIE:(BOOL)PICorMOVI WB:(int)wb WithResult:(socketDataCallback)res ;

// MARK: ===重置 曝光 画质 等等 ================================================================================
- (void)resetAE_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res;
- (void)resetAWB_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res;
- (void)resetPicTure_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res ;
//- (void)setPICorMOVIE:(BOOL)PICorMOVI WB:(int)wb WithResult:(socketDataCallback)res ;


// MARK: 设置HDR
- (void)setPICorMOVIE:(BOOL)PICorMOVI HDR:(int)hdr WithResult:(socketDataCallback)res ;
// MARK: 设置亮度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Brightness:(int)Brightness WithResult:(socketDataCallback)res ;
// MARK: 设置饱和度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Saturation:(int)Saturation WithResult:(socketDataCallback)res ;
// MARK: 设置锐度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Sharpness:(int)Sharpness WithResult:(socketDataCallback)res ;
// MARK: 设置对比度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Contrast:(int)Contrast WithResult:(socketDataCallback)res ;

// MARK: Set capture effect   0代表2D模式，1代表3D模式
- (void)setCaptureEffect:(int)effect WithResult:(socketDataCallback)res ;

// MARK: 设置分辨率
- (void)setResolution:(int)resolution WithResult:(socketDataCallback)res ;

@end
