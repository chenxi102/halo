//
//  HWBaseViewController.h
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HWUIHelper.h"


@interface HWBaseViewController : UIViewController

@property (nonatomic, copy) NSString * title;

- (void)safeBack ;
@end
