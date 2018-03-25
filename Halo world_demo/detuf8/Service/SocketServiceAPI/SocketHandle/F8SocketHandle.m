//
//  F8SocketQueue.m
//  detuf8
//
//  Created by Seth on 2017/12/26.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8SocketHandle.h"
#import "F8SocketBase.h"


@implementation F8SocketModel
@end

@interface F8SocketHandle ()<F8SocketBaseDelegate>

@property (nonatomic, strong) F8SocketBase * socketCenter;
@property (nonatomic, assign) int socketReconnectCount;
@property (nonatomic, copy) socketDataCallback socketDataCallback;
@property (nonatomic, copy) socketConnectCallback socketConnectCallback;

@property (nonatomic) dispatch_semaphore_t dispatch_semaphore_sigal;

@end

@implementation F8SocketHandle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.socketCenter = [F8SocketBase new];
        self.socketCenter.F8SocketBaseDelegate = self;
        self.tokenNumber = 0;
        self.socketReconnectCount = 0;
        self.socketType = SocketReadToConnect;
    }
    return self;
}

- (void)disConnectSocket {
    self.tokenNumber = 0;
    self.socketReconnectCount = 0;
    self.socketType = SocketOfflineByUser;
    [self.socketCenter disConnect];
}

- (BOOL)connectSocketCallBack:(socketConnectCallback)resB {
    
    if ([F8DeviceManager sharedInstance].curConnDevice != F8WiFiType_F8) {
        if(resB)resB(SocketConnected);
        DataTrackLog(@"WIFI 已经断开 ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ");
        return NO;
    }
    
    if (self.socketType == SocketConnected && self.socketCenter.F8Socket.isConnected) {
        if(resB)resB(SocketConnected);
        DataTrackLog(@"socket已经连接，无需再次连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ");
        return NO;
    }
    self.socketConnectCallback = resB;
    self.socketType = SocketConnecting;
    BOOL res  = [self.socketCenter connectSocketWithHost:F8_HOST onPort:F8_PORT];
    return res;
}

- (BOOL)reConnectSocket {
    
    if (self.socketReconnectCount >= SOCKET_RECONNECT_TIME ) {
        if (self.socketConnectCallback) {
            self.socketConnectCallback(SocketConnectFailed);
//            self.socketConnectCallback = nil;
            self.socketReconnectCount = 0;
        }
        return NO;
    }
    self.socketReconnectCount++;
    DataTrackLog(@"socket 重新连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ 第%d次", self.socketReconnectCount);
    return [self connectSocketCallBack:self.socketConnectCallback];
}

//TODO: -发送命令
- (void)sendCommandBody:(F8SocketModel *)comandBody withTimeOut:(NSTimeInterval)timeOut Result:(socketDataCallback)res
{
    if (self.socketType != SocketConnected) {
        DataTrackLog(@"socket已经断开，请重新连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ");
        return;
    }
    if (comandBody.msgid != MSGID_START_SESSION &&self.tokenNumber == 0) {
        DataTrackBugLog(@"token 丢失☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
        return;
    }
    self.socketDataCallback = res;
    NSDictionary * params = [self buildPacket:comandBody withToken:self.tokenNumber];
    [self.socketCenter send:params withTimeOut:timeOut];
}

// MARK: F8SocketBaseDelegate
// MARK: 连接成功
-(void)socketDidConnect:(NSString *)connectHost onPort:(int)port {
    self.socketType = SocketConnected ;
    self.socketReconnectCount = 0;
    self.tokenNumber = 0;
    if (self.socketConnectCallback) {
        self.socketConnectCallback(SocketConnected);
//        self.socketConnectCallback = nil;
    }
    DataTrackLog(@"socket 已经连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
}

// MARK: 连接失败,超时
-(void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    if (err.code == 57) {self.socketType = SocketOfflineByWifiCut ;}
    else
    {
        if (self.socketType != SocketOfflineByUser) {
            self.socketType = SocketOfflineByServer ;
        }
    }
    [self socketDidDisconnectResultHandle];
}

// 连接失败的处理
- (void)socketDidDisconnectResultHandle {
   
    if (self.socketType == SocketOfflineByServer) {
        DataTrackLog(@"服务器掉线 导致 socket 断开连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(.1 * NSEC_PER_SEC)), dispatch_get_global_queue(0, 0), ^{
            [self reConnectSocket];
        });
    }else if (self.socketType == SocketOfflineByWifiCut) {
        DataTrackLog(@"WIFI 断开导致 socket 断开连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
        self.socketReconnectCount = 0;
        self.tokenNumber = 0;
        [[NSNotificationCenter defaultCenter] postNotificationName:CameraExceptionNotify object:nil userInfo:@{Socket_exception_String:@(SocketException_WiFi)}];
    }else {
        [[NSNotificationCenter defaultCenter] postNotificationName:CameraExceptionNotify object:nil userInfo:@{Socket_exception_String:@(SocketException_Unkown)}];
        DataTrackLog(@"用户主动断开或者其他原因 导致 socket 断开连接☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
    }
}

// MARK: 接收消息代理
- (void)didReceiveMessage:(F8SocketModel *)messageModel
{
    if (self.socketDataCallback)
    {
        self.socketDataCallback(messageModel);
        self.socketDataCallback = nil;
    }else {
        if (self.socketNotifyCallback) {
            self.socketNotifyCallback(messageModel);
        }
    }
}


//TODO: -组建数据包
- (NSMutableDictionary *)buildPacket:(F8SocketModel *)body withToken:(int)token
{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc]init];
    [dict setObject:@(token) forKey:@"token"];
    [dict setObject:@(body.msgid) forKey:@"msgid"];
    // int
    if (body.paramType == 0) {
        NSNumber * m = (NSNumber*)body.param;
//        int param = (int)(body.param);
        [dict setObject:m forKey:@"param"];
    }
    // string
    else if (body.paramType == 1){
        NSString * param = (NSString *)(body.param);
        [dict setObject:param forKey:@"param"];
    }
    // float
    else if (body.paramType == 3){
        NSNumber * m = (NSNumber*)body.param;
//        NSString * param = m.floatValue;
        [dict setObject:m forKey:@"param"];
    }
    // 2 nil
    else
    {
         // 不处理
    }
    return dict;
}
@end


