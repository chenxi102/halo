//
//  F8DeviceManager.h
//  DeTuZZN
//
//  Created by Seth on 16/11/22.
//  Copyright © 2016年 DETU. All rights reserved.
//

/**
 iOS 链接 相机设备WIFI以后，监听到的是WWAN状态，在这个状态切换其他设备WIFI，是检测不到的。 因此 实现一个递归函数实时检测WIFI名
 */

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    F8WiFiType_F8,
    F8WiFiType_Other,
} F8WiFiType;

#define DEVICE_QUEUE "DEVICE_QUEUE_DETU_SERIAL"
UIKIT_EXTERN NSNotificationName const DTDeviceCameraDidChangedNotification;

//设备管理器 管理连接相机
@interface F8DeviceManager : NSObject

@property (nonatomic, copy) NSString * curWifiName ;                //当前连接的wifi名
@property (nonatomic, assign) F8WiFiType  curConnDevice ;           //当前连接的设备
@property (nonatomic, assign) F8WiFiType  preConnDevice ;           //上一次连接的设备
@property (nonatomic, copy) NSString * preDeviceName ;              //设备前置名称
@property (nonatomic, assign) BOOL isfirstConnect;                  //是否首次连接

+ (instancetype)sharedInstance;

- (void)config;

@end
