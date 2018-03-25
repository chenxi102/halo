//
//  F8ParamMode.m
//  detuf8
//
//  Created by Seth on 2018/3/7.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamMode.h"

@implementation F8ParamSubMode @end

@implementation F8ParamMode
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.pramas = [NSMutableArray array];
    }
    return self;
}
@end
