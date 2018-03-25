//
//  F8ParamSetView.h
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>




@interface F8ParamSetView : UIButton

@property (nonatomic, copy) void(^clickStartBlock)(ParamCommandType, float);   // 传递点击处理结果 到VC层
@property (nonatomic, copy) void(^resultBlock)(ParamCommandType, int);
// 传递命令处理结果 到VC层
- (instancetype)initWithParamSetViewType:(F8ParamSetViewType)paramSetViewType
                                     res:(void(^)(ParamCommandType, int))resultBlock
                         clickStartBlock:(void(^)(ParamCommandType, float))clickStartBlock;

@end
