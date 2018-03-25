//
//  F8PreViewSidebarView.h
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface F8PreViewSidebarView : UIView

@property (nonatomic, copy) void (^action_First)(void);
@property (nonatomic, copy) void (^action_Two)(void);
@property (nonatomic, copy) void (^action_Three)(void);

- (instancetype)init;

@end
