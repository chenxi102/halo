//
//  F8MainViewMode.h
//  detuf8
//
//  Created by Seth on 2018/2/27.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface F8MainViewMode : NSObject


+ (void)connectCameraWithCallBack:(void(^)(SocketType))res
    queryAndSetOptionWithCallBack:(void(^)(EN_RET_CODE_LIST EN_RET_CODE_LIST))res1;

+ (void)queryAndSetOptionWithCallBack:(void(^)(EN_RET_CODE_LIST EN_RET_CODE_LIST))res;

@end
