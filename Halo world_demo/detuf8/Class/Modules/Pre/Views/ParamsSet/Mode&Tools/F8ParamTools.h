//
//  F8ParamTools.h
//  detuf8
//
//  Created by Seth on 2018/3/7.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@class F8ParamMode;

typedef NS_ENUM(NSInteger, F8ParamSetViewType) {
    ParamCellType_expView ,   // 分辨率
    ParamCellType_imgView ,   // 画质
    ParamCellType_resView     // 分辨率
};


typedef NS_ENUM(NSInteger, ParamCommandType) {
    ParamCommandType_exp ,
    ParamCommandType_iso ,
    ParamCommandType_shutter ,
    ParamCommandType_wb ,
    ParamCommandType_tep ,          // 色温
    ParamCommandType_ev ,           // 色温
    ParamCommandType_hdr ,
    ParamCommandType_light ,        // 亮度
    ParamCommandType_contrast ,     // 对比度
    ParamCommandType_sharpness ,    // 锐度
    ParamCommandType_saturation,    // 饱和度
    ParamCommandType_contentType ,  // 内容类型
    ParamCommandType_resolution,    // 分辨率
};






@interface F8ParamTools : NSObject
// 曝光
+ (F8ParamMode *)getPicEXPDataSource;
// ISO
+ (F8ParamMode *)getPicISODataSource;
+ (F8ParamMode *)getMovISODataSource;
// 快门时间
+ (F8ParamMode *)getPicShutterDataSource;
+ (F8ParamMode *)getMovShutterDataSource;
// 白平衡
+ (F8ParamMode *)getPicWBDataSource;
+ (F8ParamMode *)getMovWBDataSource;
// 色温
+ (F8ParamMode *)getPicTepDataSource;
+ (F8ParamMode *)getMovTepDataSource;
// EV
+ (F8ParamMode *)getPicEVDataSource;
+ (F8ParamMode *)getMovEVDataSource;



// HDR 宽动态
+ (F8ParamMode *)getPicHDRDataSource;
+ (F8ParamMode *)getMovHDRDataSource;
// brightness 亮度
+ (F8ParamMode *)getPicBrightnessDataSource;
+ (F8ParamMode *)getMovBrightnessDataSource;
// contrast 对比度
+ (F8ParamMode *)getPicContrastDataSource;
+ (F8ParamMode *)getMovContrastDataSource;
// sharpness 锐度
+ (F8ParamMode *)getPicSharpnessDataSource;
+ (F8ParamMode *)getMovSharpnessDataSource;
// saturation 饱和度
+ (F8ParamMode *)getPicSaturationDataSource;
+ (F8ParamMode *)getMovSaturationDataSource;



// 2d 3d
+ (F8ParamMode *)getContentDataSource ;
// 分辨率
+ (F8ParamMode *)getPicResDataSource ;
// 标准 快慢镜头
+ (F8ParamMode *)getMovSensorModeDataSource ;
@end
