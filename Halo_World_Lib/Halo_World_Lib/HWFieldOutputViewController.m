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

- (void)extracted {
    [[HWHttpService shareInstance] getUserSelfFieldOutputNum:^(NSData * _Nullable data, NSError * _Nullable err) {
        NSDictionary * json = [NSJSONSerialization JSONObjectWithData:data options:(NSJSONReadingMutableContainers) error:nil];
        if (json) {
            
        }
    }];
}



- (void)viewDidLoad {
    [super viewDidLoad];
    [self extracted] ;
    [self setUp];
}

- (void)setUp {
    
}

- (void)safeBack{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
