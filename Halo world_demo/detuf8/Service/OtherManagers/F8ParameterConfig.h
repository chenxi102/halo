//
//  F8ParameterConfig.h
//  F8 Plus
//
//  Created by Seth on 2017/11/1.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 相机的各种参数转换 iso ev shutter awb
 */

#pragma pack(1)
typedef struct _F8_parameters_obj{
    int parameters_value;
    char *parameters_str;
}F8_parameters_obj;
#pragma pack()

///< Exposure
#define EXP_MAX      2
typedef NS_ENUM(int, F8_EXP) {
    EXP_AUTO              = 1 ,
    EXP_MANUAL            = 0 ,
};
static F8_parameters_obj exp_obj_table[EXP_MAX] = {
    {EXP_AUTO, "F8OptionAutomatic"},
    {EXP_MANUAL, "手动"},
    //    {0,NULL}
};

///< iso
#define ISO_MAX      13
typedef NS_ENUM(int, F8_ISO) {
    ISO_AUTO         = 0 ,
//    ISO_3            = 1 ,
//    ISO_6            = 2 ,
//    ISO_12           = 3 ,
//    ISO_25           = 4 ,
//    ISO_50           = 5 ,
    ISO_100          = 1 ,
    ISO_200          = 2 ,
    ISO_400          = 3 ,
    ISO_800          = 4 ,
    ISO_1600         = 5 ,
    ISO_3200         = 6 ,
    ISO_6400         = 7 ,
};
static F8_parameters_obj iso_obj_table[ISO_MAX] = {
    {ISO_AUTO, "F8OptionAutomatic"},
//    {ISO_3, "3"},
//    {ISO_6, "6"},
//    {ISO_12, "12"},
//    {ISO_25, "25"},
//    {ISO_50, "50"},
    {ISO_100, "100"},
    {ISO_200, "200"},
    {ISO_400, "400"},
    {ISO_800, "800"},
    {ISO_1600, "1600"},
    {ISO_3200, "3200"},
    {ISO_6400, "6400"},
//    {0,NULL}
};


///< ev
#define EV_MAX      13
typedef NS_ENUM(int, F8_EV) {
    EV_F6            = 0 ,
    EV_F5            = 1 ,
    EV_F4            = 2 ,
    EV_F3            = 3 ,
    EV_F2            = 4 ,
    EV_F1            = 5 ,
    EV_0             = 6 ,
    EV_Z1            = 7 ,
    EV_Z2            = 8 ,
    EV_Z3            = 9 ,
    EV_Z4            = 10 ,
    EV_Z5            = 11 ,
    EV_Z6            = 12 ,
};
static F8_parameters_obj ev_obj_table[EV_MAX] = {
    {EV_F6, "-2.0"},
    {EV_F5, "-1.7"},
    {EV_F4, "-1.3"},
    {EV_F3, "-1.0"},
    {EV_F2, "-0.7"},
    {EV_F1, "-0.3"},
    {EV_0,     "0"},
    {EV_Z1, "+0.3"},
    {EV_Z2, "+0.7"},
    {EV_Z3, "+1.0"},
    {EV_Z4, "+1.3"},
    {EV_Z5, "+1.7"},
    {EV_Z6, "+2.0"},
};



///< 白平衡
#define AWB_AMX      11
typedef NS_ENUM(int, F8_AWB) {
    AWB_AUTO         = 0 ,
    AWB_INCANDESCENT = 1 ,
    AWB_D4000        = 2 ,
    AWB_D5000        = 3 ,
    AWB_DAYLIGHT     = 4 ,
    AWB_CLOUDY       = 5 ,
    AWB_D9000        = 6 ,
    AWB_D10000       = 7 ,
//    AWB_FLASH        = 8 ,
    AWB_FLUORECENT   = 8 ,
    AWB_WATER        = 9 ,
    AWB_OUTDOOR      = 10 ,
};
static F8_parameters_obj awb_obj_table[AWB_AMX] = {
    {AWB_AUTO, "F8OptionAutomatic"},
    {AWB_INCANDESCENT, "F8OptionIncandescentLamp"},
    {AWB_D4000, "D4000"},
    {AWB_D5000, "D5000"},
    {AWB_DAYLIGHT, "F8OptionSunshine"},
    {AWB_CLOUDY, "F8OptionCloudy"},
    {AWB_D9000, "D9000"},
    {AWB_D10000, "D10000"},
//    {AWB_FLASH, "+0.7"},
    {AWB_FLUORECENT, "F8OptionFluorescentLamp"},
    {AWB_WATER, "F8OptionWater"},
    {AWB_OUTDOOR, "F8OptionOutdoors"}
};



