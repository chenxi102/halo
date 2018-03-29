
//
//  HWDataHandle.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/26.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWDataHandle.h"
#import "HWHttpService.h"

@implementation HWDataHandle

+ (void)loadUserSelfFieldOutputNum:(void(^)(BOOL, HWModel*))res {
    [[HWHttpService shareInstance] getUserSelfFieldOutputNum:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSString * ret = json[@"retCode"];
        NSDictionary * _data = (NSDictionary *)json[@"data"];
        if (ret.intValue == 0) {
            NSArray * oerlsit =  _data[@"oreList"];
            HWModel * totalM = [HWModel new];
            totalM.score = ((NSNumber *)_data[@"score"]).doubleValue;
            for (int i = 0 ; i< 30/*oerlsit.count*/; i++) {
                oreListModel *  oreM = [oreListModel new];
                oreM.oreCellType = OreCellType_reapSelf;
                oreM.oreId = oerlsit[0][@"oreId"];
                oreM.createTime = oerlsit[0][@"createTime"];
                oreM.oreType = oerlsit[0][@"oreType"];
                oreM.status = oerlsit[0][@"status"];
                oreM.supportHandle = oerlsit[0][@"supportHandle"];
                oreM.userId = oerlsit[0][@"userId"];
                oreM.oreAmount = ((NSNumber *)oerlsit[0][@"oreAmount"]).doubleValue;
                
                [totalM.oreList addObject:oreM];
            }
            
            if (res) {
                res(YES, totalM);
            }
        } else {
            if (res) {
                res(NO, nil);
            }
        }
    }];
}

+ (void)reapOre:(oreListModel *)ore res:(void(^)(BOOL, NSString*))res {
    [[HWHttpService shareInstance]reapFieldWithOreId:ore.oreId Call:^(NSData * _Nullable d, NSError * _Nullable e) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:d options:(NSJSONReadingMutableContainers) error:nil];
        NSString * ret = json[@"retCode"];
        NSString * retMsg = json[@"retMsg"];
        NSDictionary * _data = (NSDictionary *)json[@"data"];
        if (ret.intValue == 0) {
            
            if (res) {
                res(YES, nil);
            }
        } else {
            if (res) {
                res(NO, retMsg);
            }
        }
    }];
}

+ (void)loadOthersResource:(void(^)(BOOL, HWModel*))res {
    [[HWHttpService shareInstance] getOtherResourcesList:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        NSString * ret = json[@"retCode"];
        NSDictionary * _data = (NSDictionary *)json[@"data"];
        if (ret.intValue == 0) {
            NSArray * oerlsit =  _data[@"oreList"];
            HWModel * totalM = [HWModel new];
            totalM.score = ((NSNumber *)_data[@"score"]).doubleValue;
            for (int i = 0 ; i< oerlsit.count; i++) {
                oreListModel *  oreM = [oreListModel new];
                oreM.oreCellType = OreCellType_stealOthers;
                oreM.oreId = oerlsit[i][@"oreId"];
                oreM.createTime = oerlsit[i][@"createTime"];
                oreM.oreType = oerlsit[i][@"oreType"];
                oreM.status = oerlsit[i][@"status"];
                oreM.supportHandle = oerlsit[i][@"supportHandle"];
                oreM.userId = oerlsit[i][@"userId"];
                oreM.oreAmount = ((NSNumber *)oerlsit[i][@"oreAmount"]).doubleValue;
                
                [totalM.oreList addObject:oreM];
            }
            
            if (res) {
                res(YES, totalM);
            }
        } else {
            if (res) {
                res(NO, nil);
            }
        }
    }];
}

+ (void)stealOre:(oreListModel *)ore res:(void(^)(BOOL, NSString*))res {
    [[HWHttpService shareInstance]stealFieldWithOreId:ore.oreId Call:^(NSData * _Nullable d, NSError * _Nullable e) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:d options:(NSJSONReadingMutableContainers) error:nil];
        NSString * ret = json[@"retCode"];
        NSString * retMsg = json[@"retMsg"];
        NSDictionary * _data = (NSDictionary *)json[@"data"];
        if (ret.intValue == 0) {
            
            if (res) {
                res(YES, nil);
            }
        } else {
            if (res) {
                res(NO, retMsg);
            }
        }
    }];
}

@end
