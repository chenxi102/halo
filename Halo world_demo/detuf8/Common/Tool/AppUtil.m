
//
//  AppUtil.m
//  detuf8
//
//  Created by Seth on 2018/2/28.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "AppUtil.h"
#import <sys/types.h>
#import <sys/sysctl.h>
#import <mach/host_info.h>
#import <mach/mach_host.h>
#import <mach/task_info.h>
#import <mach/task.h>

@implementation AppUtil

+ (void)openApplication_SetView ; {
    
    NSURL *openUrl = [NSURL URLWithString:@"App-Prefs:root=WIFI"];
    if (@available(iOS 10.0, *)) {

        if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
            [[UIApplication sharedApplication] openURL:openUrl options:@{} completionHandler:^(BOOL success) {
                NSLog(@"%d",success);
            }];
        }else
        {
            NSLog(@"ios 10  打开wifi界面 error");
        }
    }else
    {
        if ([[UIApplication sharedApplication] canOpenURL:openUrl]) {
            [[UIApplication sharedApplication]openURL:openUrl];
        }else
        {
            NSLog(@"ios 10 以下 打开wifi界面 error");
        }
    }
}

+ (CGFloat)convertUnitWidthStand:(CGFloat)unit{
    CGFloat standarUnit = 375.;
    CGFloat standarUnitScale = [UIScreen mainScreen].bounds.size.width/standarUnit;
    return standarUnitScale*unit;
}

+ (CGFloat)convertUnitHeigthStand:(CGFloat)unit{
    CGFloat standarUnit = 667.;
    CGFloat standarUnitScale = [UIScreen mainScreen].bounds.size.height/standarUnit;
    return standarUnitScale*unit;
}


+ (int) YYDeviceMemoryFree {
    
    mach_port_t host_port = mach_host_self();
    
    mach_msg_type_number_t host_size = sizeof(vm_statistics_data_t) / sizeof(integer_t);
    
    vm_size_t page_size;
    
    vm_statistics_data_t vm_stat;
    
    kern_return_t kern;
    
    kern = host_page_size(host_port, &page_size);
    
    if (kern != KERN_SUCCESS) return -1;
    
    kern = host_statistics(host_port, HOST_VM_INFO, (host_info_t)&vm_stat, &host_size);
    
    if (kern != KERN_SUCCESS) return -1;
    
    return vm_stat.free_count * page_size;
}






@end
