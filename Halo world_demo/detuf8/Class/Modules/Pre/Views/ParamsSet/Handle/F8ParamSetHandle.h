//
//  F8ParamSetHandle.h
//  detuf8
//
//  Created by Seth on 2018/3/14.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface F8ParamSetHandle : NSObject

+ (void)setParamCommandType:(ParamCommandType)type value:(float)value Res:(void(^)(int))res ;

+ (void)restParamWithType:(F8ParamSetViewType)type  Res:(void(^)(int))res ;

@end
