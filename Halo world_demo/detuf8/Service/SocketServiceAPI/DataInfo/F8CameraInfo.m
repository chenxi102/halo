//
//  F8CameraInfo.m
//  detuf8
//
//  Created by Seth on 2017/12/28.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8CameraInfo.h"

@implementation F8CameraInfo

//初始化数据
- (instancetype)init
{
    self = [super init];
    if (self) {
        [self initData];
    }
    return self;
}
- (void)initData
{
    F8CameraModeStruct  mode ;
    mode.mode                       = F8CameraType_video;
    mode.state                      = F8CameraShotState_None;
    self.cameraModeStruct           = mode;
    
    
    self.exposure_mode              = 0;
    
    self.PicSaturation              = 0;
    self.PicSharpness               = 0;
    self.PicContrast                = 0;
    self.PicBrightness              = 0;
    self.PicShutter                 = 33.33f;
    self.PicEV                      = 0;
    self.PicHDR                     = 50;
    self.PicWB                      = 0.;
    self.PicISO                     = 100;
    self.PicColorTemp               = 6500;
    self.photoQuality               = 0;
    
    self.MovSaturation              = 0;
    self.MovSharpness               = 0;
    self.MovContrast                = 0;
    self.MovBrightness              = 0;
    self.MovShutter                 = 33.33f;
    self.MovEV                      = 0;
    self.MovHDR                     = 50;
    self.MovWB                      = 0.;
    self.MovISO                     = 100;
    self.MovColorTemp               = 6500;
    self.videoQuality               = 0;
    
    self.contendMode                = 1;
    
    self.photosUrl                  = nil;
    self.sdCardState                = 0;    //默认插上
    self.SSID                       = @"";  //默认没连接
    self.seriesNumber               = @"";  //默认空
    
    
    
    self.dataStr                    = [NSMutableString new];
}


//重置
- (void)reset{
    F8CameraModeStruct  mode ;
    mode.mode                       = F8CameraType_video;
    mode.state                      = F8CameraShotState_None;
    self.cameraModeStruct           = mode;
    
    
    self.exposure_mode              = 0;
    
    self.PicSaturation              = 0;
    self.PicSharpness               = 0;
    self.PicContrast                = 0;
    self.PicBrightness              = 0;
    self.PicShutter                 = 33.33f;
    self.PicEV                      = 0;    
    self.PicHDR                     = 50;
    self.PicWB                      = 0.;
    self.PicISO                     = 100;
    self.PicColorTemp               = 6500;
    self.photoQuality               = 0;
    
    self.MovSaturation              = 0;
    self.MovSharpness               = 0;
    self.MovContrast                = 0;
    self.MovBrightness              = 0;
    self.MovShutter                 = 33.33f;
    self.MovEV                      = 0;
    self.MovHDR                     = 50;
    self.MovWB                      = 0.;
    self.MovISO                     = 100;
    self.MovColorTemp               = 6500;
    self.videoQuality               = 0;
    
    self.contendMode                = 1;
    
    self.photosUrl                  = nil;
    self.sdCardState                = 0;    //默认插上
    self.SSID                       = @"";  //默认没连接
    self.seriesNumber               = @"";  //默认空
    
    
    self.dataStr                    = [NSMutableString new];
}

/*
{
    chip = host;
    "media_params" =     {
        "capture_effect" = 0;
        "capture_mode" = 0;
        sensor = 0;
    };
    "picture_params" =     {
        "ae_mode" = 0;
        "awb_mode" = 0;
        brightnesslevel = 0;
        contrastlevel = 0;
        ctlevel = 6500;
        ev = 0;
        hdrlevel = 50;
        iso = 100;
        saturationlevel = 0;
        sharpnesslevel = 0;
        shutter = 40;
    };
    "record_params" =     {
        "delay_time" = 0;
        "record_mode" = separate;
        "save_2dfile" = off;
        "save_soursefile" = "<null>";
        "video_entype" = H265;
    };
    rval = 0;
    "snapshot_params" =     {
        chn = allchn;
        "delay_time" = 0;
        "enlarge_factor" = 1;
        "original_res" =         (
                                  2,
                                  1920
                                  );
        "save_2dfile" = off;
        "save_soursefile" = "<null>";
        "snapshot_mode" = single;
    };
    "video_params" =     {
        "awb_mode" = 0;
        brightnesslevel = 0;
        contrastlevel = 0;
        ctlevel = 2500;
        ev = 0;
        hdrlevel = 50;
        saturationlevel = 0;
        sharpnesslevel = 0;
    };
}
*/

- (void)saveCameraConfigData:(F8SocketModel*)m {
    
    NSDictionary *media_params      = ((NSDictionary *)m.param)[@"media_params"];
    NSDictionary *picture_params    = ((NSDictionary *)m.param)[@"picture_params"];
    NSDictionary *record_params     = ((NSDictionary *)m.param)[@"record_params"];
    NSDictionary *snapshot_params   = ((NSDictionary *)m.param)[@"snapshot_params"];
    NSDictionary *video_params      = ((NSDictionary *)m.param)[@"video_params"];
    
    
    self.contendMode   = ((NSNumber *)media_params[@"capture_effect"]).intValue;
    
    self.exposure_mode = ((NSNumber *)picture_params[@"ae_mode"]).intValue;
    self.PicSaturation = ((NSNumber *)picture_params[@"saturationlevel"]).intValue;
    self.PicSharpness  = ((NSNumber *)picture_params[@"sharpnesslevel"]).intValue;
    self.PicContrast   = ((NSNumber *)picture_params[@"contrastlevel"]).intValue;
    self.PicBrightness = ((NSNumber *)picture_params[@"brightnesslevel"]).intValue;
    self.PicShutter    = ((NSNumber *)picture_params[@"shutter"]).floatValue;;
    self.PicEV         = ((NSNumber *)picture_params[@"ev"]).floatValue;
    self.PicHDR        = ((NSNumber *)picture_params[@"hdrlevel"]).intValue;
    self.PicWB         = ((NSNumber *)picture_params[@"awb_mode"]).intValue;
    self.PicISO        = ((NSNumber *)picture_params[@"iso"]).intValue;
    self.PicColorTemp  = ((NSNumber *)picture_params[@"ctlevel"]).intValue;
//    self.photoQuality               = (int)picture_params[@"saturationlevel"];;
    

    self.MovSaturation = ((NSNumber *)video_params[@"saturationlevel"]).intValue;
    self.MovSharpness  = ((NSNumber *)video_params[@"sharpnesslevel"]).intValue;
    self.MovContrast   = ((NSNumber *)video_params[@"contrastlevel"]).intValue;
    self.MovBrightness = ((NSNumber *)video_params[@"brightnesslevel"]).intValue;
//    self.MovShutter    = ((NSNumber *)video_params[@"shutter"]).floatValue;
    self.MovEV         = ((NSNumber *)video_params[@"ev"]).floatValue;
    self.MovHDR        = ((NSNumber *)video_params[@"hdrlevel"]).intValue;
    self.MovWB         = ((NSNumber *)video_params[@"awb_mode"]).intValue;
//    self.MovISO        = ((NSNumber *)video_params[@"iso"]).intValue;
    self.MovColorTemp  = ((NSNumber *)video_params[@"ctlevel"]).intValue;
    //    self.photoQuality               = (int)picture_params[@"saturationlevel"];;
    
    
}


@end
