//
//  F8SocketBase.m
//  detuf8
//
//  Created by lsq on 2017/5/20.
//  Copyright © 2017年 detu. All rights reserved.
//

#import "F8SocketBase.h"
#import "F8Protocol.h"



const char * sendSocketKey = "com.sendSocket";
const char * reciveSocketKey = "com.receiveSocket";

@interface F8SocketBase()
@property (strong, nonatomic) dispatch_queue_t sendQueue;
@property (strong, nonatomic) dispatch_queue_t receiveQueue;
@property (nonatomic, strong) NSLock *dataLock;
@property (nonatomic, strong) NSMutableData *mutData;
@end

@implementation F8SocketBase

#if 1

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.mutData = [NSMutableData data];
        self.dataLock = [[NSLock alloc] init];
        self.commandisFinish = YES;
        self.F8Socket = [[GCDAsyncSocket alloc] initWithDelegate:self delegateQueue:dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)];
    }
    return self;
}

- (dispatch_queue_t)sendQueue {
    if (nil == _sendQueue) {
        _sendQueue = dispatch_queue_create(sendSocketKey, DISPATCH_QUEUE_SERIAL);
    }
    return _sendQueue;
}

- (dispatch_queue_t)receiveQueue {
    if (nil == _receiveQueue) {
        _receiveQueue = dispatch_queue_create(reciveSocketKey, DISPATCH_QUEUE_SERIAL);
    }
    return _receiveQueue;
}

//TODO: -建立接收数据sorcket连接
- (BOOL )connectSocketWithHost:(NSString *)host onPort:(uint16_t)port {
    
    DeveloperMode(
                  NSAssert(host&&port, @"ip or port is nil");
    )
    if (!host || !port) {
        DataTrackLog(@"IP Port 为空!!!");
        return NO;
    }
    NSError *error;
    [self.F8Socket connectToHost:host onPort:port withTimeout:SOCKET_TIMEOUT error:&error];
    if (error) {
        [self socketDidDisconnect:self.F8Socket withError:error];
    }
    return YES;
}

//TODO: -关闭socket
- (void)disConnect {
    
    if (self.F8Socket.isDisconnected && nil == self.F8Socket.delegate) {
        return;
    }
    
    DataTrackLog(@"Socket 主动断开 ☆ ☆ ☆ ☆ ☆ ☆ ☆ ☆");
    [self.F8Socket disconnect];
}

