//
//  F8Protocol.h
//  detuf8
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#define SOCKET_RECONNECT_TIME           10                // socket重连次数连接
#define SOCKET_TIMEOUT                  5                 // socket连接超时时间
#define COMMAND_TIMEOUT_LONG            15                // socket耗时命令超时时间
#define COMMAND_TIMEOUT_SHORT           10                 // socket快速命令超时时间
#define F8_HOST                         @"192.168.155.200"  // socket host port
#define F8_PORT                         12006
#define F8RtspStream                    @"rtsp://192.168.155.101/live|rtsp://192.168.155.102/live|rtsp://192.168.155.103/live|rtsp://192.168.155.104/live"                          // rtsp流


typedef enum ERR_CODE_LIST {
    SESSION_HAVENOT_STARTED              = 1 ,
    SESSION_START_ALREADY                = 2 ,
    RET_SUCCESS                          = 0 ,
    RET_UNKNOWN_ERROR                    = -1 ,
    RET_SESSION_START_FAIL               = -2 ,
    RET_INVALID_TOKEN                    = -3 ,
    RET_REACH_MAX_CLNT                   = -4 ,
    JSON_PACKAGE_ERROR                   = -5 ,
    RET_OPERATION_UNSUPPORTED            = -7 ,
    RET_INVALID_OPERATION                = -8 ,
    RET_INVALID_OPERATION_VALUE          = -9 ,
    RET_NO_MORE_SPACE                    = -10 ,
    RET_CARD_PROTECTED                   = -11 ,
    RET_NO_MORE_MEMORY                   = -12 ,
    RET_CART_REMOVED                     = -13 ,
    RET_HDMI_INSERTED                    = -14 ,
    RET_SYSTEM_BUSY                      = -15 ,
    RET_F4PRO_NOT_READY                  = -16 ,
    
    RET_ERR_CODE_LAST
} EN_RET_CODE_LIST;

