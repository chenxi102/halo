//
//  F8SocketQueue.h
//  detuf8
//
//  Created by Seth on 2017/12/26.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F8Protocol.h"

@class F8SocketModel;
typedef NS_ENUM(NSInteger, SocketType){
    SocketReadToConnect = 0 ,                // socket 待连接
    SocketConnecting = 5 ,                   // socket 连接中
    SocketConnected = 1 ,                    // socket 已连接
    SocketOfflineByUser = 2 ,                // socket 用户主动断开 ：不提示
    SocketOfflineByWifiCut  = 3 ,            // socket wifi断开    ：提示异常
    SocketOfflineByServer   = 4 ,            // socket 服务器掉线   ：重连
    SocketConnectFailed = 6 ,                // socket 连接失败
    SocketConnectOthers = 7                  // socket 已被他人连接
};

// 需要提示的错误类型
typedef NS_ENUM(NSInteger, SocketExceptionType){
    SocketException_WiFi = 4 ,                // socket 待连接
    SocketException_Service = 1 ,             // socket 服务器断开，且连不上
    SocketException_Others = 2 ,              // socket 他人连接
    SocketException_Unkown = 3 ,              // socket 未知错误
};
typedef void(^socketDataCallback)(F8SocketModel*);
typedef void(^socketConnectCallback)(SocketType);



@interface F8SocketHandle : NSObject
@property (atomic, assign) SocketType socketType ;
@property (atomic, assign) int tokenNumber ;
@property (nonatomic, copy) socketDataCallback socketNotifyCallback;

- (void)removeAllCommand;
- (void)disConnectSocket;
- (BOOL)connectSocketCallBack:(socketConnectCallback)resB;
- (void)sendCommandBody:(F8SocketModel *)comandBody withTimeOut:(NSTimeInterval)timeOut Result:(socketDataCallback)res;

@end






@interface F8SocketModel : NSObject
@property (nonatomic, assign) int msgid; //消息命令
@property (nonatomic, assign) int token; //会话ID
@property (nonatomic, assign) int paramType; //数据类型： 0 int/ 1 string /2 nil /3. float
@property (nonatomic, strong) id  param; //消息字段(标定)
@property (nonatomic, assign) int rval;  //错误返回
@end