///< 锐度
#define SHARP_MAX      3
typedef NS_ENUM(int, F8_SHARPNESS) {
    SHARP_SOFT       = 0 ,
    SHARP_NORMAL     = 1 ,
    SHARP_STRONG     = 2 ,
};
static F8_parameters_obj sharpness_obj_table[SHARP_MAX] = {
    {SHARP_SOFT, "F8OptionSoft"},
    {SHARP_NORMAL, "F8OptionNormal"},
    {SHARP_STRONG, "F8OptionSharp"},
};


///< 快门
#define SHUT_SPEED_MAX      8
typedef NS_ENUM(int, F8_SHUTTER) {
    SHUT_SPEED_AUTO  = 0,
    //    SHUT_SPEED_60S  = 18,
    //    SHUT_SPEED_30S  = 17,
    //    SHUT_SPEED_10S  = 16,
    //    SHUT_SPEED_8S   = 15,
    //    SHUT_SPEED_4S   = 14,
    //    SHUT_SPEED_2S   = 13,
    //    SHUT_SPEED_1S   = 12,
    //    SHUT_SPEED_500MS= 11,
    //    SHUT_SPEED_250MS= 10,
    //    SHUT_SPEED_125MS= 9 ,
    //    SHUT_SPEED_67MS = 8 ,
    SHUT_SPEED_33MS   = 7 ,
    SHUT_SPEED_17MS   = 6 ,
    SHUT_SPEED_4MS    = 5 ,
    SHUT_SPEED_2MS    = 4 ,
    SHUT_SPEED_1MS    = 3 ,
    SHUT_SPEED_500US  = 2 ,
    SHUT_SPEED_250US  = 1 ,
};
static F8_parameters_obj shutter_obj_table[SHUT_SPEED_MAX] = {
    {SHUT_SPEED_AUTO, "F8OptionAutomatic"},
//    {SHUT_SPEED_60S, "60s"},
//    {SHUT_SPEED_30S, "30s"},
//    {SHUT_SPEED_10S, "10s"},
//    {SHUT_SPEED_8S, "8s"},
//    {SHUT_SPEED_4S, "4s"},
//    {SHUT_SPEED_2S, "2s"},
//    {SHUT_SPEED_1S, "1s"}
//    {SHUT_SPEED_500MS, "1/2s"},
//    {SHUT_SPEED_250MS, "1/4s"},
//    {SHUT_SPEED_125MS, "1/8s"},
//    {SHUT_SPEED_67MS, "1/15s"},
    {SHUT_SPEED_33MS, "1/30s"},
    {SHUT_SPEED_17MS, "1/60s"},
    {SHUT_SPEED_4MS, "1/250s"},
    {SHUT_SPEED_2MS, "1/500s"},
    {SHUT_SPEED_1MS, "1/1000s"},
    {SHUT_SPEED_500US, "1/2000s"},
    {SHUT_SPEED_250US, "1/4000s"},
};



@interface F8ParameterConfig : NSObject

+ (NSString *)getIsoStr:(F8_ISO)iso;
//+ (NSArray<NSString *> *)getIsoStrArr;

+ (NSString *)getEvStr:(F8_EV)ev;
//+ (NSArray<NSString *> *)getEvStrArr;

+ (NSString *)getSharpnessStr:(F8_SHARPNESS)sharpness;
//+ (NSArray<NSString *> *)getSharpnessStrArr;

+ (NSString *)getShutterStr:(F8_SHUTTER)shutter;
//+ (NSArray<NSString *> *)getShutterStrArr;

+ (NSString *)getAwbStr:(F8_AWB)awb;
//+ (NSArray<NSString *> *)getAwbStrArr;

@end
