//
//  F8PreViewNavView.h
//  detuf8
//
//  Created by Seth on 2018/3/1.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F8PreViewNavView : UIView

@property (nonatomic, copy) void (^backAction)();
- (instancetype)init;
- (void)refreshStates;
@end
