//
//  HWModel.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/26.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
@class oreListModel;

typedef NS_ENUM(NSInteger, OreCellType) {
    OreCellType_reapSelf ,          // 自己的矿
    OreCellType_stealOthers         // 他人的矿
};
// 总的矿产模型
@interface HWModel : NSObject
@property (nonatomic,assign) double score; // 用户算力
@property (nonatomic,strong) NSMutableArray <oreListModel *>*ownOreList;        // 我的矿产 / 不能偷的矿
//@property (nonatomic,strong) NSMutableArray <oreListModel *>*stealoreList;      // 可以被偷的矿

@end


// 单个矿产模型
@interface oreListModel : NSObject
@property (nonatomic,assign) OreCellType oreCellType;   // 来自哪里的数据 ： 1.自己的矿 2.他人的矿
@property (nonatomic,copy) NSString *createTime;        // 创建时间
@property (nonatomic,assign) double oreAmount;          // 数量
@property (nonatomic,copy) NSString *oreId;             // 矿产ID
@property (nonatomic,copy) NSString *oreType;           // 类型: 根据不同类型展示不同图样
@property (nonatomic,copy) NSString *status;            // 状态: 0 未收 ,1已收
@property (nonatomic,copy) NSString *supportHandle;     // 支持操作: 1.仅自取 2.支持其他用户偷
@property (nonatomic,copy) NSString *userId;

@end

//  明细模型
@interface HWRecordModel : NSObject

@property (nonatomic,copy) NSString *recordId;          // 记录编号
@property (nonatomic,assign) double tokenNumber;        // 数量
@property (nonatomic,copy) NSString *createTime;        // 创建时间
@property (nonatomic,copy) NSString *tokenType;         // 币种: LET KCASH ACT
@property (nonatomic,copy) NSString *tokenId;           // tokenId   用户资产用到
@property (nonatomic,copy) NSString *operationType;     // 操作: 0 支出 1收入
@property (nonatomic,copy) NSString *userId;


@end
