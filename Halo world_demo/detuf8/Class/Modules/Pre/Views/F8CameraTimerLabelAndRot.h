//
//  F8CameraTimerLabelAndRot.h
//  cameradispatchservicelib
//
//  Created by Seth on 2017/5/24.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "CameraModel.h"
#import "CameraTimerLabel.h"

@interface F8CameraTimerLabelAndRot : UIView

@property (nonatomic, strong) CameraTimerLabel * cameraTimerLabel;
@property (nonatomic, strong) UIImageView * dot; // 小红点

/*
 是否是小视频
 */
@property (nonatomic, assign) BOOL isLittleVideo;

/*
 当前录像时间
 */
@property (nonatomic, assign) float cameraCurrentTime;

/*
 刷新UI
 */
- (void)startTimer;
- (void)stopTimer;
/*
 释放定时器
 */
- (void)free ;
@end
