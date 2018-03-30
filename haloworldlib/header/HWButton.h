//
//  HWButton.h
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/28.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HWButton : UIButton
- (void)popOutsideWithDuration:(NSTimeInterval)duration;
- (void)popInsideWithDuration:(NSTimeInterval)duration;
@end
