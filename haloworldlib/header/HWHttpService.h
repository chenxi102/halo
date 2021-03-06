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
@property (nonatomic, copy) NSString * _Nullable host;
// 文案配置
// 用户id
@property (nonatomic, copy) NSString * _Nullable userid;

// 1.我的矿产
@property (nonatomic, copy) NSString * _Nullable selfOreTitle;              // 我的矿产title
@property (nonatomic, copy) NSString * _Nullable selfOre_userScoreStr;      // 我的算力title
@property (nonatomic, copy) NSString * _Nullable selfOre_userAssetsStr;     // 我的资产title
@property (nonatomic, copy) NSString * _Nullable selfOre_userAssetsRecordtr;// 收支明细title
@property (nonatomic, copy) NSString * _Nullable selfOre_methodStr;         // 攻略秘籍title

@property (nonatomic, copy) NSString * _Nullable selfOre_methodVCClassStr;  // 攻略秘籍类名
// 2.偷矿
@property (nonatomic, copy) NSString * _Nullable stealOreTitle;             // 偷矿界面title
@property (nonatomic, copy) NSString * _Nullable stealOre_userScoreStr;     // 我的算力title
@property (nonatomic, copy) NSString * _Nullable stealOre_userAssetsStr;    // 我的资产title
@property (nonatomic, copy) NSString * _Nullable stealOre_methodStr;        // 攻略秘籍title
// 2.挖矿
@property (nonatomic, copy) NSString * _Nullable luckOreTitle;              // 挖矿界面title
@property (nonatomic, copy) NSString * _Nullable reapOreTitle;              // 挖矿界面title
@property (nonatomic, copy) NSString * _Nullable reapOre_weburlStr;         // 摘星星 url
//@property (nonatomic, copy) NSString * _Nullable stealOre_userAssetsStr;    // 我的资产title
//@property (nonatomic, copy) NSString * _Nullable stealOre_assetsRecordStr;  // 资产明细title






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

// 2.7.   abstract: 查询用户资产
- (void)getUserAssetsWithCall:(HttpCallBcak)res ;

// 2.6.   abstract: 抽奖
/* prams :
          tokenType:  参与游戏时使用的币种   LET/ACT/KACSH/SSC
          costTokenNum: 游戏每次消费额
*/
- (void)getluckyBoxGetLuckWithTokenType:(NSString * _Nonnull)let costTokenNum:(NSString *_Nonnull)costN  Call:(HttpCallBcak)res;

@end
