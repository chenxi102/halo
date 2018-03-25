//
//  HWHttpService.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^_Nullable HttpCallBcak)(NSData *_Nullable, NSError *_Nullable);
@interface HWHttpService : NSObject

@property (nonatomic, copy) NSString * _Nullable userid;
@property (nonatomic, copy) NSString * _Nullable usertoken;

+ (instancetype _Nullable )shareInstance;

// 2.1.   abstract： 用户触发产矿
- (void)getUserSelfFieldOutputNum:(HttpCallBcak)res;
// 2.2.   abstract: 采矿   oreId: 矿产id
- (void)reapFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res;
// 2.3.   abstract： 获取偷矿资源
- (void)getOtherResourcesList:(HttpCallBcak)res;
// 2.4.   abstract： 偷取矿产 oreId: 矿产id
- (void)stealFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res;
// 2.5.   abstract： 抽奖
//- (void)getUserSelfFieldOutputNum:(void(^ _Nonnull)(NSData *))res;

@end