typedef enum CLIENT_MSGID_LIST {
    MSGID_UNKNOWN = 999,
    //session
    MSGID_START_SESSION                  = 1001,        //开启会话
    MSGID_STOP_SESSION                   = 1002,        //关闭会话
    MSGID_RESTART_SESSION                = 1003,        //
    MSGID_FORCE_CATCH_SESSION            = 1004,
    MSGID_HEARTBEAT                      = 1010,        //心跳
    MSGID_SESSION_KEEP_ALIVE             = 1011,        //防抢连
    
    MSGID_SET_MEDIA_MODE                 = 1101,        // Set media mode 备注：param：0代表video模式，1代表picture模式
    MSGID_GET_USER_CONFIGURE             = 1104,        // Get user configure 备注： 参数 0 获取当前的值，以及选项范围  /  参数 1 获取当前的值
    MSGID_GET_DEFAULT_CONFIG             = 1106,        // Get user default configure 备注： 默认配置
    MSGID_SET_CAPTURE_EFFECT             = 1107,        // Set capture effect 备注：param：0代表2D模式，1代表3D模式
    
// 5.3  Smart track
    MSGID_START_SMART_TRACT              = 1201,        // Start smart track 备注：param是初始矩形框信息，格式为”x,y,width,height”，需要转换到以10000为基准的大小

    MSGID_STOP_SMART_TRACT               = 1202,         // Stop smart track 备注：
// 5.4 Snapshot
    MSGID_START_SNAPSHOT                 = 2001,         // start Snapshot
    MSGID_STOP_SNAPSHOT                  = 2002,         // stop Snapshot
    MSGID_SET_SNAPSHOT_CHANNEL           = 2003,         // Set snapshot channel  备注：App端未实现，可选参数有”chn0”、”chn1”、”chn2”、”chn3”、”avs”、”avs1080P”和”allchn”。
    MSGID_SET_SNAPSHOT_DELAY_TIME        = 2005,         // Set snapshot delay time  备注：param可选值有0、3、10和30。
    MSGID_SET_SNAPSHOT_RESOLUTION        = 2007,         // Set snapshot resolution
    MSGID_SET_SNAPSHOT_SAVE_2D_PICTRUE_OR_NOT       = 2009,  // Set snapshot save 2d picture or not
    MSGID_SET_SNAPSHOT_SAVE_SOURCE_PICTRUE_OR_NOT   = 2011,  // Set snapshot save resource picture or not
//    MSGID_SET_SNAPSHOT_MODE              = 2005, // Set snapshot save 2d picture or not
    
// 5.5  Isp of picture mode
    MSGID_SET_PICTURE_AE_MODE            = 2101,         // ae 曝光： Set picture ae mode 备注：param：图片模式ae模式，0 – 自动AE模式，1 – 手动AE 模式
    MSGID_SET_PICTURE_EV                 = 2103,         // ev ： Set picture ae mode 备注：param：图片模式ev等级，值：-3.0f, -2.67f, -2.33f, -2.0f, -1.67f, -1.33f, -1.0f, -0.67f, -0.33f, 0.0f, 0.33f, 0.67f, 1.0f, 1.33f, 1.67f, 2.0f, 2.33f, 2.67f, 3.0f;
    MSGID_SET_PICTURE_ISO                = 2105,         // iso: Set picture iso 备注：param：图片模式ISO等级，值：100, 200, 400, 800, 1600, 3200, 6400
    MSGID_SET_PICTURE_SHUTTER_SPEED      = 2107,         // shutter speed: Set picture shutter speed 备注：param：图片模式快门等级，值：500.0f, 200.0f, 100.0f, 66.67f, 50.0f, 40.0f, 33.33f, 25.0f, 20.0f, 16.67f, 10.0f, 8.0f, 6.25f, 5.0f, 4.0f, 3.125f, 2.5f, 2.0f, 1.5625f, 1.125f, 1.0f, 0.8f, 0.625f, 0.5f, 0.4f, 0.3125f, 0.25f, 0.2f, 0.15625f, 0.125f
    MSGID_SET_PICTURE_AWB_MODE           = 2109,         // AWB: Set picture awb mode 备注：param：图片模式AWB模式，0-自动AWB，1-手动AWB
    MSGID_SET_PICTURE_COLOR_TEMPWEATURE  = 2111,         // 色温: Set picture awb mode 备注：param：图片模式色温等级，值：2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000
    MSGID_SET_PICTURE_BRIGHTNESS         = 2113,         // 图片亮度: Set picture brightness 备注：param：图片模式亮度等级，值：-100~100
    MSGID_SET_PICTURE_CONSTRAST          = 2115,         // 图片模式对比度: Set picture contrast 备注：param：图片模式对比度等级，值：-100~100
    MSGID_SET_PICTURE_HDR                = 2117,         // 图片模式宽动态等级: Set picture hdr 备注：param：图片模式宽动态等级，值：0~100
    MSGID_SET_PICTURE_SATURATION         = 2119,         // 图片模式饱和度: Set picture saturation 备注：param：图片模式饱和度等级，值：-100~100
    MSGID_SET_PICTURE_SHARPNESS          = 2121,         // 图片模式锐度等级: Set picture saturation 备注：param：图片模式锐度等级，值：-100~100
   
    MSGID_RESET_PIC_AE                   = 2123,
    MSGID_RESET_PIC_AWB                  = 2124,
    MSGID_RESET_PIC_QUALITY              = 2125,
    
    MSGID_RESET_VIDEO_AE                 = 2223,
    MSGID_RESET_VIDEO_AWB                = 2224,
    MSGID_RESET_VIDEO_QUALITY            = 2225,
    
    MSGID_SET_RECORD_STATE               = 2313,
    MSGID_GET_RECORD_STATE               = 2314,
//    这个是获取录像状态和时间的ID
    MSGID_SET_RECORD_TIME                = 2315,
    MSGID_GET_RECORD_TIME                = 2316,

    
    MSGID_SET_SYSTEM_TIME                = 1401,
    MSGID_GET_SYSTEM_TIME                = 1402,
    
//    这是设置系统时间的接口
    
// 5.6  Isp of video mode
    MSGID_SET_VIDEO_AE_MODE              = 2201,         // video ae 曝光： Set video ae mode 备注：param：视频模式ae模式，0 – 自动AE模式，1 – 手动AE 模式
    MSGID_SET_VIDEO_EV                   = 2203,         // video ev ： Set video ae mode 备注：param：视频模式ev等级，值：-3.0f, -2.67f, -2.33f, -2.0f, -1.67f, -1.33f, -1.0f, -0.67f, -0.33f, 0.0f, 0.33f, 0.67f, 1.0f, 1.33f, 1.67f, 2.0f, 2.33f, 2.67f, 3.0f;
    MSGID_SET_VIDEO_ISO                  = 2205,         // video iso: Set video iso 备注：param：视频模式ISO等级，值可选：100, 200, 400, 800, 1600, 3200, 6400
    
    MSGID_SET_VIDEO_SHUTTER_SPEED        = 2207,         // video shutter speed: Set video shutter speed 备注：param：视频模式快门等级，值：40.0f, 33.33f, 25.0f, 20.0f, 16.67f, 10.0f, 8.0f, 6.25f, 5.0f, 4.0f, 3.125f, 2.5f, 2.0f, 1.5625f, 1.125f, 1.0f, 0.8f, 0.625f, 0.5f, 0.4f, 0.3125f, 0.25f, 0.2f, 0.15625f, 0.125f

    MSGID_SET_VIDEO_AWB_MODE             = 2209,         // video AWB: Set video awb mode 备注：param：视频模式AWB模式，0-自动AWB，1-手动AWB
    MSGID_SET_VIDEO_COLOR_TEMPWEATURE    = 2211,         // video 色温: Set video color temperature 备注：param：视频模式色温等级，值：2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000
    MSGID_SET_VIDEO_BRIGHTNESS           = 2213,         // video 视频亮度: Set video brightness 备注：param：视频模式亮度等级，值：-100~100
    MSGID_SET_VIDEO_CONSTRAST            = 2215,         // video 视频模式对比度: Set video contrast 备注：param：视频模式对比度等级，值：-100~100
    MSGID_SET_VIDEO_HDR                  = 2217,         // video 视频模式宽动态等级: Set picture hdr 备注：param：视频模式宽动态等级，值：0~100
    MSGID_SET_VIDEO_SATURATION           = 2219,         // video 视频模式饱和度: Set picture saturation 备注：param：视频模式饱和度等级，值：-100~100
    MSGID_SET_VIDEO_SHARPNESS            = 2221,         // video 视频模式锐度等级: Set picture saturation 备注：param：视频模式锐度等级，值：-100~100
    
    
    
//   5.7  Record
    MSGID_START_RECORD                   = 2301,         // start Record
    MSGID_STOP_RECORD                    = 2302,         // stop Record
    MSGID_SET_RECORD_DELAY_TIME          = 2303,         // Set Record delay time  备注：param可选值有0、3、10和30。
    MSGID_SET_RECORD_MODE                = 2305,         // Set record mode
    MSGID_SET_RECORD_SAVE_2D_PICTRUE_OR_NOT       = 2307,  // Set Record save 2d picture or not
    MSGID_SET_RECORD_SAVE_SOURCE_PICTRUE_OR_NOT   = 2309,  // Set Record save resource picture or not
    MSGID_SET_RECORD_STREAM_TYPE         = 2311,         // Set record stream type
    
//    5.8  LiveView（直播）
    MSGID_RESET_VF                       = 7001         ,// RESET_VF
    MSGID_STOP_VF                        = 7002         ,// STOP_VF
    MSGID_SET_PREVIEW_SIZE               = 7003         ,// Set PREVIEW SIZE
//    MSGID_GET_PREVIEW_SIZE               = 7003         ,// Get preview size
    MSGID_SET_PREVIEW_QUALITY            = 7005         ,// Set preview quality/bitrate
    MSGID_GET_PREVIEW_QUALITY            = 7006         ,// Get preview quality
    MSGID_SET_PREVIEW_FPS                = 7007         ,// Set preview FPS
    MSGID_GET_PREVIEW_FPS                = 7008         ,// Get preview FPS
    MSGID_SET_PREVIEW_AUDIO_ONorOFF      = 7009         ,// Set preview audio on/off
    MSGID_GET_PREVIEW_AUDIO_ONorOFF      = 7010         ,// Get preview audio on/off

    
//   5.9  WIFI 设置
    MSGID_SET_WIFI_SYSTEM                = 8001         ,//SET WIFI SYSTEM
    MSGID_SET_WIFI_PASS                  = 8002         ,// Modify WIFI password
//   5.10  System （系统设置）
    
    MSGID_SET_POWER_OFF                  = 9001,        // Power off
    MSGID_SET_AUTO_POWER_OFF             = 9002,        // Auto Power off
    MSGID_RECOVER_FACTORY_SETTING        = 9003,        // Recover factory setting
    MSGID_GET_MAX_CAMERA_INFO            = 9004,        // Get Max camera information
    MSGID_GET_F4PEO_QUERY_ALL_CURRENT_SETTING   = 9005, // F4Pro Query all current settings
    MSGID_GET_MAX_CURRENT_RUN_STATU      = 9006,        // Get Max current run statu
    MSGID_GET_MAX_SD_CARD_STATE          = 9007,        // Get Max SD Card state
    MSGID_FORMAT_SD_CARD                 = 9008,        // Format SD card
    MSGID_SET_AUTO_SLEEP_TIME            = 9009,        // Set auto sleep time
    MSGID_SET_CAMERA_LIGHT_FREQUENCY     = 9016,        // Set camera light frequency
    MSGID_GET_CAMERA_LIGHT_FREQUENCY     = 9017,        // Get camera light frequency
    MSGID_GET_MAX_BATTERY_LEVEL          = 9101,        // Get Max battery level
    MSGID_GET_MAX_BOARD_TEMPERATURE      = 9102,        // Get Max board temperature
    MSGID_GET_USB_INSERTED_STATE_INorOUT        = 9103 ,        // Get USB inserted state in/out
    MSGID_SET_CAMERA_TIME                = 9104,        // 设置时间
    
    
//    5.11  Notification （定时通知）

    
    MSGID_notify_device_statu             = 6001,        //
    MSGID_notify_battery_statu            = 6002,        //
    MSGID_notify_temperature_statu        = 6003,        //
    
#if 0
    
    MSGID_CAMERA_CAPTURE                 = 2001,        //拍照
    MSGID_GET_PHOTO_AMOUNTS              = 2002,        //
    MSGID_SET_CAPTURE_SIZE               = 2003,        //-
    MSGID_GET_CAPTURE_SIZE               = 2004,        //-
    MSGID_SET_CAPTURE_QUALITY            = 2005,        //设置拍照质量
    MSGID_GET_CAPTURE_QUALITY            = 2006,        //获取拍照质量
    MSGID_SET_EXPOSURE_TIME              = 2007,        //设置快门速度（曝光时长）
    MSGID_GET_EXPOSURE_TIME              = 2008,        //
    MSGID_START_DELAY_CAPTURE            = 2009,        //开始定时拍照
    MSGID_CANCEL_DELAY_CAPTURE           = 2010,        //取消定时拍照
    MSGID_SET_DELAY_CAPTURE_TIME         = 2011,		//设置定时拍照时间
    MSGID_GET_DELAY_CAPTURE_TIME         = 2012,		//获取定时拍照时间
    MSGID_GET_DELAY_CAPTURE_REMAIN_TIME  = 2013,		//获取定时拍照剩余时间
    MSGID_GET_PHOTO_REMAIN_QUANTITY      = 2020,		//获取剩余拍照数量
    
    
    //image
    MSGID_SET_CAPTURE_ISO                = 2101,        //设置ISO
    MSGID_GET_CAPTURE_ISO                = 2102,        //获取ISO
    MSGID_SET_SCENCE                     = 2103,        //sunlight,//-
    MSGID_GET_SCENCE                     = 2104,        //sunlight,//-
    MSGID_SET_EFFECT_MODE                = 2105,
    MSGID_GET_EFFECT_MODE                = 2106,
    MSGID_SET_E_VALUE                    = 2107,        //设置EV值
    MSGID_GET_E_VALUE                    = 2108,        //获取EV值
    MSGID_SET_AWB                        = 2109,        //设置AWB
    MSGID_GET_AWB                        = 2110,        //获取AWB
    MSGID_SET_SHARPNESS                  = 2111,
    MSGID_GET_SHARPNESS                  = 2112,
    MSGID_SET_METERING                   = 2113,        //设置测光
    MSGID_GET_METERING                   = 2114,
    MSGID_SET_HDR                        = 2115,        //设置HDR
    MSGID_GET_HDR                        = 2116,        //获取HDR
    MSGID_SET_SHUTTER                    = 2117,        //设置快门时间
    MSGID_GET_SHUTTER                    = 2118,        //获取快门时间
    MSGID_SET_BRIGHTNESS                 = 2119,        //设置亮度
    MSGID_GET_BRIGHTNESS                 = 2120,        //获取亮度
    MSGID_SET_SATURATION                 = 2121,        //设置饱和度
    MSGID_GET_SATURATION                 = 2122,        //获取饱和度
    MSGID_SET_CONTRAST                   = 2123,        //设置对比度
    MSGID_GET_CONTRAST                   = 2124,        //获取对比度
    MSGID_SET_HUE                        = 2125,        //设置色度
    MSGID_GET_HUE                        = 2126,        //获取色度

    
    //recording
    MSGID_CAMERA_START_RECORD            = 3001,        //开始录制
    MSGID_CAMERA_STOP_RECORD             = 3002,        //停止录制
    MSGID_SET_RECORD_RESOLUTION          = 3003,        //-
    MSGID_GET_RECORD_RESOLUTION          = 3004,        //-
    MSGID_SET_RECORD_QUALITY             = 3005,        //设置录影质量
    MSGID_GET_RECORD_QUALITY             = 3006,        //获取录影质量
    MSGID_SET_RECORD_AUDIO               = 3007,		//
    MSGID_GET_RECORD_AUDIO               = 3008,		//-
    MSGID_SET_RECORD_LOOP                = 3009,		//
    MSGID_GET_RECORD_LOOP                = 3010,		//-
    MSGID_SET_RECORD_SPLIT_TIME          = 3011,        //
    MSGID_GET_RECORD_SPLIT_TIME          = 3012,        //-
    MSGID_SET_RECORD_TIMELAPSE           = 3013,        //设置缩时录影
    MSGID_GET_RECORD_TIMELAPSE           = 3014,        //获取缩时录影
    MSGID_START_DELAY_RECORD             = 3015,        //开启定时录影
    MSGID_CANCEL_DELAY_RECORD            = 3016,        //取消定时录影
    MSGID_GET_DELAY_RECORD_REMAIN_TIME 	 = 3017,		//获取定时录影倒计时时间
    MSGID_SET_DELAY_RECORD_TIME          = 3018,		//设置定时录影时长
    MSGID_GET_DELAY_RECORD_TIME          = 3019,
    MSGID_GET_RECORDING_TIME_COUNT       = 3020,	 	//获取当前录制时间
    MSGID_GET_RECORD_REMAIN_TIME_COUNT   = 3021,		//获取剩余可录影时长
    MSGID_CHECK_CAP_REC  				 = 3022,        //探测相机状态

    //notification
    MSGID_NOTIFY_F8_BOOT_SUCCESS      = 5001,
    MSGID_NOTIFY_F8_BOOT_FAILED       = 5002,
    MSGID_NOTIFY_DELAY_CAPTURE_TIMECOUNT = 5003,        //定时拍照倒计时时间
    MSGID_NOTIFY_DELAY_RECORD_TIMECOUNT  = 5004,        //定时录制倒计时时间
    MSGID_NOTIFY_START_CAPTURE           = 5005,        //定时倒计时拍照启动
    MSGID_NOTIFY_START_RECORD            = 5006,        //定时倒计时录制启动
    MSGID_NOTIFY_STOP_RECORD             = 5007,        //
    MSGID_NOTIFY_RECORD_TIMECOUNT        = 5008,        // 录影时间
    
    MSGID_NOTIFY_BATTERY                 = 5009,        //电量notify
    MSGID_NOTIFY_TEMPERATURE             = 5010,        //温度notify
    MSGID_NORIFY_SDCARD_CAPACITY         = 5011,        //卡剩余容量
    MSGID_NOTIFY_RECORD_ABORT            = 5015,        //相机通知录像终止开始
    MSGID_NOTIFY_RECORD_ABORT_FINISHED   = 5016,        //相机通知录像终止结束
    MSGID_NOTIFY_ENTER_STANDBY           = 5020,        //相机通知进入休眠
    MSGID_NOTIFY_EXIT_STANDBY            = 5021,        //相机通知退出休眠
    MSGID_NOTIFY_ENTER_USB_MSC           = 5022,        //usb通知
    MSGID_NOTIFY_SD_REMOVE          	 = 5023,        //卡移除
    MSGID_NOTIFY_SD_INSERT          	 = 5024,        //卡插入
    MSGID_NOTIFY_SD_FULL          	     = 5025,        //卡满
    MSGID_NOTIFY_SD_LOW_SPEED          	 = 5026,        //低速卡
    MSGID_NOTIFY_SD_ERROR          	     = 5027,        //卡错误
    MSGID_NOTIFY_DC_IN         	         = 5028,        //电源插入
    MSGID_NOTIFY_DC_OUT          	     = 5029,        //电源拔出
    MSGID_NOTIFY_POWER_OFF          	 = 5030,        //关机

    
    //live view /pre stream /rtsp server
    MSGID_RESET_VF                       = 7001,        //重置VF（开关流）
    MSGID_STOP_VF                        = 7002,        //停止VF（开关流）
    MSGID_SET_PREVIEW_SIZE               = 7003,
    MSGID_GET_PREVIEW_SIZE               = 7004,
    MSGID_SET_PREVIEW_BITRATE            = 7005,
    MSGID_GET_PREVIEW_BITRATE            = 7006,
    MSGID_SET_PREVIEW_FPS                = 7007,
    MSGID_GET_PREVIEW_FPS                = 7008,
    MSGID_SET_PREVIEW_AUDIO              = 7009,
    MSGID_GET_PREVIEW_AUDIO              = 7010,
    
    //wifi control
    MSGID_CAMERA_ENABLE_WIFI_2_4G        = 8001,        //2.4/5
    MSGID_CAMERA_ENABLE_WIFI_5G          = 8002,
    MSGID_CAMERA_GET_WIFI_STATE          = 8003,        //获取WIFI状态，WIFI名称和WIFI开关状态
    MSGID_MODIFY_WIFI_PASSWORD           = 8004,        //修改密码
    
    
    //system
    MSGID_CAMERA_POWEROFF                = 9001,        //关机
    MSGID_CAMERA_AUTO_POWEROFF           = 9002,        //自动关机时间
    MSGID_CAMERA_RESET_FACTORY           = 9003,        //恢复出厂设置
    MSGID_GET_DEVICEINFO                 = 9004,        //获取所有设备信息（序列号，设备名，版本号等等）
    MSGID_QUERY_CUR_SETTINGS             = 9005,        //获取所有设置信息
    MSGID_QUERY_CUR_STATUS               = 9006,
    MSGID_GET_SD_CARD_STATE              = 9007,
    MSGID_FARMAT_SD_CARD                 = 9008,        //格式化卡
    MSGID_SET_AUTO_SLEEP_TIME            = 9009,        //自动休眠时间
    
    MSGID_CAMERA_SET_BEEP_SWITCH         = 9010,        //-
    MSGID_CAMERA_GET_BEEP_SWITCH         = 9011,        //-
    MSGID_CAMERA_SET_FUN_SWITCH          = 9012,        //-
    MSGID_CAMERA_GET_FUN_SWITCH          = 9013,        //-
    MSGID_CAMERA_SET_LED_SWITCH          = 9014,        //-
    MSGID_CAMERA_GET_LED_SWITCH          = 9015,        //-
    MSGID_CAMERA_SET_LIGHT_FREQ          = 9016,        //-
    MSGID_CAMERA_GET_LIGHT_FREQ          = 9017,        //-
    MSGID_CAMERA_SET_MIC_VOLUME          = 9018,        //-
    MSGID_CAMERA_GET_MIC_VOLUME          = 9019,        //-
    
    MSGID_CAMERA_GET_TBATERY             = 9101,        //获取电量
    MSGID_CAMERA_GET_BOARD_TMP           = 9102,
    MSGID_CAMERA_GET_USB_INSERTED_STATE  = 9103,
    MSGID_CAMERA_SET_DATETIME            = 9104,        //设置时间
    MSGID_CAMERA_FUN_CONTROL             = 9105,        //风扇开关
    MSGID_CAMERA_ENTER_STANDBY           = 9106,        //休眠唤醒
    MSGID_CAMERA_EXIT_STANDBY            = 9107,        //立即进入休眠
    
    //upgrade
    MSGID_CAMERA_ENTER_UPGRADE_MODE      = 9108,
    MSGID_CAMERA_EXIT_UPGRADE_MODE       = 9109,
    MSGID_UPGRADE_ROUTER_SYSTEM          = 9110,		//upgrade router system
    MSGID_UPGRADE_ROUTER_APP             = 9111,
    MSGID_ROUTER_APP_TRANSFER_SUCCESS    = 9112,
    MSGID_UPGRADE_A12_CAMERA             = 9113,
    MSGID_CAMERA_FW_TRANSFER_SUCCESS     = 9114,
    MSGID_CAMERA_STOP_LIVING             = 9118,        //停止直播
    MSGID_CAMERA_SET_3A                  = 9119,        //设置3A
    
    MSGID_CAMERA_GET_LENS_PARAM          = 9901,
    MSGID_CAMERA_GET_LENS_SENSOR         = 9911,        // 获取标定
    
    
    
    MSGID_CAMERA_END = 9999,
    
#endif
    
    CLIENT_MSGID_LAST
} EN_MSGID_LIST;


