//
//  F8SocketAPI.m
//  detuf8
//
//  Created by Seth on 2017/12/26.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8SocketAPI.h"
#import "F8SocketHandle.h"

@interface F8SocketAPI ()
{
    @private
    id  __targad; SEL __sel;
    NSMutableDictionary * __cameraNotifyTargadAndSelDic;         // 相机推送信息监听
    NSMutableDictionary * __cameraExceptionTargadAndSelDic;      // 相机异常信息监听
    socketConnectCallback __res;
}

@property (atomic, strong, readwrite) NSOperationQueue * operationQueue ;
@property (atomic, strong) F8SocketHandle * socketHandler ;
@property (nonatomic) dispatch_semaphore_t _dispatch_semaphore_sigal;

@property (nonatomic, strong) NSTimer * heartBearTimer;

@end

@implementation F8SocketAPI

//=================================
//notify
- (void)registerTargad:(id)targad CameraNotify:(SEL)notifySel{
    if (targad && notifySel &&![targad isEqual:__cameraNotifyTargadAndSelDic[NSStringFromSelector(notifySel)]]) {
        [__cameraNotifyTargadAndSelDic setObject:targad forKey:NSStringFromSelector(notifySel)];
    }
}

- (void)registerTargad:(id)targad CameraExceptionNotify:(SEL)notifySel {
    if (targad && notifySel &&![targad isEqual:__cameraExceptionTargadAndSelDic[NSStringFromSelector(notifySel)]]) {
        [__cameraExceptionTargadAndSelDic setObject:targad forKey:NSStringFromSelector(notifySel)];
    }
}

- (void)disRegisterTargad:(id)targad
{
    for (NSString* t in __cameraNotifyTargadAndSelDic.allKeys) {
        id  __tagard = __cameraNotifyTargadAndSelDic[t];
        if ([__tagard isEqual:targad]) {
            [__cameraNotifyTargadAndSelDic removeObjectForKey:t];
//            break;  不能break 可能一个Key 对应多值
        }
    }
    
    for (NSString* t in __cameraExceptionTargadAndSelDic.allKeys) {
        id  __tagard = __cameraExceptionTargadAndSelDic[t];
        if ([__tagard isEqual:targad]) {
            [__cameraExceptionTargadAndSelDic removeObjectForKey:t];
//            break;  不能break 可能一个Key 对应多值
        }
    }
}

- (void)notifyHandle {
    __weak typeof(__cameraNotifyTargadAndSelDic) __wTargadAndSelDic = __cameraNotifyTargadAndSelDic;
    self.socketHandler.socketNotifyCallback = ^(F8SocketModel *e) {
        __weak typeof(__wTargadAndSelDic) __targadAndSelDic = __wTargadAndSelDic;
        for (NSString* t in __targadAndSelDic.allKeys) {
            SEL sel = NSSelectorFromString(t);
            id  tagard = __targadAndSelDic[t];
            if ([tagard respondsToSelector:sel]) {
                SuppressPerformSelectorLeakWarning
                (
                 [tagard performSelector:sel withObject:e];
                );
            }
        }
    };
}

- (void)tagardInvacationSelectorWithType:(SocketExceptionType)type
{
    for (NSString* t in __cameraExceptionTargadAndSelDic.allKeys) {
        SEL sel = NSSelectorFromString(t);
        id  tagard = __cameraExceptionTargadAndSelDic[t];
        if ([tagard respondsToSelector:sel]) {
            SuppressPerformSelectorLeakWarning
            (
             [tagard performSelector:sel withObject:@(type)];
             );
        }
    }
}

- (void)cameraExceptionNotifyCation:(NSNotification *)notifycation {
    NSNumber * type = (NSNumber *)([notifycation userInfo][Socket_exception_String]);
    [self tagardInvacationSelectorWithType:type.longValue];
}

//=================================
//组包

- (F8SocketModel *)setupPackModelWithMsgId:(EN_MSGID_LIST)msgid{
    F8SocketModel * model = [F8SocketModel new];
    model.msgid = msgid;
    model.paramType = 2;
    return model;
}

