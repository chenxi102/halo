//
//  F8CameraModeView.m
//  detuf8
//
//  Created by Seth on 2018/3/5.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8CameraModeView.h"

@implementation F8CameraModeButton

- (instancetype)initWithImage:(NSString *)imgStr selectImage:(NSString *)slcImgStr
{
    self = [super init];
    if (self) {
        [self setupWithImage:imgStr selectImage:slcImgStr];
        self.layer.masksToBounds = YES;
        self.layer.cornerRadius = 12.5;
        self.select = YES;
    } return self;
}

- (void)setupWithImage:(NSString *)imgStr selectImage:(NSString *)slcImgStr
{
    _centerBTN = [UIButton new];
    [_centerBTN setImage:[UIImage imageNamed:imgStr] forState:UIControlStateNormal];
    [_centerBTN setImage:[UIImage imageNamed:slcImgStr] forState:UIControlStateSelected];
    [self addSubview:_centerBTN];
    [_centerBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.center.equalTo(@0);
    }];
    @weak(self);
    [_centerBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
        @strong(self);
        [self sendActionsForControlEvents:UIControlEventTouchUpInside];
    }];
}

-(void)setSelect:(BOOL)select
{
    if (select) {
        _centerBTN.selected = YES;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:1];
    }else {
        _centerBTN.selected = NO;
        self.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0];
    }
}

@end









// MARK: F8CameraModeView
@implementation F8CameraModeView

- (void)dealloc{
    DeBugLog(@"F8CameraModeView dealloc");
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
    
    _photoBTN = [[F8CameraModeButton alloc]initWithImage:@"Camera" selectImage:@"Camera b"];
    [self addSubview:_photoBTN];
    [_photoBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(@2);
        make.bottom.equalTo(@-2);
        make.width.equalTo(@44);
    }];
    _photoBTN.tag = F8CameraType_photo;
    [_photoBTN addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _photoBTN.select = YES;
    
    
    _movieBTN = [[F8CameraModeButton alloc]initWithImage:@"Video" selectImage:@"Video b"];
    [self addSubview:_movieBTN];
    [_movieBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@2);
        make.bottom.equalTo(@-2);
        make.centerX.equalTo(@0);
        make.width.equalTo(@44);
    }];
    _movieBTN.tag = F8CameraType_video;
    [_movieBTN addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _movieBTN.select = NO;
    
    _livingBTN = [[F8CameraModeButton alloc]initWithImage:@"live" selectImage:@"live b"];
    [self addSubview:_livingBTN];
    [_livingBTN mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(@2);
        make.bottom.equalTo(@-2);
        make.right.equalTo(@-2);
        make.width.equalTo(@44);
    }];
    _livingBTN.tag = F8CameraType_live;
    [_livingBTN addTarget:self action:@selector(click:) forControlEvents:UIControlEventTouchUpInside];
    _livingBTN.select = NO;
}

- (void)setCameraType:(F8CameraType)cameraType {
    [UIView animateWithDuration:.2 animations:^{
        switch (cameraType) {
            case F8CameraType_photo:
                _photoBTN.select = YES;
                _movieBTN.select = NO;
                _livingBTN.select = NO;
                break;
            case F8CameraType_video:
                _photoBTN.select = NO;
                _movieBTN.select = YES;
                _livingBTN.select = NO;
                break;
            case F8CameraType_live:
                _photoBTN.select = NO;
                _movieBTN.select = NO;
                _livingBTN.select = YES;
                break;
            default:
                break;
        }
    }];
}

- (void)click:(UIButton *)sender {
    if (self.modeBlock) {
        self.modeBlock(sender.tag);
    }
}

@end
