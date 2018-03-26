//
//  HWFieldOutputViewController.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/24.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWFieldOutputViewController.h"
#import "HWHttpService.h"
@interface HWFieldOutputViewController ()

@end

@implementation HWFieldOutputViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[HWHttpService shareInstance] getUserSelfFieldOutputNum:^(NSData * _Nullable data, NSError * _Nullable err) {
        if (data) {
            
        }
    }];
}




@end