- (F8SocketModel *)setupPackModelWithMsgId:(EN_MSGID_LIST)msgid  paramInt:(int)paramInt {
    F8SocketModel * model = [F8SocketModel new];
    model.msgid = msgid;
    model.param = @(paramInt);
    model.paramType = 0;
    return model;
}

- (F8SocketModel *)setupPackModelWithMsgId:(EN_MSGID_LIST)msgid  paramFloat:(float)paramFloat {
    F8SocketModel * model = [F8SocketModel new];
    model.msgid = msgid;
    model.param = @(paramFloat);
    model.paramType = 0;
    return model;
}

- (F8SocketModel *)setupPackModelWithMsgId:(EN_MSGID_LIST)msgid  paramString:(NSString*)paramString {
    F8SocketModel * model = [F8SocketModel new];
    model.msgid = msgid;
    model.param = paramString;
    model.paramType = 1;
    return model;
}

//=================================
// MARK: 信号量
- (BOOL)waitForRes:(NSTimeInterval)sec {
    long threadTimeOut = dispatch_semaphore_wait(self._dispatch_semaphore_sigal, dispatch_time(DISPATCH_TIME_NOW, (int64_t)(sec * NSEC_PER_SEC)));
    if (threadTimeOut != 0) {
        return NO;
    } else {
        return YES;
    }
}

- (void)noWaitjustContinue {
    dispatch_semaphore_signal(self._dispatch_semaphore_sigal);
}

//=================================
- (instancetype)init
{
    self = [super init];
    if (self) {
        _cameraInfo = [F8CameraInfo new];
        __cameraNotifyTargadAndSelDic = [NSMutableDictionary dictionary];
        __cameraExceptionTargadAndSelDic = [NSMutableDictionary dictionary];
        __dispatch_semaphore_sigal = dispatch_semaphore_create(0);
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(cameraExceptionNotifyCation:) name:CameraExceptionNotify object:nil];
        self.heartBearTimer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(heartBeatTimerRepeatAction:) userInfo:nil repeats:YES];
        [self.heartBearTimer setFireDate:[NSDate distantFuture]];
    }
    return self;
}

+ (instancetype)shareInstance {
    static F8SocketAPI * single;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        if (!single) {
            single = [F8SocketAPI new];
            single.socketHandler = [F8SocketHandle new];
            single.operationQueue = [[NSOperationQueue alloc] init];
            single.operationQueue.maxConcurrentOperationCount = 1;
            [single notifyHandle];
        }
    });
    return single;
}

- (void)cancelAllOpretion {
    if (self.operationQueue) {
        [self.operationQueue cancelAllOperations];
    }
}

- (void)disConnectSocket {
    [self.socketHandler disConnectSocket];
}

- (SocketType)socketType {
    return self.socketHandler.socketType;
}

//=================================
// MARK: -- 相机命令 =====================================================================================
- (void)connectCameraWithResult:(socketConnectCallback)res {
    [self cancelAllOpretion];
    __res = res;
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        @weak(self)
        [self.socketHandler connectSocketCallBack:^(SocketType type) {
            @strong(self)
            if (type == SocketConnected) {
                F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_START_SESSION];
                @weak(self)
                [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
                    @strong(self)
                    if (e.rval == 0) {
                        self.socketHandler.tokenNumber = (int)e.token;
                        if(__res)__res(SocketConnected);
                    } else if (e.rval == -4){
                        self.socketHandler.tokenNumber = 0;
                        if(__res){
                            __res(SocketConnectOthers);
                        } else {
                            [self tagardInvacationSelectorWithType:SocketException_Others];
                        }
                    } else {
                        self.socketHandler.tokenNumber = 0;
                        if(__res){
                            __res(SocketConnectFailed);
                        } else {
                           [self tagardInvacationSelectorWithType:SocketException_Service];
                        }
                    }
                    __res = nil;
                }];
            } else {
                if (__res) {
                    __res(SocketConnectFailed);
                } else {
                    [self tagardInvacationSelectorWithType:SocketException_Service];
                }
                __res = nil;
            }
        }];
    }];
    [self.operationQueue addOperation:op];
}