// HDR 延时开关状态
typedef enum {
    en_switch_off = 0,
    en_switch_on = 1,
    en_switch_auto = 2,
    
    en_switch_type_max
} SWITCH_TYPE;

// 录音分辨率
typedef enum {
    en_video_resolution_3840x2160_30P,
    en_video_resolution_2080x1024_60P,
    
    en_video_resolution_type_max
} EN_VIDEO_RESOLUTION_TYPE;

// 预览分辨率
typedef enum {
    en_vf_resolution_3840x2160_30P,
    en_vf_resolution_2080x1024_60P,
    
    en_vf_resolution_type_max
} EN_VF_RESOLUTION_TYPE;

// 质量
typedef enum {
    en_quality_sfine = 0,
    en_quality_fine,
    en_quality_normal,
    
    en_quality_type_max
} EN_QUALITY_TYPE;

// 照片分辨率
typedef enum {
    en_photo_resolution_3840x2160 = 0,
    en_photo_resolution_2560x1440,
    en_photo_resolution_1920x1080,
    en_photo_resolution_1440x720,
    en_photo_resolution_4000x3000,
    en_photo_resolution_type_max
} EN_PHOTO_RESOLUTION_TYPE;


// 卡状态 USB状态
typedef enum {
    en_insert_state_in,
    en_insert_state_out,
    en_insert_state_unknown,
    
    en_insert_state_max
} EN_INSERT_STATE_TYPE;

