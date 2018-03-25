

//
//  F8PreViewNavView.m
//  detuf8
//
//  Created by Seth on 2018/3/1.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8PreViewNavView.h"

@interface F8PreViewNavView()
@property (nonatomic, strong) UIButton *backBTN;
@property (nonatomic, strong) UILabel *batteryLAB;
@property (nonatomic, strong) UIImageView *batteryIMGV;
@property (nonatomic, strong) UILabel *freeLAB;
@property (nonatomic, strong) UIImageView *freeIMGV;
@property (nonatomic, strong) UILabel *modeLAB;
@property (nonatomic, strong) UIImageView *modeIMGV;


@property (nonatomic, strong) UIView *backView;
@property (nonatomic, strong) CAGradientLayer *cLayer;

@end

@implementation F8PreViewNavView
- (void)dealloc{
    DeBugLog(@"F8PreViewNavView dealloc");
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
    }
    return self;
}
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void)setup {
    @weak(self);
    _backView = [UIView new];
    [self addSubview:_backView];
    [_backView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    _backBTN = [UIButton new];
    [_backBTN setImage:[UIImage imageNamed:@"Arrow Left b"] forState:UIControlStateNormal];
    [self addSubview:_backBTN];
    [_backBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.centerY.equalTo(@0);
        make.width.height.equalTo(@30);
    }];
    
    [_backBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self);
        if(self.backAction)self.backAction();
    }];
    
    _batteryIMGV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"满电"]];
    [self addSubview:_batteryIMGV];
    [_batteryIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@90);
        make.centerY.equalTo(@0);
    }];
    
    _batteryLAB = [[UILabel alloc] init];
    [self addSubview:_batteryLAB];
    _batteryLAB.text = @"50%";
    _batteryLAB.textColor = [UIColor whiteColor];
    _batteryLAB.font = [UIFont systemFontOfSize:13];
    [self.batteryLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(self.batteryIMGV.mas_right).offset(6);
    }];
    
    _freeIMGV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"sdcard_normal"]];
    [self addSubview:_freeIMGV];
    [_freeIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@170);
        make.centerY.equalTo(@0);
    }];
    
    _freeLAB = [[UILabel alloc] init];
    [self addSubview:_freeLAB];
    _freeLAB.text = @"150G";
    _freeLAB.textColor = [UIColor whiteColor];
    _freeLAB.font = [UIFont systemFontOfSize:13];
    [_freeLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(self.freeIMGV.mas_right).offset(6);
    }];
    
    _modeIMGV = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"360-2D"]];
    [self addSubview:_modeIMGV];
    [_modeIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@260);
        make.centerY.equalTo(@0);
    }];
    
    _modeLAB = [[UILabel alloc] init];
    [self addSubview:_modeLAB];
    if ([F8SocketAPI shareInstance].cameraInfo.contendMode == 0) {
        _modeLAB.text = @"2D";
    } else {
        _modeLAB.text = @"3D";
    }
    _modeLAB.textColor = [UIColor whiteColor];
    _modeLAB.font = [UIFont systemFontOfSize:13];
    [_modeLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        @strong(self);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.left.equalTo(self.modeIMGV.mas_right).offset(6);
    }];
}

- (void)layoutSubviews {
    if (!_cLayer) {
        _cLayer = [CAGradientLayer layer];
        _cLayer.frame = self.bounds;
        _cLayer.startPoint = CGPointMake(0, 0);
        _cLayer.endPoint = CGPointMake(0, 1);
        _cLayer.colors = @[(id)RGB_A(0, 0, 0, 0).CGColor, (id)RGB_A(0, 0, 0, 0.3).CGColor];
        [_backView.layer addSublayer:_cLayer];
    }
}

- (void)refreshStates
{
    
    if ([F8SocketAPI shareInstance].cameraInfo.contendMode == 0) {
        _modeLAB.text = @"2D";
    } else {
        _modeLAB.text = @"3D";
    }
}

@end