// MARK: 常用命令
// MARK: 心跳 回答信息包含：电量、卡容量、
- (void)heartBeatWithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_HEARTBEAT];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_LONG];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"心跳超时");
        }
    }];
    
    op.name = @"queryCameraStates";
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

- (void)heartBeatTimerRepeatAction:(NSTimer *)timer {
    [self heartBeatWithResult:^(F8SocketModel * e) {
        
    }];
}

- (void)setHeartBeatFireDate:(NSTimeInterval)time{
    if (self.heartBearTimer && [self.heartBearTimer isValid]) {
//        if (time == -1) {
            [self.heartBearTimer setFireDate:[NSDate distantFuture]];
//        }else
//            [self.heartBearTimer setFireDate:[NSDate dateWithTimeIntervalSinceNow:time]];
    }
}

// MARK: 查询信息
- (void)queryCameraStatesWithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_GET_USER_CONFIGURE paramInt:1];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            [self.cameraInfo saveCameraConfigData:e];
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_LONG];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"查询相机的配置参数");
        }
    }];
    
    op.name = @"queryCameraStates";
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}


// MARK: 获取拍录状态
- (void)getRecordStateWithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_GET_RECORD_STATE];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_LONG];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"查询相机的拍录状态");
        }
    }];
    [self.operationQueue addOperation:op];
}

// MARK: 获取拍录时间
- (void)getRecordTimeWithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_GET_RECORD_TIME];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_LONG];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"查询相机的拍录时间");
        }
    }];
    [self.operationQueue addOperation:op];
}

// MARK: 查询相机时间
- (void)setSystemTimeWithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_SET_SYSTEM_TIME paramInt:1];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            if (res)res(e);
            
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置相机时间超时");
        }
    }];
    [self.operationQueue addOperation:op];
}
// MARK: 拍照
- (void)takePhotoWithResult:(socketDataCallback)res {
    [self setHeartBeatFireDate:-1];
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_START_SNAPSHOT];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e) {
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_LONG];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"拍照超时");
        }
        [self setHeartBeatFireDate:3];
    }];
    
    op.name = @"takePhoto";
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 开启录像
- (void)recordStartWithResult:(socketDataCallback)res {
    [self setHeartBeatFireDate:-1];
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_START_RECORD paramInt:YES];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"开始录像超时");
        }
        
        [self setHeartBeatFireDate:3];
    }];
    op.name = @"recordStart";
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 停止录像
- (void)recordStopWithResult:(socketDataCallback)res {
    [self setHeartBeatFireDate:-1];
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_STOP_RECORD paramInt:NO];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"结束录像超时");
        }
        [self setHeartBeatFireDate:3];
    }];
    op.name = @"recordStop";
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置模式命令
- (void)setMediaMode:(int)mode WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        @weak(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_SET_MEDIA_MODE paramInt:mode];
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置相机模式超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setMediaMode"];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 设置曝光模式
// MARK: Set capture effect   0代表2D模式，1代表3D模式
- (void)setCaptureEffect:(int)effect WithResult:(socketDataCallback)res  {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        @weak(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_SET_CAPTURE_EFFECT paramInt:effect];
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"Set capture effect超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setCaptureEffect"];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: -- ISP =====================================================================================

// MARK: 设置AE : 图片模式ae模式，0 – 自动AE模式，1 – 手动AE 模式
- (void)setPictureAEmode:(int)ae WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        @weak(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_SET_PICTURE_AE_MODE paramInt:ae];
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"setPictureAEmode 超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPictureAEmode"];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置ISO命令
- (void)setPICorMOVIE:(BOOL)PICorMOVI ISO:(int)iso WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        @weak(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_ISO:MSGID_SET_VIDEO_ISO paramInt:iso];
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置ISO超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%dISO",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 设置图片视频的EV
- (void)setPICorMOVIE:(BOOL)PICorMOVI EV:(float)ev WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_EV:MSGID_SET_VIDEO_EV paramFloat:ev];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置EV超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%dEV",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}


