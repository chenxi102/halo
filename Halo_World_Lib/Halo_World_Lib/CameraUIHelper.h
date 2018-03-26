//
//  CameraUIHelper.h
//  qumengTest
//
//  Created by 杜蒙 on 2017/3/3.
//  Copyright © 2017年 杜蒙. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>  


//强制横竖屏
#define CameraOrientationPortrait(portrait)\
SEL selector = NSSelectorFromString(@"setOrientation:");\
NSInvocation *invocation = [NSInvocation invocationWithMethodSignature:[UIDevice instanceMethodSignatureForSelector:selector]];\
[invocation setSelector:selector];\
[invocation setTarget:[UIDevice currentDevice]];\
int val = portrait;\
[invocation setArgument:&val atIndex:2];\
[invocation invoke];

//-----------------------------------------------------------------

//Application has localized display name     YES
//zh-Hant 繁体  zh-Hans 简体  en 英文
//en-CN英文  zh-Hans-CN简体    zh-Hant-CN繁体
/*
 获取系统的语言环境
 NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
 NSArray* languages = [defaults objectForKey:@"AppleLanguages"];
 NSString* preferredLang = [languages objectAtIndex:0];
 */

#define DTCameraSystemLanguage(key) \
({\
NSString *lang = [[NSUserDefaults standardUserDefaults] objectForKey:@"applanguage"];\
static NSMutableDictionary *bundles = nil;\
static dispatch_once_t onceToken;\
dispatch_once(&onceToken, ^{\
bundles = [NSMutableDictionary new];\
bundles[@"zh-Hant"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"zh-Hant" ofType:@"lproj"]];\
bundles[@"en"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"en" ofType:@"lproj"]];\
bundles[@"zh-Hans"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"zh-Hans" ofType:@"lproj"]];\
bundles[@"fr"] = [NSBundle bundleWithPath:[[NSBundle mainBundle]pathForResource:@"fr" ofType:@"lproj"]];\
});\
NSBundle *bundle = nil;\
if (lang) {\
bundle = bundles[lang];\
} else {\
bundle = [NSBundle mainBundle];\
}\
NSString *value = [bundle localizedStringForKey:key value:nil table:@"InfoPlist"];\
(value);\
})\


#define DTCameraSetSystemLanguage \
NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];\
NSArray* languages = [defaults objectForKey:@"AppleLanguages"];\
NSString* preferredLang = [languages objectAtIndex:0];\
if ([preferredLang isEqualToString:@"zh-Hans-CN"]){\
[defaults setValue:@"zh-Hans" forKey:@"applanguage"];\
} else if ([preferredLang isEqualToString:@"zh-Hant-CN"]){\
[defaults setValue:@"zh-Hant" forKey:@"applanguage"];\
} else {\
[defaults setValue:@"en" forKey:@"applanguage"];\
}\
[defaults synchronize];\

// 确定
#define DTCameraDialogOK            DTCameraSystemLanguage(@"dialogOK")

// 请连接网络进行下载
#define DTCameraFWWiFiCheck         DTCameraSystemLanguage(@"infoFWWiFiCheck")

// 更新APP吗?
#define DTCameraUpdateAPP           DTCameraSystemLanguage(@"infoUpdateAPP")

// 立刻更新
#define DTCameraUploadNow           DTCameraSystemLanguage(@"infoUploadNow")

// 系統檢測到有新固件，是否更新？
#define DTCameraHasNewFW            DTCameraSystemLanguage(@"infoHasNewFW")


// 系統檢測到固件已经废弃，前往官网更新
#define DTCameraDepreCatedFW        DTCameraSystemLanguage(@"infoDepreCatedFW")

// 系統檢測到服務端有新的相機固件版本，是否馬上下載?
#define DTCameraDownloadNowTitle    DTCameraSystemLanguage(@"infoDownloadNowTitle")

// 立刻下载
#define DTCameraDownloadNow         DTCameraSystemLanguage(@"infoDownloadNow")

