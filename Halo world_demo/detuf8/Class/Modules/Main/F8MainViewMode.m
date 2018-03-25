//
//  F8MainViewMode.m
//  detuf8
//
//  Created by Seth on 2018/2/27.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8MainViewMode.h"

@implementation F8MainViewMode

+ (void)connectCameraWithCallBack:(void(^)(SocketType))res
    queryAndSetOptionWithCallBack:(void(^)(EN_RET_CODE_LIST EN_RET_CODE_LIST))res1
{
    [[F8SocketAPI shareInstance] connectCameraWithResult:^(SocketType socketType) {
        
        if (socketType != SocketConnected) {
            if (res) res(socketType);
        } else {
            if (res) res(socketType);
            if (!res1) {
                return ;
            }
            [self queryAndSetOptionWithCallBack:res1];
        }
    }];
}

+ (void)queryAndSetOptionWithCallBack:(void(^)(EN_RET_CODE_LIST EN_RET_CODE_LIST))res
{
    [[F8SocketAPI shareInstance] queryCameraStatesWithResult:^(F8SocketModel * e) {
        if (e.rval == 0) {
            [[F8SocketAPI shareInstance].cameraInfo saveCameraConfigData:e];
            [[F8SocketAPI shareInstance] setSystemTimeWithResult:^(F8SocketModel * m) {
                
            }];
        }
        if (res) res(e.rval);
    }];
}

@end
