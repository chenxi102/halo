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

// 2.1.   abstract: 用户触发产矿
- (void)getUserSelfFieldOutputNum:(HttpCallBcak)res;
// 2.2.   abstract: 采矿   oreId: 矿产id
- (void)reapFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res;
// 2.3.   abstract: 获取偷矿资源
- (void)getOtherResourcesList:(HttpCallBcak)res;
// 2.4.   abstract: 偷取矿产 oreId: 矿产id
- (void)stealFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res;
// 2.5.   abstract: 查询用户收入明细
/* prams :
          tokenType 如果查询某个明确的币种的明细不能为空 tokenType=’LET’ 如果查询全部 为空或空串
          costTokenNum: 游戏每次消费额
*/
- (void)getUserDetailWithTokenType:(NSString * _Nonnull)let Call:(HttpCallBcak)res;
// 2.6.   abstract: 抽奖
/* prams :
          tokenType:  参与游戏时使用的币种   LET/ACT/KACSH/SSC
          costTokenNum: 游戏每次消费额
*/
- (void)getluckyBoxGetLuckWithTokenType:(NSString * _Nonnull)let costTokenNum:(NSString *_Nonnull)costN  Call:(HttpCallBcak)res;

@end
