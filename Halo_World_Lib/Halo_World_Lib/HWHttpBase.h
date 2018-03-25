//
//  HWHttpBase.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HWHttpModel.h"

@interface HWHttpBase : NSObject

/**
 Basic methods of HTTP communication
 */
- (void)sendDataWithHttpModel:(nonnull HWHttpModel *)httpModel result:(void(^_Nullable)(NSData* _Nullable, NSURLResponse* _Nullable, NSError* _Nullable))res;

@end
