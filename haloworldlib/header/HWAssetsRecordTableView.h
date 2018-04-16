//
//  HWAssetsRecordTableView.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWModel.h"

@interface HWAssetsRecordTableView : UIView
@property (nonatomic, strong) NSMutableArray <HWRecordModel *>* datas_mut;
@property (nonatomic, strong) UILabel * noneDatatipLab;
@end