// 工作模式
typedef enum {
    en_work_mode_preview,	//resolution
    en_work_mode_liveview,
    
    en_work_mode_max
} EN_WORK_MODE_TYPE;

// ISO
typedef enum {
    en_iso_auto,  //resolution
    en_iso_3,
    en_iso_6,
    en_iso_12,
    en_iso_25,
    en_iso_50,
    en_iso_100,
    en_iso_200,
    en_iso_400,
    en_iso_800,
    en_iso_1600,
    en_iso_3200,
    en_iso_6400,
    
    en_iso_type_max
} EN_ISO_TYPE;

// 快门时间
typedef enum {
    en_shut_speed_auto,
    en_shut_speed_250us,
    en_shut_speed_500us,
    en_shut_speed_1ms,
    en_shut_speed_2ms,
    en_shut_speed_4ms,
    en_shut_speed_17ms,
    en_shut_speed_33ms,
    en_shut_speed_67ms,
    en_shut_speed_125ms,
    en_shut_speed_250ms,
    en_shut_speed_500ms,
    en_shut_speed_1s,
    en_shut_speed_2s,
    en_shut_speed_4s,
    en_shut_speed_8s,
    en_shut_speed_10s,
    en_shut_speed_30s,
    en_shut_speed_60s,
    
    en_shut_type_max
}EN_SHUTTER_TYPE;

