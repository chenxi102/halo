//
//  F8CameraModeView.h
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F8CameraModeButton : UIButton

@property (nonatomic, strong) UIButton * _Nullable centerBTN ;
@property (nonatomic, assign) BOOL select ;

- (instancetype _Nullable )initWithImage:(NSString *_Nullable)imgStr selectImage:(NSString *_Nullable)slcImgStr;

@end





@interface F8CameraModeView : UIView

@property (nonatomic, strong) F8CameraModeButton * _Nullable photoBTN;
@property (nonatomic, strong) F8CameraModeButton * _Nullable movieBTN;
@property (nonatomic, strong) F8CameraModeButton * _Nullable livingBTN;

@property (nonatomic, assign) F8CameraType cameraType;
@property (nonatomic, copy) void(^ _Nullable modeBlock) (F8CameraType);

@end

