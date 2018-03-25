//
//  F8ParamSetTabCell.h
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "F8ParamMode.h"



@class F8Slider;

@interface F8ParamSetTabCell : UITableViewCell

@property (nonatomic, strong) UIView * topLine;
@property (nonatomic, strong) UIView * botLine;
@property (nonatomic, assign) F8ParamSetViewType paramSetViewType;


- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
             ParamSetViewType:(F8ParamSetViewType)paramSetViewType
                        items:(F8ParamMode *)items
                     curIndex:(NSInteger)curIndex
                     callBack:(void(^)(ParamCommandType, CGFloat))callback;
@end





@interface F8Slider : UISlider

@property (nonatomic, assign) BOOL isSlidering;
@end
