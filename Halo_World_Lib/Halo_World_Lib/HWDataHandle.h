//
//  HWDataHandle.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/26.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWModel.h"

@interface HWDataHandle : NSObject

+ (void)loadUserSelfFieldOutputNum:(void(^)(BOOL, HWModel*))res;
+ (void)reapOre:(oreListModel *)ore res:(void(^)(BOOL, NSString*))res;
+ (void)loadOthersResource:(void(^)(BOOL, HWModel*))res;
+ (void)stealOre:(oreListModel *)ore res:(void(^)(BOOL, NSString*))res;

@end
