//
//  F8ActiveMonitor.h
//  F8-Plus
//
//  Created by lsq on 2017/8/29.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  @abstract Application‘s  status
 */
typedef NS_ENUM(NSInteger, ApplicationStatus) {
    ApplicationStatus_None                 = 0 ,
    ApplicationStatus_enterForeground      = 1 ,
    ApplicationStatus_becomeActive         = 2 ,
    ApplicationStatus_resignActive         = 3 ,
    ApplicationStatus_enterBackground      = 4
};

/**
 *  @abstract call‘s  status
 */
typedef NS_ENUM(NSInteger, CTCallStates) {
    CTCallStates_None              = 0 ,
    CTCallStates_Incoming          = 1 ,
    CTCallStates_Connected         = 2 ,
    CTCallStates_Disconnected      = 3
};

typedef struct ActiveState {
    CTCallStates                cTCallStates ;                  // 电话机的状态
    ApplicationStatus           applicationStatus ;             // 应用的状态
}ActiveState;

@interface F8ActiveMonitor : NSObject

+ (instancetype)sharedInstance;
///<  1.APP进入前后台 2.电话响应的 通知
@property (nonatomic, copy) void (^applicationStateNotifyBlock)() ;

@property (nonatomic, assign) struct ActiveState activeState ;
@property (nonatomic, assign) BOOL ApplicationisActive;

- (void)monitor;
@end

