//
//  HWAssetsDetailTableView.h
//  Halo_World_Lib
//
//  Created by Seth on 2018/4/16.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWModel.h"

@interface HWAssetsDetailTableView : UIView
@property (nonatomic, strong) NSMutableArray <HWRecordModel *>* datas_mut;
@property (nonatomic, strong) UILabel * noneDatatipLab;
@end
