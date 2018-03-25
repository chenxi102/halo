//
//  UIViewController+Ex.h
//  IntelligentPacket
//
//  Created by Seth Chen on 16/6/26.
//  Copyright © 2016年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Ex)

//@property (nonatomic, strong) CALayer * layer;


- (void)showAlertWithTitle:(NSString *)t messge:(NSString *)m ok_actionTitle:(NSString *)at cancel_actionTitle:(NSString *)ct ok_actionBlock:(void(^)(void))aRes cancel_actionBlock:(void(^)(void))cRes;

@end