// 稍后再更新
#define DTCameraUpdateLater         DTCameraSystemLanguage(@"infoUpdateLater")

// 命令超时，请检查相机是否异常!
#define DTCameraCommandTimedOut     DTCameraSystemLanguage(@"infoCommandTimedOut")

//连接全景相机 infoConnectPanoCamera
#define DTCamerainfoConnectPanoCamera    DTCameraSystemLanguage(@"infoConnectPanoCamera")

//提示与相机断开
#define DTCamerainfoDisconnectCamera   DTCameraSystemLanguage(@"infoDisconnectCamera")

//提示去设置连接相机连接相机
#define DTCameraInfoConnectWiFi     DTCameraSystemLanguage(@"infoConnectWiFi")

//固件升级
#define DTCameraFWTitleUpload       DTCameraSystemLanguage(@"infoFWTitleUpload")

// 固件下载
#define DTCameraFWDownloadn         DTCameraSystemLanguage(@"FWDownloadn")

// 开始升级
#define DTCameraFWUpdate            DTCameraSystemLanguage(@"FWUpdate")

// 更新过程中请保持手机和相机的WiFi连接，切勿退出
#define DTCameraFWUpdateNotice      DTCameraSystemLanguage(@"FWUpdateNotice")

// 固件已更新，相机重启后将自动安装更新。
#define DTCameraFWUpdateSuccess     DTCameraSystemLanguage(@"FWUpdateSuccess")

// 返回
#define DTCamerapageBack            DTCameraSystemLanguage(@"pageBack")

// 固件版本上传失败
#define DTCameraFWUpdatefailure     DTCameraSystemLanguage(@"FWUpdatefailure")

// 固件版本
#define DTCameraFirmwareVersion     DTCameraSystemLanguage(@"pageFirmwareVersion")

// 取消下载
#define DTCameraFWDownloadCancel    DTCameraSystemLanguage(@"FWDownloadCancel")


// 当前WiFi是蜂窝流量，文件偏大，请确认是否下载
#define DTCameraFWNOWiFiDownload    DTCameraSystemLanguage(@"infoFWNOWiFiDownload")

// 下载失败
#define DTCameraDownloadFailed      DTCameraSystemLanguage(@"infoDownloadFailed")

// 下载成功
#define DTCameraDownloadSuccess     DTCameraSystemLanguage(@"infoDownloadSuccess")

// 请连接相机升级
#define DTCameraConnectCameara      DTCameraSystemLanguage(@"infoConnectCameara")

// 固件已更新，相机重启后将自动安装更新
#define DTCameraFWUpdateSuccess     DTCameraSystemLanguage(@"FWUpdateSuccess")

// 固件版本上传失败
#define DTCameraFWUpdatefailure     DTCameraSystemLanguage(@"FWUpdatefailure")

// 固件版本校验中
#define DTCameraFWUpdateVerify     DTCameraSystemLanguage(@"FWUpdateVerify")

// 请取消下载后操作
#define DTCameraFWCancelDownload    DTCameraSystemLanguage(@"FWCancelDownload")

// 当前正在更新固件，是否退出
#define DTCamerainfoExitUpdate      DTCameraSystemLanguage(@"infoExitUpdate")




//好的
#define DTCameraOK                  DTCameraSystemLanguage(@"infoOK")

//取消
#define DTCameraCancel              DTCameraSystemLanguage(@"dialogCancel")

//提示
#define DTCameraTips                DTCameraSystemLanguage(@"dialogTips")

//拍照
#define DTCameraTakePhoto           DTCameraSystemLanguage(@"pageTakePhoto")

//录像
#define DTCameraVideo               DTCameraSystemLanguage(@"pageVideo")

//"长按启动相机，并开启WIFI打开手机设置，选择相机WIFI，输入密码并链接"
#define DTCameraCameraConnectExplain DTCameraSystemLanguage(@"pageCameraConnectExplain")

//先停止录像再进行其他操作
#define DTCameraStopVideoFirst      DTCameraSystemLanguage(@"infoStopVideoFirst")