// AWB
typedef enum {
    en_awb_auto,
    en_awb_incandescent,
    en_awb_D4000,
    en_awb_D5000,
    en_awb_daylight,
    en_awb_cloudy,
    en_awb_D9000,
    en_awb_D10000,
    en_awb_flash,
    en_awb_fluorescent,
    en_awb_water,
    en_awb_outdoor,
    
    en_awb_type_max
} EN_AWB_TYPE;

// EV
typedef enum {
    en_ev_f6,
    en_ev_f5,
    en_ev_f4,
    en_ev_f3,
    en_ev_f2,
    en_ev_f1,
    en_ev_0,
    en_ev_z1,
    en_ev_z2,
    en_ev_z3,
    en_ev_z4,
    en_ev_z5,
    en_ev_z6,
    en_ev_type_max
} EN_EV_TYPE;

// 自动休眠时间
typedef enum {
    en_auto_sleep_time_1min,
    en_auto_sleep_time_3min,
    en_auto_sleep_time_5min,
    en_auto_sleep_time_15min,
    
    en_auto_sleep_time_max
} EN_AUTO_SLEEP_TIME_TYPE;

// 锐度参数
typedef enum {
    en_sharp_soft,
    en_sharp_normal,
    en_sharp_strong,
    
    en_sharp_type_max
} EN_SHARPNESS_TYPE;



