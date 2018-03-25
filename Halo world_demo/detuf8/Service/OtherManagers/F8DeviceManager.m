
//
//  F8DeviceManager.m
//  DeTuZZN
//
//  Created by Seth on 16/11/22.
//  Copyright © 2016年 DETU. All rights reserved.
//

#import "F8DeviceManager.h"
#import <SystemConfiguration/CaptiveNetwork.h>


#define F8_Max_SSID            @"Detu-F4"
#define F8_Max_SSID_2          @"F8"
#define F8_Max_SSID_3          @"B73A50"

NSNotificationName const F8DeviceCameraDidChangedNotification = @"F8DeviceCameraDidChangedNotification";

@interface F8DeviceManager()

@property (nonatomic,copy) NSString *lastConnWifiName;//上一次的wifi名字
@property (atomic, strong, readwrite) dispatch_queue_t deviceQueue_serial ;
@property (nonatomic, assign) BOOL runLoop;
//@property (nonatomic, strong) STDPingServices *pingServices;

@end


@implementation F8DeviceManager


+ (instancetype) sharedInstance{
    static F8DeviceManager *obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[F8DeviceManager alloc] init];
        obj.deviceQueue_serial = dispatch_queue_create(DEVICE_QUEUE, DISPATCH_QUEUE_SERIAL);
        obj.runLoop = YES;
        obj.isfirstConnect = YES;
        obj.curConnDevice = F8WiFiType_Other;
        [obj runLoopForGetWIFIName];
    });
    return obj;
}

- (void)runLoopForGetWIFIName {
    @synchronized (self) {
        if (!self.runLoop)
            return;
        dispatch_async(self.deviceQueue_serial, ^{
            NSString * curWifiName = [self getCurrentWifiName];
            [self checkWifiName:curWifiName];
        });
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self runLoopForGetWIFIName];
        });
    }
}

- (void)config {
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationDidBecomeActiveNotification:) name:UIApplicationDidBecomeActiveNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(applicationWillResignActiveNotification:) name:UIApplicationWillResignActiveNotification object:nil];
    
}

- (void)applicationDidBecomeActiveNotification:(NSNotification *)notification {
    self.runLoop = YES;
    [self runLoopForGetWIFIName];
}

- (void)applicationWillResignActiveNotification:(NSNotification *)notification {
    self.runLoop = NO;
}


static NSString * previousWifiName = @"";

// 检测wifi名
- (void)checkWifiName:(NSString *)curWifiName {
    
    curWifiName = curWifiName.length ? curWifiName : @"3G/4G";
    
    if ([curWifiName.lowercaseString rangeOfString:F8_Max_SSID.lowercaseString].location != NSNotFound || [curWifiName.lowercaseString rangeOfString:F8_Max_SSID_2.lowercaseString].location != NSNotFound || [curWifiName.lowercaseString rangeOfString:F8_Max_SSID_3.lowercaseString].location != NSNotFound) {
        self.curConnDevice = F8WiFiType_F8;
    }else{
        self.curConnDevice = F8WiFiType_Other;
    }

    if ([curWifiName isEqualToString:previousWifiName] && curWifiName.length == previousWifiName.length) {
        return;
    }
   
    previousWifiName = curWifiName;
    self.preConnDevice = self.curConnDevice;
    self.lastConnWifiName = self.curWifiName;
    self.curWifiName = curWifiName.length ? curWifiName:@"3G/4G";
    
    DeBugLog(@"当前手机网络:%@",curWifiName);
    // 设备变更外发通知
    [[NSNotificationCenter defaultCenter] postNotificationName:F8DeviceCameraDidChangedNotification object:nil];
}

//获取当前WIFI名称
- (NSString *)getCurrentWifiName{
    NSString *wifiName = @"";
    CFArrayRef myArray = CNCopySupportedInterfaces();
    if (myArray != nil) {
        CFDictionaryRef myDict = CNCopyCurrentNetworkInfo(CFArrayGetValueAtIndex(myArray, 0));
        if (myDict != nil) {
            NSDictionary *dict = (NSDictionary*)CFBridgingRelease(myDict);
            wifiName = [dict valueForKey:@"SSID"];
        }
        CFRelease(myArray);
    }
    return wifiName;
}


@end
