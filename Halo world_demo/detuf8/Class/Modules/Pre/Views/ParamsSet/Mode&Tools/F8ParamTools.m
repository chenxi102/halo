//
//  F8ParamTools.m
//  detuf8
//
//  Created by Seth on 2018/3/7.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamTools.h"
#import "F8ParamMode.h"

@implementation F8ParamTools

// 曝光 ： 手动 自动
+ (F8ParamMode *)getPicEXPDataSource {
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"自动";
    mode_1.pramaValue = 0;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"手动";
    mode_2.pramaValue = 1;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_exp;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.exposure_mode;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}

//MARK: ISO

+ (F8ParamMode *)getPicISODataSource {
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_iso;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicISO;
    
    NSArray <NSNumber*>*Valuse = @[@(100),@(200),@(400),@(800),@(1600),@(3200),@(6400)];
    
    NSArray * Keys = @[@"100",@"200",@"400",@"800",@"1600",@"3200", @"6400"];
    
    NSAssert(Valuse.count == Keys.count, @"getPicISODataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}

+ (F8ParamMode *)getMovISODataSource {
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_iso;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovISO;
    
    NSArray <NSNumber*>*Valuse = @[@(100),@(200),@(400),@(800),@(1600),@(3200),@(6400)];
    
    NSArray * Keys = @[@"100",@"200",@"400",@"800",@"1600",@"3200", @"6400"];
    
    NSAssert(Valuse.count == Keys.count, @"getMovISODataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}
//MARK: shutter
// 500.0f, 200.0f, 100.0f, 66.67f, 50.0f, 40.0f, 33.33f, 25.0f, 20.0f, 16.67f, 10.0f, 8.0f, 6.25f, 5.0f, 4.0f, 3.125f, 2.5f, 2.0f, 1.5625f, 1.125f, 1.0f, 0.8f, 0.625f, 0.5f, 0.4f, 0.3125f, 0.25f, 0.2f, 0.15625f, 0.125f

+ (F8ParamMode *)getPicShutterDataSource {
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_shutter;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicShutter;
    
    NSArray <NSNumber*>*picShutterValuse = @[@(500.0f),@(200.0f),@(100.0f),@(66.67f),@(50.0f),@(40.0f),@(33.33f),@(25.0f),@(20.0f),@(16.67f),@(10.0f),@(8.0f),@(6.25f),@(5.0f),@(4.0f),@(3.125f),@(2.5f),@(2.0f),@(1.5625f),@(1.125f),@(1.0f),@(0.8f),@(0.625f),@(0.5f),@(0.4f),@(0.3125f),@(0.25f),@(0.2f),@(0.15625f),@(0.125f)];
    
    NSArray * picShutterKeys = @[@"0.5S",@"1/5S",@"1/10S",@"1/15S",@"1/20S",@"1/25S",@"1/30S",@"1/40S",@"1/50S",@"1/60S",@"1/100S",@"1/125S",@"1/160S",@"1/200S",@"1/250S",@"1/320S",@"1/400S",@"1/500S",@"1/640S",@"1/800S",@"1/1000S",@"1/1250S",@"1/1600S",@"1/2000S",@"1/2500S",@"1/3200S",@"1/4000S",@"1/5000S",@"1/6400S",@"1/8000S"];
    
    NSAssert(picShutterValuse.count == picShutterKeys.count, @"getPicShutterDataSource error");
    for (int _ = 0; _<picShutterValuse.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = picShutterKeys[_];
        mode.pramaValue = picShutterValuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    return paramMode;
}

+ (F8ParamMode *)getMovShutterDataSource {
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_shutter;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovShutter;
    
    NSArray <NSNumber*>*picShutterValuse = @[@(500.0f),@(200.0f),@(100.0f),@(66.67f),@(50.0f),@(40.0f),@(33.33f),@(25.0f),@(20.0f),@(16.67f),@(10.0f),@(8.0f),@(6.25f),@(5.0f),@(4.0f),@(3.125f),@(2.5f),@(2.0f),@(1.5625f),@(1.125f),@(1.0f),@(0.8f),@(0.625f),@(0.5f),@(0.4f),@(0.3125f),@(0.25f),@(0.2f),@(0.15625f),@(0.125f)];
    
    NSArray * picShutterKeys = @[@"0.5S",@"1/5S",@"1/10S",@"1/15S",@"1/20S",@"1/25S",@"1/30S",@"1/40S",@"1/50S",@"1/60S",@"1/100S",@"1/125S",@"1/160S",@"1/200S",@"1/250S",@"1/320S",@"1/400S",@"1/500S",@"1/640S",@"1/800S",@"1/1000S",@"1/1250S",@"1/1600S",@"1/2000S",@"1/2500S",@"1/3200S",@"1/4000S",@"1/5000S",@"1/6400S",@"1/8000S"];
    
    NSAssert(picShutterValuse.count == picShutterKeys.count, @"getMovShutterDataSource error");
    for (int _ = 0; _<picShutterValuse.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = picShutterKeys[_];
        mode.pramaValue = picShutterValuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    return paramMode;
}

//MARK: WB
+ (F8ParamMode *)getPicWBDataSource {
//    自动、日光、多云、白炽灯、荧光灯、阴影，以及2500K-10000K（按500刻度记）
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_wb;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicWB;
    
    NSArray <NSNumber*>*WBValuse = @[@(0.),@(2500.0f),@(4000.0f),@(5000.f),@(6500.f),@(7500.0f), @(1.f)];
    
    NSArray * WBKeys = @[@"自动",@"白炽灯",@"荧光灯",@"日光",@"阴影",@"多云", @"自定义"];
    
    NSAssert(WBValuse.count == WBKeys.count, @"getPicWBDataSource error");
    for (int _ = 0; _<WBKeys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = WBKeys[_];
        mode.pramaValue = WBValuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}

+ (F8ParamMode *)getMovWBDataSource {
    //    自动、日光、多云、白炽灯、荧光灯、阴影，以及2500K-10000K（按500刻度记）
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_wb;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovWB;
    
    NSArray <NSNumber*>*WBValuse = @[@(0.),@(2500.0f),@(4000.0f),@(5000.f),@(6500.f),@(7500.0f), @(1.f)];
    
    NSArray * WBKeys = @[@"自动",@"白炽灯",@"荧光灯",@"日光",@"阴影",@"多云", @"自定义"];
    
    NSAssert(WBValuse.count == WBKeys.count, @"getMovWBDataSource error");
    for (int _ = 0; _<WBKeys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = WBKeys[_];
        mode.pramaValue = WBValuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}

//MARK: 色温
+ (F8ParamMode *)getPicTepDataSource {
    // 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_tep;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicColorTemp;
    
    NSArray <NSNumber*>*Valuse = @[@(2500),@(3000),@(3500),@(4000),@(4500),@(5000),@(5500),@(6000),@(6500),@(7000),@(7500),@(8000),@(8500),@(9000),@(9500),@(10000)];
    
    NSArray * Keys = @[@"2500K",@"3000K",@"3500K",@"4000K",@"4500K",@"5000K",@"5500K",@"6000K",@"6500K",@"7000K",@"7500K",@"8000K",@"8500K",@"9000K",@"9500K",@"10000K"];
    
    NSAssert(Valuse.count == Keys.count, @"getPicTepDataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}
+ (F8ParamMode *)getMovTepDataSource {
    // 2500, 3000, 3500, 4000, 4500, 5000, 5500, 6000, 6500, 7000, 7500, 8000, 8500, 9000, 9500, 10000
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_tep;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovColorTemp;
    
    NSArray <NSNumber*>*Valuse = @[@(2500),@(3000),@(3500),@(4000),@(4500),@(5000),@(5500),@(6000),@(6500),@(7000),@(7500),@(8000),@(8500),@(9000),@(9500),@(10000)];
    
    NSArray * Keys = @[@"2500K",@"3000K",@"3500K",@"4000K",@"4500K",@"5000K",@"5500K",@"6000K",@"6500K",@"7000K",@"7500K",@"8000K",@"8500K",@"9000K",@"9500K",@"10000K"];
    
    NSAssert(Valuse.count == Keys.count, @"getMovTepDataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    
    return paramMode;
}


//MARK: EV
+ (F8ParamMode *)getPicEVDataSource {
    // -3.0f, -2.67f, -2.33f, -2.0f, -1.67f, -1.33f, -1.0f, -0.67f, -0.33f, 0.0f, 0.33f, 0.67f, 1.0f, 1.33f, 1.67f, 2.0f, 2.33f, 2.67f, 3.0f
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_ev;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicEV;
    
    NSArray <NSNumber*>*Valuse = @[@(-3.0f),@(-2.67f),@(-2.33f),@(-2.0f),@(-1.67f),@(-1.33f),@(-1.0f),@(-0.67f),@(-0.33f),@(0.0f),@(0.33f),@(0.67f),@(1.0f),@(1.33f),@(1.67f),@(2.0f),@(2.33f),@(2.67f),@(3.0f)];
    
    NSArray * Keys = @[@"-3",@"-8/3",@"-7/3",@"-2",@"-5/3",@"-4/3",@"-1",@"-2/3",@"-1/3",@"0",@"+1/3",@"+2/3",@"+1",@"+4/3",@"+5/3",@"+2",@"+7/3",@"+8/3",@"+3"];
    
    NSAssert(Valuse.count == Keys.count, @"getPicEVDataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    return paramMode;
}
+ (F8ParamMode *)getMovEVDataSource {
    // -3.0f, -2.67f, -2.33f, -2.0f, -1.67f, -1.33f, -1.0f, -0.67f, -0.33f, 0.0f, 0.33f, 0.67f, 1.0f, 1.33f, 1.67f, 2.0f, 2.33f, 2.67f, 3.0f
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_ev;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovEV;
    
    NSArray <NSNumber*>*Valuse = @[@(-3.0f),@(-2.67f),@(-2.33f),@(-2.0f),@(-1.67f),@(-1.33f),@(-1.0f),@(-0.67f),@(-0.33f),@(0.0f),@(0.33f),@(0.67f),@(1.0f),@(1.33f),@(1.67f),@(2.0f),@(2.33f),@(2.67f),@(3.0f)];
    
    NSArray * Keys = @[@"-3",@"-8/3",@"-7/3",@"-2",@"-5/3",@"-4/3",@"-1",@"-2/3",@"-1/3",@"0",@"+1/3",@"+2/3",@"+1",@"+4/3",@"+5/3",@"+2",@"+7/3",@"+8/3",@"+3"];
    
    NSAssert(Valuse.count == Keys.count, @"getMovEVDataSource error");
    for (int _ = 0; _<Keys.count; _++) {
        F8ParamSubMode * mode = [F8ParamSubMode new];
        mode.pramaTitle = Keys[_];
        mode.pramaValue = Valuse[_].floatValue;
        [paramMode.pramas addObject:mode];
    }
    return paramMode;
}


//MARK: =============================================================
//MARK: HDR
+ (F8ParamMode *)getPicHDRDataSource {
    // 宽动态等级，值：0~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = 0;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_hdr;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicHDR;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}

+ (F8ParamMode *)getMovHDRDataSource {
    // 宽动态等级，值：0~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = 0;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_hdr;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovHDR;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
//MARK: brightness 亮度
+ (F8ParamMode *)getPicBrightnessDataSource {
    // 亮度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_light;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicBrightness;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
+ (F8ParamMode *)getMovBrightnessDataSource {
    // 亮度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_light;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovBrightness;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}

//MARK: contrast 对比度
+ (F8ParamMode *)getPicContrastDataSource {
    // 对比度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_contrast;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicContrast;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
+ (F8ParamMode *)getMovContrastDataSource {
    // 对比度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_contrast;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovContrast;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
//MARK: sharpness 锐度
+ (F8ParamMode *)getPicSharpnessDataSource {
    // 锐度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_sharpness;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicSharpness;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
+ (F8ParamMode *)getMovSharpnessDataSource {
    // 锐度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_sharpness;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovSharpness;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
//MARK: saturation 饱和度
+ (F8ParamMode *)getPicSaturationDataSource{
    //饱和度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_saturation;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.PicSaturation;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}
+ (F8ParamMode *)getMovSaturationDataSource{
    //饱和度等级，值：-100~100
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"MIN";
    mode_1.pramaValue = -100;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"MAX";
    mode_2.pramaValue = 100;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_saturation;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.MovSaturation;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}


//MARK: =============================================================
//MARK: 2d 3d
+ (F8ParamMode *)getContentDataSource {
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"2D 360°";
    mode_1.pramaValue = 0;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"3D 360°";
    mode_2.pramaValue = 1;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_contentType;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.contendMode;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2]];
    return paramMode;
}

//MARK: 分辨率
+ (F8ParamMode *)getPicResDataSource {
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"3840x1920 (4K)";
    mode_1.pramaValue = 1;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"3840x1920 (4K)";
    mode_2.pramaValue = 2;
    
    F8ParamSubMode * mode_3 = [F8ParamSubMode new];
    mode_3.pramaTitle = @"3840x1920 (4K)";
    mode_3.pramaValue = 3;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_resolution;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.photoQuality;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2, mode_3]];
    return paramMode;
}

+ (F8ParamMode *)getMovResDataSource {
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"3840x1920 (4K)";
    mode_1.pramaValue = 1;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"3840x1920 (4K)";
    mode_2.pramaValue = 2;
    
    F8ParamSubMode * mode_3 = [F8ParamSubMode new];
    mode_3.pramaTitle = @"3840x1920 (4K)";
    mode_3.pramaValue = 3;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_resolution;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.videoQuality;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2, mode_3]];
    return paramMode;
}

// 标准 快慢镜头
+ (F8ParamMode *)getMovSensorModeDataSource {
    F8ParamSubMode * mode_1 = [F8ParamSubMode new];
    mode_1.pramaTitle = @"标准";
    mode_1.pramaValue = 0;
    
    F8ParamSubMode * mode_2 = [F8ParamSubMode new];
    mode_2.pramaTitle = @"快镜头";
    mode_2.pramaValue = 1;
    
    F8ParamSubMode * mode_3 = [F8ParamSubMode new];
    mode_3.pramaTitle = @"慢镜头";
    mode_3.pramaValue = 2;
    
    F8ParamMode * paramMode = [F8ParamMode new];
    paramMode.pramaType = ParamCommandType_resolution;
    paramMode.pramaIndex = [F8SocketAPI shareInstance].cameraInfo.videoQuality;
    [paramMode.pramas addObjectsFromArray:@[mode_1, mode_2, mode_3]];
    return paramMode;
}
@end
