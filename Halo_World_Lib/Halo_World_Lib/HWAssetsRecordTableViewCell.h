//
//  HWAssetsRecordTableViewCell.h
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWModel.h"

@interface HWAssetsRecordTableViewCell : UITableViewCell

@property (nonatomic, strong) UIImageView * topLine;
@property (nonatomic, strong) UIImageView * botLine;
@property (nonatomic, strong) HWRecordModel * item;


@end
