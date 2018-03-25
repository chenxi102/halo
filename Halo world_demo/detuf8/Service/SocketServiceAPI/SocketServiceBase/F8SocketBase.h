//
//  F8SocketBase.h
//  detuf8
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "GCDAsyncSocket.h"
#import "F8SocketHandle.h"

@protocol  F8SocketBaseDelegate <NSObject>

@optional
/**
 端口连接成功
 */
-(void)socketDidConnect:(NSString *)connectHost onPort:(int)port;
/**
 端口连接失败,超时
 */
- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err;
/**
 接收消息代理
 */
- (void)didReceiveMessage:(F8SocketModel *)messageModel;

@end

@interface F8SocketBase : NSObject <GCDAsyncSocketDelegate>
/*
 *  Socket 回调代理
 */
@property (nonatomic, weak) id <F8SocketBaseDelegate> F8SocketBaseDelegate;
/*
 *  GCDAsyncSocket
 */
@property (nonatomic, strong) GCDAsyncSocket * F8Socket;
/*
 *  命令是否完成闭环
 */
@property (nonatomic, assign) BOOL commandisFinish;

- (BOOL)connectSocketWithHost:(NSString *)host onPort:(uint16_t)port ;
- (void)disConnect ;
- (void)send:(NSDictionary *)data withTimeOut:(NSTimeInterval)timeOut ;

@end
