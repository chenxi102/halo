//
//  F8PreViewBottomView.h
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F8CameraTimerLabelAndRot.h"
#import "F8CameraModeView.h"


@interface F8PreViewBottomView : UIView

@property (nonatomic, strong) F8CameraModeView * _Nullable cameraModeView;
@property (nonatomic, strong) F8CameraTimerLabelAndRot * _Nullable timeCountLAB;
@property (nonatomic, strong) UIButton * _Nullable mainBTN;
@property (nonatomic, strong) UIButton * _Nullable albumBTN;
@property (nonatomic, strong) UIButton * _Nullable playerModeBTN;
@property (nonatomic, copy) void(^ _Nullable modeBlock) (F8CameraType);

- (void)refreshStates:(F8CameraModeStruct)__struct;

@end

