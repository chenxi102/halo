//
//  UIViewController+Ex.m
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import "UIViewController+Ex.h"

@implementation UIViewController (Ex)

//- (CALayer *)layer {
//    return self.view.layer;
//}

- (void)showAlertWithTitle:(NSString *)t messge:(NSString *)m ok_actionTitle:(NSString *)at cancel_actionTitle:(NSString *)ct ok_actionBlock:(void(^)(void))aRes cancel_actionBlock:(void(^)(void))cRes
{
    UIAlertController *alertControl = [UIAlertController alertControllerWithTitle:L(@"t") message:L(@"m") preferredStyle:UIAlertControllerStyleAlert];
    [alertControl addAction:[UIAlertAction actionWithTitle:L(@"at") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(aRes) aRes();
    }]];
    
    [alertControl addAction:[UIAlertAction actionWithTitle:L(@"ct") style:UIAlertActionStyleDefault handler:^(UIAlertAction *action) {
        if(cRes) cRes();
    }]];
    
    [self presentViewController:alertControl animated:YES completion:nil];
}

@end
