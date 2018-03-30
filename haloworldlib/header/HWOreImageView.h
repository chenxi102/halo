//
//  HWOreImageView.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWModel.h"

@interface HWOreImageView : UIView
@property (nonatomic, strong) oreListModel * model;
@property (nonatomic, assign) BOOL isShake;

- (instancetype)initWithClickBLock:(void(^)(HWOreImageView *, oreListModel *))res;
- (void)setOreNum:(float)num ;
@end
