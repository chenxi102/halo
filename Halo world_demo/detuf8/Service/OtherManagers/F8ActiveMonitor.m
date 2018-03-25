//
//  F8ActiveMonitor.m
//  F8-Plus
//
//  Created by lsq on 2017/8/29.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8ActiveMonitor.h"
#import <CoreTelephony/CTCallCenter.h>
#import <CoreTelephony/CTCall.h>

@interface F8ActiveMonitor()

@property (nonatomic, strong) CTCallCenter *callCenter;

@end

@implementation F8ActiveMonitor

+ (instancetype) sharedInstance{
    static F8ActiveMonitor  * obj = nil;
    static dispatch_once_t token;
    dispatch_once(&token, ^{
        obj = [[self alloc] init];
        [obj monitor];
    });
    return obj;
}

//  状态监控
- (void)monitor {
    struct ActiveState status;
    status.cTCallStates = CTCallStates_None;
    self.activeState = status;

    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidBecomeActive:) name:UIApplicationDidBecomeActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillResignActive:) name:UIApplicationWillResignActiveNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationDidEnterBackground:) name:UIApplicationDidEnterBackgroundNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(applicationWillEnterForeground:) name:UIApplicationWillEnterForegroundNotification object:nil];
    
    self.callCenter = [CTCallCenter new];
    __weak typeof(self) weak = self;
    self.callCenter.callEventHandler = ^(CTCall *call){
        __strong typeof(weak) self = weak;
        DeBugLog(@"电话状态是：%@",call.callState);
        ActiveState s;
        s = self.activeState;
        if ([call.callState isEqualToString:@"CTCallStateIncoming"]) {
            s.cTCallStates = CTCallStates_Incoming;
        }else if ([call.callState isEqualToString:@"CTCallStateConnected"]){
            s.cTCallStates = CTCallStates_Connected;
        }else {
            s.cTCallStates = CTCallStates_Disconnected;
        }
        self.activeState = s;
        [self applicationStateNotifyhanler];
    };
}

- (void)applicationWillResignActive:(UIApplication *)application{
    DeBugLog(@"应用状态------------->:失去活跃");
    ActiveState s;
    s = self.activeState;
    s.applicationStatus = ApplicationStatus_resignActive ;
    self.activeState = s;
    self.ApplicationisActive = NO;
    [self applicationStateNotifyhanler];
}

- (void)applicationDidBecomeActive:(UIApplication *)application{
    DeBugLog(@"应用状态------------->:变成活跃");
    ActiveState s;
    s = self.activeState;
    s.applicationStatus = ApplicationStatus_becomeActive ;
    self.activeState = s;
    self.ApplicationisActive = YES;
    [self applicationStateNotifyhanler];
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    DeBugLog(@"应用状态------------->:进入后台");
    ActiveState s;
    s = self.activeState;
    s.applicationStatus = ApplicationStatus_enterBackground ;
    self.activeState = s;
    self.ApplicationisActive = NO;
    [self applicationStateNotifyhanler];
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    DeBugLog(@"应用状态------------->:进入前台");
    ActiveState s;
    s = self.activeState;
    s.applicationStatus = ApplicationStatus_enterForeground ;
    self.activeState = s;
    self.ApplicationisActive = YES;
    [self applicationStateNotifyhanler];
}

- (void)applicationStateNotifyhanler {
    [[NSNotificationCenter defaultCenter] postNotificationName:applicationStateNotify object:nil];
    ActiveState s;
    s = self.activeState;
    s.applicationStatus = ApplicationStatus_None ;
    s.cTCallStates = CTCallStates_None ;
    self.activeState = s;
}

@end
