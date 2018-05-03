//
//  UIView+Snapt.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/4/19.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "UIView+Snapt.h"

@implementation UIView (Snapt)

- (UIImage *)snapshotImage {
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, self.opaque, 0);
    [self.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *snap = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return snap;
}

@end
