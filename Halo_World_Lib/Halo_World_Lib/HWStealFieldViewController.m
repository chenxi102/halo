//
//  HWStealFieldViewController.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/24.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWStealFieldViewController.h"
#import "HWHttpService.h"
#import "HWUIHelper.h"
@interface HWStealFieldViewController ()

@end

@implementation HWStealFieldViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    // UI
    {
        
    }
    [[HWHttpService shareInstance] getUserSelfFieldOutputNum:^(NSData * _Nullable data, NSError * _Nullable err) {
        if (data) {
            
        }
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
