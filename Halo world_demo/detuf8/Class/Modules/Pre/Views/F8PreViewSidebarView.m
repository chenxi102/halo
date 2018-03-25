//
//  F8PreViewSidebarView.m
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8PreViewSidebarView.h"
@interface F8PreViewSidebarView()

@property (nonatomic, strong) UIButton *firstBTN;
@property (nonatomic, strong) UIButton *twoBTN;
@property (nonatomic, strong) UIButton *threeBTN;

@end

@implementation F8PreViewSidebarView

- (void)dealloc{
    DeBugLog(@"F8PreViewSidebarView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup {
    @weak(self);
    _firstBTN = [UIButton new];
    [_firstBTN setImage:[UIImage imageNamed:@"曝光度"] forState:UIControlStateNormal];
    [self addSubview:_firstBTN];
    [_firstBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@25);
        make.top.equalTo(@150);
    }];
    
    [_firstBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self);
        if(self.action_First)self.action_First();
    }];
    
    _twoBTN = [UIButton new];
    [_twoBTN setImage:[UIImage imageNamed:@"画质参数"] forState:UIControlStateNormal];
    [self addSubview:_twoBTN];
    [_twoBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@25);
        make.top.equalTo(@210);
    }];
    
    [_twoBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self);
        if(self.action_Two)self.action_Two();
    }];
    
    _threeBTN = [UIButton new];
    [_threeBTN setImage:[UIImage imageNamed:@"更多"] forState:UIControlStateNormal];
    [self addSubview:_threeBTN];
    [_threeBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-13);
        make.centerX.equalTo(@0);
        make.width.height.equalTo(@25);
        make.top.equalTo(@270);
    }];
    
    [_threeBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self);
        if(self.action_Three)self.action_Three();
    }];
}
@end
