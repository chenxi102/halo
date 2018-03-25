//
//  F8ParamMode.h
//  detuf8
//
//  Created by Seth on 2018/3/7.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "F8ParamTools.h"

@class F8ParamSubMode;

@interface F8ParamMode : NSObject

@property (nonatomic, strong) NSMutableArray<F8ParamSubMode*> * pramas;
@property (nonatomic, assign) ParamCommandType pramaType;
@property (nonatomic, assign) CGFloat pramaIndex;

@end


@interface F8ParamSubMode : NSObject

@property (nonatomic, copy) NSString * pramaTitle;
@property (nonatomic, assign)CGFloat pramaValue;

@end
