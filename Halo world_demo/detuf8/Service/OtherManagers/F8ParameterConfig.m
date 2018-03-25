//
//  F8ParameterConfig.m
//  F8 Plus
//
//  Created by Seth on 2017/11/1.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8ParameterConfig.h"

 

@implementation F8ParameterConfig

+ (NSString *)getIsoStr:(F8_ISO)iso{
    int i =0 ;
    for (i=0; i<ISO_MAX; i++) {
        if(iso_obj_table[i].parameters_value == iso){
            return L([NSString stringWithUTF8String:iso_obj_table[i].parameters_str]);
        }
    }
    
    if(i >= ISO_MAX){
        return @"ISO_NULL";
    }
    return @"ISO_NULL";
}

+ (NSString *)getEvStr:(F8_EV)ev {
    int i =0 ;
    for (i=0; i<EV_MAX; i++) {
        if(ev_obj_table[i].parameters_value == ev){
            return L([NSString stringWithUTF8String:ev_obj_table[i].parameters_str]);
        }
    }
    
    if(i >= EV_MAX){
        return @"EV_NULL";
    }
    return @"EV_NULL";
}

//+ (NSArray<NSString *> *)getEvStrArr;

+ (NSString *)getSharpnessStr:(F8_SHARPNESS)sharpness{
    int i =0 ;
    for (i=0; i<SHARP_MAX; i++) {
        if(sharpness_obj_table[i].parameters_value == sharpness){
            return L([NSString stringWithUTF8String:sharpness_obj_table[i].parameters_str]);
        }
    }
    
    if(i >= SHARP_MAX){
        return @"SHARP_NULL";
    }
    return @"SHARP_NULL";
}
//+ (NSArray<NSString *> *)getSharpnessStrArr;

+ (NSString *)getShutterStr:(F8_SHUTTER)shutter{
    int i =0 ;
    for (i=0; i<SHUT_SPEED_MAX; i++) {
        if(shutter_obj_table[i].parameters_value == shutter){
            return L([NSString stringWithUTF8String:shutter_obj_table[i].parameters_str]);
        }
    }
    
    if(i >= SHUT_SPEED_MAX){
        return @"SHUT_NULL";
    }
    return @"SHUT_NULL";
}
//+ (NSArray<NSString *> *)getShutterStrArr;

+ (NSString *)getAwbStr:(F8_AWB)awb{
    int i =0 ;
    for (i=0; i<AWB_AMX; i++) {
        if(awb_obj_table[i].parameters_value == awb){
            return L([NSString stringWithUTF8String:awb_obj_table[i].parameters_str]);
        }
    }
    
    if(i >= AWB_AMX){
        return @"AWB_NULL";
    }
    return @"AWB_NULL";
}
//+ (NSArray<NSString *> *)getAwbStrArr;

@end
