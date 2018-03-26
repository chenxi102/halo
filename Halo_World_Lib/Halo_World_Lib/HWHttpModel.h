//
//  HWHttpModel.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <Foundation/Foundation.h>

extern NSString * const  HOST ;             //      url
extern NSString * const  excavate ;         //2.1.    用户触发产矿
extern NSString * const  reap ;             //2.2.    采矿
extern NSString * const  otherResources ;   //2.3.    获取偷矿资源
extern NSString * const  steal ;            //2.4.    偷取矿产
//extern NSString * const  excavate ;






@interface HWHttpModel : NSObject

// url
@property (nonatomic,copy) NSString *url;

// GET or POST
@property (nonatomic,copy) NSString *httpType;

// params 
@property (nonatomic,copy) NSString *params;

@end
