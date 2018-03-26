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
    [self extracted] ;
    
    return;
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(2 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [[HWHttpService shareInstance] stealFieldWithOreId:@"" Call:^(NSData * _Nullable d, NSError * _Nullable e) {
            if (d) {
                
            }
        }];
    });
}




@end