typedef enum {
    en_hdr_on,
    en_hdr_off,
    en_hdr_max
} EN_HDR_TYPE;


// 设备电源模式
typedef enum {
    en_power_normal,
    en_power_standby,
    en_power_poweroff,
    
    en_power_type_max
} EN_POWER_MANAGER_STATE_TYPE;

typedef enum {
    en_F8_Start = 0,
    en_F8_created = 1,
    en_F8_waitA12_boot = 2,
    en_F8_A12_boot_failed = 3,
    en_F8_Sync_setting = 4,  //at this state, F8 will sync all A12 settings and status and timestamp etc  to make all a12 are ready to work normal
    en_F8_Sync_setting_failed = 5,
    en_F8_normalwork = 6,
    en_F8_pre_capture = 10,
    en_F8_taking_photo = 11,
    en_F8_delay_taking_photo = 12,
    en_F8_pre_record = 20,
    en_F8_start_record = 21,
    en_F8_recording = 23,
    en_F8_stop_record = 24,
    en_F8_delay_recording = 25,
    en_F8_record_aborting = 26,
    en_F8_record_living = 29,
    //  en_F8_reset_factory,
    //  en_F8_formating,
    //  en_F8_power_off,
    //  en_F8_upgrade,
    en_F8_abnormal = 50,
    
} F8_CAMERA_STATE;

typedef enum {
    SD_CARD_UNKNOWN     = -1,
    SD_CARD_INSERTED     = 0,
    SD_CARD_REMOVED     = 1,
    SD_CARD_LOW_SPEED     = 2,
    SD_CARD_FULL         = 3,
    SD_CARD_ERROR         = 4,
    SD_CARD_MAX_STATE
} SDCARD_STATE;


typedef enum {
    metering_mode_multi     = 0,  //平均测光
    metering_mode_center     = 1,  //中心测光
    metering_mode_spot     = 2,  //点测光
    metering_mode_multi_MAX
} METERING_MODE_STATE;
