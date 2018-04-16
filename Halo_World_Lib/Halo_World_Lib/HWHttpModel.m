
//
//  HWHttpModel.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/25.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWHttpModel.h"

//NSString * const  HOST = @"http://118.26.132.162:8011";                   //@"http://wttianxubo.imwork.net:10380";      url
NSString * const  excavate = @"/ore/excavate";               //2.1.    用户触发产矿
NSString * const  reap  = @"/ore/reap";                      //2.2.    采矿
NSString * const  otherResources = @"/ore/otherResources";   //2.3.    获取偷矿资源
NSString * const  steal = @"/ore/steal";                     //2.4.    偷取矿产
NSString * const  record = @"/token/record";                 //2.5.    查询用户收入明细
NSString * const  detail = @"/token/detail";                 //2.7.    查询用户资产
NSString * const  getLuck = @"/luckyBox/getLuck";            //2.6.    抽奖


@implementation HWHttpModel

@end