// MARK: 设置色温
- (void)setPICorMOVIE:(BOOL)PICorMOVI ColorTemp:(int)temp WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_COLOR_TEMPWEATURE:MSGID_SET_VIDEO_COLOR_TEMPWEATURE paramInt:temp];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置色温超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%dtemp",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 设置快门时间
- (void)setPICorMOVIE:(BOOL)PICorMOVI Shutter:(float)shutter WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_SHUTTER_SPEED:MSGID_SET_VIDEO_SHUTTER_SPEED paramFloat:shutter];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置快门时间超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%dShutter",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}
// MARK: 设置WB
- (void)setPICorMOVIE:(BOOL)PICorMOVI WB:(int)wb WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_AWB_MODE:MSGID_SET_VIDEO_AWB_MODE paramInt:wb];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置WB超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%dwb",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}



// MARK: 设置HDR
- (void)setPICorMOVIE:(BOOL)PICorMOVI HDR:(int)hdr WithResult:(socketDataCallback)res  {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_HDR:MSGID_SET_VIDEO_HDR paramInt:hdr];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置HDR超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%d HDR",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置亮度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Brightness:(int)Brightness WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_BRIGHTNESS:MSGID_SET_VIDEO_BRIGHTNESS paramInt:Brightness];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置Brightness超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%d Brightness",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置饱和度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Saturation:(int)Saturation WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_SATURATION:MSGID_SET_VIDEO_SATURATION paramInt:Saturation];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置Saturation超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%d Saturation",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置锐度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Sharpness:(int)Sharpness WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_SHARPNESS:MSGID_SET_VIDEO_SHARPNESS paramInt:Sharpness];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置Sharpness超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%d Sharpness",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置对比度
- (void)setPICorMOVIE:(BOOL)PICorMOVI Contrast:(int)Contrast WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_SET_PICTURE_CONSTRAST:MSGID_SET_VIDEO_CONSTRAST paramInt:Contrast];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置Contrast超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setPICorMOVIE%d Contrast",PICorMOVI];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}

// MARK: 设置分辨率
- (void)setResolution:(int)resolution WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:MSGID_SET_SNAPSHOT_RESOLUTION paramInt:resolution];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"设置resolution超时");
        }
    }];
    op.name = [NSString stringWithFormat:@"setResolution"];
    for (NSOperation * p in self.operationQueue.operations) {
        if ([p.name isEqualToString: op.name]) {
            return;
        }
    }
    [self.operationQueue addOperation:op];
}


// MARK: ===重置 曝光 画质 等等 ================================================================================
- (void)resetAE_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res {
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_RESET_PIC_AE:MSGID_RESET_VIDEO_AE];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"重置 AE 超时");
        }
    }];
   
    [self.operationQueue addOperation:op];
}

- (void)resetAWB_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res
{
    [self cancelAllOpretion];
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_RESET_PIC_AWB:MSGID_RESET_VIDEO_AWB];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"重置 画质 超时");
        }
    }];
    [self.operationQueue addOperation:op];
}
- (void)resetPicTure_PICorMOVIE:(BOOL)PICorMOVI WithResult:(socketDataCallback)res {
    @weak(self)
    NSBlockOperation * op = [NSBlockOperation blockOperationWithBlock:^{
        @strong(self)
        F8SocketModel * model = [self setupPackModelWithMsgId:PICorMOVI?MSGID_RESET_PIC_QUALITY:MSGID_RESET_VIDEO_QUALITY];
        @weak(self)
        [self.socketHandler sendCommandBody:model withTimeOut:-1 Result:^(F8SocketModel * e){
            @strong(self)
            if (res)res(e);
            [self noWaitjustContinue];
        }];
        BOOL __res = [self waitForRes:COMMAND_TIMEOUT_SHORT];
        if (!__res) {
            F8SocketModel * e = [F8SocketModel new];
            e.rval = -10000;
            if (res)res(e);
            NSLog(@"重置 画质 超时");
        }
    }];
    [self.operationQueue addOperation:op];
}
@end
