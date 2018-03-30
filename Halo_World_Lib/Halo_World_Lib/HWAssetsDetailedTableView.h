//
//  HWAssetsDetailedTableView.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWModel.h"

@interface HWAssetsDetailedTableView : UIView
@property (nonatomic, strong) UILabel * noneDatatipLab;
@property (nonatomic, strong) UIButton * backBTN;
@property (nonatomic, strong) NSMutableArray <HWRecordModel *>* datas_mut;
@end
