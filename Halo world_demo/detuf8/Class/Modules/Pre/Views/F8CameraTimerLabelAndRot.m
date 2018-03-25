
//
//  F8CameraTimerLabelAndRot.m
//  cameradispatchservicelib
//
//  Created by Seth on 2017/5/24.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8CameraTimerLabelAndRot.h"

@interface F8CameraTimerLabelAndRot ()


@end

@implementation F8CameraTimerLabelAndRot

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 3.;
        self.isLittleVideo = NO;
        [self setUp];
    }
    return self;
}

- (void)setUp
{
    UIView *backgroud = [[UIView alloc]init];
    self.backgroundColor = [UIColor clearColor];
    [self addSubview:backgroud];
    backgroud.backgroundColor = [UIColor blackColor];
    backgroud.alpha = .3;
    [backgroud mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@(0));
    }];
    
    self.dot = [UIImageView new];
    [self addSubview:self.dot];
    [self.dot mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@(10));
        make.centerY.equalTo(@(0));
        make.width.equalTo(@(10));
        make.height.equalTo(@(10));
    }];
    
    NSMutableArray *arr = [NSMutableArray array];
    NSArray * animationImages = @[[UIImage imageNamed:@"dot"], [UIImage creatimageWithColor:[UIColor clearColor]]];
    self.dot.animationImages = animationImages;
    self.dot.animationDuration = 1.0;
    self.dot.animationRepeatCount = 0;
    [self.dot startAnimating];
    
    
    //------录像计时-------
    self.cameraTimerLabel = [CameraTimerLabel new];
    self.cameraTimerLabel.timerType = CameraTimerLabelTypeStopWatch;
    self.cameraTimerLabel.textAlignment = NSTextAlignmentLeft;
    self.cameraTimerLabel.timeFormat = @"HH:mm:ss";
    self.cameraTimerLabel.text = @"00:00:00";
    self.cameraTimerLabel.font = [UIFont boldSystemFontOfSize:15];
    self.cameraTimerLabel.textColor = [UIColor whiteColor];
    self.cameraTimerLabel.delegate = (id)self;
    [self addSubview: self.cameraTimerLabel];
    [self.cameraTimerLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@(0.));
        make.right.equalTo(@(-5));
        make.width.equalTo(@(70));
        make.height.equalTo(@(22.5));
    }];
    self.cameraTimerLabel.hidden = NO;
    self.cameraTimerLabel.alpha = 1;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

// 开始计时
-(void)startTimer
{
    dispatch_async(dispatch_get_main_queue(), ^{
        if (!self.cameraTimerLabel.counting)
        {
            [self.cameraTimerLabel reset];
            [self.cameraTimerLabel setCountDownTime:[F8SocketAPI shareInstance].cameraInfo.nowMovieRecordingTime];
            [self.cameraTimerLabel start];
            NSLog(@"录制开始计时......");
        }
    });
}

// 停止计时
-(void)stopTimer {
    [self.cameraTimerLabel pause];
    NSLog(@"录制结束计时......");
}

- (void)free {
    [self.cameraTimerLabel free];
}

- (void)dealloc {
    NSLog(@"F8CameraTimerLabelAndRot dealloc......");
}

@end