//正在搜索设备
#define DTCameraSearchingDevice     DTCameraSystemLanguage(@"pageSearchingDevice")

// 如何连接
#define DTCameraHowToConnect        DTCameraSystemLanguage(@"pageHowToConnect")

//相机已经被他人连接
#define DTCameraConnectedByOthers   DTCameraSystemLanguage(@"infoCameraConnectedByOthers")

//拍照成功
#define DTCameraTakePhotoSuccess    DTCameraSystemLanguage(@"infoTakePhotoSuccess")

//拍照失败
#define DTCameraTakePhotoFailed     DTCameraSystemLanguage(@"infoTakePhotoFailed")

//录像成功
#define DTCameraVideoSuccess        DTCameraSystemLanguage(@"infoVideoSuccess")

//录像失败
#define DTCameraVideoFailed         DTCameraSystemLanguage(@"infoVideoFailed")

//分辨率
#define DTCameraResolution          DTCameraSystemLanguage(@"pageResolution")

//精细
#define DTCameraPicQualityHigh      DTCameraSystemLanguage(@"pagePicQualityHigh")

//标清
#define DTCameraPicQualityLow       DTCameraSystemLanguage(@"pagePicQualityLow")

//很好
#define DTCameraQualityMedium       DTCameraSystemLanguage(@"pagePicQualityMedium")

//画质
#define DTCameraPicQuality          DTCameraSystemLanguage(@"pagePicQuality")

//拍摄设置
#define DTCameraShootSettings       DTCameraSystemLanguage(@"pageShootSettings")

//录音
#define DTCameraRecord              DTCameraSystemLanguage(@"pageRecord")

//循环录像
#define DTCameraLoopVideo           DTCameraSystemLanguage(@"pageLoopVideo")

//视频分段时间
#define DTCameraEveryVideoTime      DTCameraSystemLanguage(@"pageEveryVideoTime")

//SD卡已经移除
#define DTCameraSDCardRemove        DTCameraSystemLanguage(@"infoSDCardRemove")

//相机电量过低，请及时充电
#define DTCameraPowerTooLow         DTCameraSystemLanguage(@"infoPowerTooLow")

//长按拍摄短视频
#define DTCameraShootShortVideo     DTCameraSystemLanguage(@"infoShootShortVideo")

//命令失败
#define DTCameraCommandFailed       DTCameraSystemLanguage(@"infoCommandFailed")

//连接失败
#define DTCameraConnectionFailed    DTCameraSystemLanguage(@"infoConnectionFailed")

//录像时间太短
#define DTCameraRecordTooShort      DTCameraSystemLanguage(@"infoRecordingTimeTooShort")

////////
//相機系統異常
#define DTCameraPRSystemError       DTCameraSystemLanguage(@"PRSystemError")
//相機接入USB，需要退出預覽"
#define DTCameraPRSystemUSB         DTCameraSystemLanguage(@"PRSystemUSB")
//相機接入HDMI，需要退出預覽
#define DTCameraPRSystemHDMI        DTCameraSystemLanguage(@"PRSystemHDMI")
//相機錄制中卡異常
#define DTCameraPRRecordSDError     DTCameraSystemLanguage(@"PRRecordSDError")
//相機錄制中系統異常
#define DTCameraPRRecordSystemError    DTCameraSystemLanguage(@"PRRecordSystemError")
//SD卡已滿
#define DTCameraPRRecordSDFull      DTCameraSystemLanguage(@"PRRecordSDFull")




@interface CameraUIHelper : NSObject
//加载cameradispatchservice模块的图片资源包里面的图片
+ (UIImage *)imageWithCameradispatchName:(NSString *)name;
+ (CGFloat)convertUnitWidthStand:(CGFloat)unit;
+ (CGFloat)convertUnitHeigthStand:(CGFloat)unit;
+ (UIImage *)imageWithZZNColor:(UIColor *)color alpha:(float)a;
+ (UIAlertController *)dialogBoxShow:(NSString *)message title:(NSString *)title;
@end
