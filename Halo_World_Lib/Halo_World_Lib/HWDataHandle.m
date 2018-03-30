
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
            for (int i = 0 ; i< oerlsit.count; i++) {
                oreListModel *  oreM = [oreListModel new];
                oreM.oreCellType = OreCellType_reapSelf;
                oreM.oreId = oerlsit[i][@"oreId"];
                oreM.createTime = oerlsit[i][@"createTime"];
                oreM.oreType = oerlsit[i][@"oreType"];
                oreM.status = oerlsit[i][@"status"];
                oreM.supportHandle = oerlsit[i][@"supportHandle"];
                oreM.userId = oerlsit[i][@"userId"];
                oreM.oreAmount = ((NSNumber *)oerlsit[i][@"oreAmount"]).doubleValue;
                
                [totalM.ownOreList addObject:oreM];
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
            NSArray * stealList =  _data[@"stealList"];
            NSArray * ownlList =  _data[@"ownlList"];
            
            HWModel * orelistM = [HWModel new];
            orelistM.score = ((NSNumber *)_data[@"score"]).doubleValue;
            
            if (stealList.count > 0) {
                oreListModel *  oreM = [oreListModel new];
                oreM.oreCellType = OreCellType_stealOthers;
                oreM.createTime = stealList[0][@"createTime"];
                oreM.oreType = stealList[0][@"oreType"];
                oreM.status = stealList[0][@"status"];
                oreM.supportHandle = @"2";
                oreM.userId = stealList[0][@"userId"];
                for (int i = 0 ; i< stealList.count; i++) {
                    oreM.oreId = [NSString stringWithFormat:@"%@,%@",oreM.oreId, stealList[i][@"oreId"]];
                    oreM.oreAmount += ((NSNumber *)stealList[i][@"oreAmount"]).doubleValue;
                    
                }
                [orelistM.ownOreList addObject:oreM];
            }
           
            
            for (int i = 0 ; i< ownlList.count; i++) {
                oreListModel *  oreM = [oreListModel new];
                oreM.oreCellType = OreCellType_stealOthers;
                oreM.oreId = ownlList[i][@"oreId"];
                oreM.createTime = ownlList[i][@"createTime"];
                oreM.oreType = ownlList[i][@"oreType"];
                oreM.status = ownlList[i][@"status"];
                oreM.supportHandle = ownlList[i][@"supportHandle"];
                oreM.userId = ownlList[i][@"userId"];
                oreM.oreAmount = ((NSNumber *)ownlList[i][@"oreAmount"]).doubleValue;
                [orelistM.ownOreList addObject:oreM];
            }
            
            if (res) {
                res(YES, orelistM);
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
