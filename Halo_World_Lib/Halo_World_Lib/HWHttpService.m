
//
//  HWHttpService.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWHttpService.h"
#import "HWHttpBase.h"

@interface HWHttpService()
@property (nonatomic, strong) HWHttpBase * httpOBJ;
@end

@implementation HWHttpService

+ (instancetype)shareInstance {
    static HWHttpService *httpService;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        httpService = [HWHttpService new];
        httpService.httpOBJ = [HWHttpBase new];
    });
    return httpService;
}


// 2.1.    用户触发产矿
- (void)getUserSelfFieldOutputNum:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,excavate];
    model.httpType = @"POST";
    model.params = [NSString stringWithFormat:@"userId=%@",self.userid];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}
// 2.2.    采矿
- (void)reapFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,reap];
    model.httpType = @"POST";
//    model.params = @{@"userId":self.userid, @"oreId":oreId};
    model.params = [NSString stringWithFormat:@"userId=%@&oreId=%@",self.userid, oreId];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}
// 2.3.    获取偷矿资源
- (void)getOtherResourcesList:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,otherResources];
    model.httpType = @"POST";
//    model.params = @{@"userId":self.userid};
    model.params = [NSString stringWithFormat:@"userId=%@",self.userid];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}
// 2.4.    偷取矿产
- (void)stealFieldWithOreId:(NSString* _Nullable)oreId Call:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,steal];
    model.httpType = @"POST";
//    model.params = @{@"userId":self.userid, @"oreId":oreId};
    model.params = [NSString stringWithFormat:@"userId=%@&oreId=%@",self.userid, oreId];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}
// 2.5.   abstract: 查询用户收入明细
/* prams :
 tokenType: 如果查询某个明确的币种的明细不能为空 tokenType=’LET’ 如果查询全部 为空或空串
 costTokenNum: 游戏每次消费额
 */

- (void)getUserDetailWithTokenType:(NSString * _Nonnull)let Call:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,record];
    model.httpType = @"POST";
    //    model.params = @{@"userId":self.userid, @"oreId":oreId};
    model.params = [NSString stringWithFormat:@"userId=%@&tokenType=%@",self.userid, let];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}

// 2.6.   abstract: 抽奖
/* prams :
 tokenType:  参与游戏时使用的币种   LET/ACT/KACSH/SSC
 costTokenNum: 游戏每次消费额
 */
- (void)getluckyBoxGetLuckWithTokenType:(NSString * _Nonnull)let costTokenNum:(NSString *_Nonnull)costN  Call:(HttpCallBcak)res {
    HWHttpModel * model = [HWHttpModel new];
    model.url = [NSString stringWithFormat:@"%@%@",HOST,steal];
    model.httpType = @"POST";
    //    model.params = @{@"userId":self.userid, @"oreId":oreId};
    model.params = [NSString stringWithFormat:@"userId=%@&tokenType=%@&costTokenNum=%@",self.userid, let, costN];
    [self.httpOBJ sendDataWithHttpModel:model result:^(NSData * _Nullable data, NSURLResponse * _Nullable rep, NSError * _Nullable err) {
        if (res) {
            res(data, err);
        }
    }];
}

@end