//TODO: -发送消息
- (void)send:(NSDictionary *)data withTimeOut:(NSTimeInterval)timeOut
{
    @synchronized(self) {
        dispatch_block_t block =  ^{
            int tag = [[data objectForKey:@"msgid"] intValue];
            NSMutableData *jsonData = [NSMutableData data];
            NSData *__Data = [NSJSONSerialization dataWithJSONObject:data options:NSJSONWritingPrettyPrinted error:nil];
            [jsonData appendData:__Data];
            [jsonData appendData:[@"\r\n" dataUsingEncoding:NSUTF8StringEncoding]];
            [self.F8Socket writeData:jsonData withTimeout:timeOut tag:tag];
            [self.F8Socket readDataWithTimeout:-1 tag:tag];
            NSString * dataStr = [[[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding] stringByReplacingOccurrencesOfString:@"\n" withString:@""];
            DataTrackLog(@"snd data:%@", dataStr);
        };
        if (dispatch_get_specific(sendSocketKey)) {
            block();
        }else
            dispatch_sync(self.sendQueue, block);
    }
}

//TODO: -开启接收数据
- (void)beginReadDataTimeOut:(long)timeOut tag:(long)tag {
//    if (tag == MSGID_START_SESSION) {
//        // 未定义结束符
//        [self.F8SocketBase readDataWithTimeout:-1 tag:0];
//    }else{
//        [self.F8SocketBase readDataToData:[GCDAsyncSocket LFData] withTimeout:timeOut maxLength:0 tag:tag];
//    }
}

//TODO: -GCDAsyncSocketDelegate
- (void)socket:(GCDAsyncSocket *)sock didConnectToHost:(NSString *)host port:(uint16_t)port
{
    dispatch_block_t block =  ^{
        DataTrackLog(@" socket connect to server success");
        self.commandisFinish = YES;
        if ([self.F8SocketBaseDelegate respondsToSelector:@selector(socketDidConnect:onPort:)]) {
            [self.F8SocketBaseDelegate socketDidConnect:sock.localHost onPort:sock.localPort];
        }
//        [self.F8Socket readDataWithTimeout:-1 tag:0];
    };
    if (dispatch_get_specific(reciveSocketKey)) {
        block();
    }else
        dispatch_sync(self.receiveQueue, block);
}

- (void)socketDidDisconnect:(GCDAsyncSocket *)sock withError:(NSError *)err
{
    dispatch_block_t block =  ^{
        DataTrackLog(@" socketDelegata:socketDidDisconnect:error is %@", err.description);
        self.commandisFinish = YES;
        if ([self.F8SocketBaseDelegate respondsToSelector:@selector(socketDidDisconnect:withError:)]) {
            [self.F8SocketBaseDelegate socketDidDisconnect:sock withError:err];
        }
    };
    if (dispatch_get_specific(reciveSocketKey)) {
        block();
    }else
        dispatch_sync(self.receiveQueue, block);
}

//TODO: -写入数据成功 , 重新开启允许读取数据
- (void)socket:(GCDAsyncSocket *)sock didWriteDataWithTag:(long)tag {
    self.commandisFinish = NO;
    DataTrackLog(@" socketDelegata:snd data success");
}

//TODO: -接收到消息
- (void)socket:(GCDAsyncSocket *)sock didReadData:(NSData *)data withTag:(long)tag
{
    dispatch_block_t block =  ^{
        NSString * dataStr = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
        [self.mutData appendData:data];
        [self.F8Socket readDataWithTimeout:-1 tag:0];
        [self unpacking:self.mutData];
        self.commandisFinish = YES;
        DataTrackLog(@" socketDelegata:rcv data is %@",dataStr);
    };
    if (dispatch_get_specific(reciveSocketKey)) {
        block();
    }else
        dispatch_sync(self.receiveQueue, block);
}

//TODO: -拆包处理
- (void)unpacking:(NSData *)data{
    
    int left = 0, rigth = 0 , cut = 0 ;
    NSData *packet = nil;
    Byte *allByte = (Byte *)[data bytes];
    
    if(!allByte)
        return;
    
    for (int i = 0; i < [data length]; i++){
        if ([[NSString stringWithFormat:@"%c",allByte[i]] isEqualToString:@"{"]) {
            left++;
        }else if ([[NSString stringWithFormat:@"%c",allByte[i]] isEqualToString:@"}"]){
            rigth++;
        }
        int cutLength = i + 1 - cut;
        // 这是个完整的包
        if ((left == rigth) && (left > 0) && (rigth > 0)) {
            packet = [data subdataWithRange:NSMakeRange(cut, cutLength)];
            [self handleData:packet];
            left = 0;
            rigth = 0;
            cut = i + 1;
            [self.mutData setLength:0];
        }
    }
}

//TODO: -数据处理
- (void)handleData:(NSData *)packet
{
    NSString *secretStr  = [[NSString alloc] initWithData:packet encoding:NSUTF8StringEncoding];
    secretStr = [secretStr stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    secretStr            = [secretStr stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    F8SocketModel *messageModel = [F8SocketModel mj_objectWithKeyValues:secretStr];
    
    if ([self.F8SocketBaseDelegate respondsToSelector:@selector(didReceiveMessage:)]) {
        [self.F8SocketBaseDelegate didReceiveMessage:messageModel];
    }
    
        //        [self.dataLock lock];
        //        NSString *strsss;
        //        if (messageModel.rval == 0) {
        //            strsss = [NSString stringWithFormat:@"recive success: %@\r\n",secretStr];
        //        }else{
        //            strsss = [NSString stringWithFormat:@"recive faile: %@\r\n",secretStr];
        //        }
        //        [[F8SocketManager sharedInstance].cameraInfo.dataStr appendString:strsss];
        //        [F8SocketManager sharedInstance].cameraInfo.curentStr = strsss;
        //        [[NSNotificationCenter defaultCenter] postNotificationName:@"dataHasChange" object:nil];
        //        [self.dataLock unlock];
        //    }
}

#endif

@end
