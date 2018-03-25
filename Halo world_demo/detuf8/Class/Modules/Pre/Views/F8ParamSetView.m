//
//  F8ParamSetView.m
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamSetView.h"
#import "F8ParamSetTabView.h"


@interface F8ParamSetView()

@property (nonatomic, strong) F8ParamSetTabView * paramSetTabView;
@property (nonatomic, assign) F8ParamSetViewType paramSetViewType;
@property (nonatomic, strong) UILabel * titleLAB;


@property (nonatomic, copy) NSString * title;



@end

@implementation F8ParamSetView
- (void)dealloc{
    DeBugLog(@"F8ParamSetView dealloc");
}

- (CGFloat) viewHeight {
    
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo)
    {
        if (_paramSetViewType == ParamCellType_expView) {
            if ([F8SocketAPI shareInstance].cameraInfo.exposure_mode == 1) {
                // 白平衡是自定义  显示色温
                if ([F8SocketAPI shareInstance].cameraInfo.PicWB == 1) {
                    return 280.0;
                }
                return 235.0;
            }else return 190.0;
        } else if (_paramSetViewType == ParamCellType_imgView)  {
            return 280.0;
        } else {
            return 145.;
        }
        
    }else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_video)
    {
        if (_paramSetViewType == ParamCellType_expView) {
            // 白平衡是自定义  显示色温
            if ([F8SocketAPI shareInstance].cameraInfo.MovWB == 1) {
                return 190.0;
            }
            return 145.0;
        } else if (_paramSetViewType == ParamCellType_imgView)  {
            return 280.0;
        } else {
            return 145.;
        }
    }else
    {
        if (_paramSetViewType == ParamCellType_expView) {
            // 白平衡是自定义  显示色温
            if ([F8SocketAPI shareInstance].cameraInfo.MovWB == 1) {
                return 190.0;
            }
            return 145.0;
        } else if (_paramSetViewType == ParamCellType_imgView)  {
            return 280.0;
        } else {
            return 145.;
        }
    }
}


- (instancetype)initWithParamSetViewType:(F8ParamSetViewType)paramSetViewType res:(void(^)(ParamCommandType, int))resultBlock clickStartBlock:(void(^)(ParamCommandType, float))clickStartBlock
{
    self = [super init];
    if (self) {
        @weak(self);
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.0];
        self.resultBlock = resultBlock;
        self.clickStartBlock = clickStartBlock;
        self.paramSetViewType = paramSetViewType;
        [self setup];
        [self addTarget:self action:@selector(disappear) forControlEvents:(UIControlEventTouchUpInside)];
        [self show];
    }
    return self;
}

- (void)setup {
    @weak(self);
    _paramSetTabView = [[F8ParamSetTabView alloc] initWithParamSetViewType:_paramSetViewType refreshCallBack:^{
        @strong(self);
        [self performBlock:^{
            [self setupFrame];
        } afterDelay:.01];
    }];
    _paramSetTabView.resultBlock = self.resultBlock;
    _paramSetTabView.clickStartBlock = self.clickStartBlock;
    _paramSetTabView.backgroundColor = [UIColor whiteColor];
    _paramSetTabView.clipsToBounds = YES;
    _paramSetTabView.layer.cornerRadius = 13;
    [self addSubview: _paramSetTabView];
    [self setupFrame];
    _paramSetTabView.transform = CGAffineTransformMakeTranslation(0, [self viewHeight]);
}

- (void)setupFrame {
    [UIView animateWithDuration:.1 animations:^{
        @weak(self);
        [_paramSetTabView mas_remakeConstraints:^(MASConstraintMaker *make) {
            @strong(self);
            make.left.equalTo(@15);
            make.bottom.right.equalTo(@-15);
            make.height.equalTo(@([self viewHeight]));
        }];
    }];
}

- (void)disappear
{
    [UIView animateWithDuration:.3 animations:^{
        self.paramSetTabView.transform = CGAffineTransformMakeTranslation(0, [self viewHeight]);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)show {
    [UIView animateWithDuration:.2 animations:^{
        self.paramSetTabView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    } completion:^(BOOL finished) {
        
    }];
}

@end
