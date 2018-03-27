
//
//  HWOreImageView.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/27.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWOreImageView.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"


@interface HWOreImageView ()
@property (nonatomic, strong) UIButton * OreImageView;
@property (nonatomic, strong) UILabel * OreNumLab;

@property (nonatomic, copy) void(^oreClickBlock)(oreListModel *);
@end

@implementation HWOreImageView

- (instancetype)initWithClickBLock:(void(^)(oreListModel *))res
{
    self = [super init];
    if (self) {
        _oreClickBlock = res;
        [self setup];
    }
    return self;
}

- (void)setup {
    _OreImageView = [UIButton new];
    [_OreImageView setImage:[HWUIHelper imageWithCameradispatchName:@"矿石"] forState:(UIControlStateNormal)];
    [self addSubview:_OreImageView];
    [_OreImageView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.top.centerX.equalTo(@0);
        make.size.HWMAS_equalTo((CGSize){42.5, 42.5});
    }];
    [_OreImageView addTarget:self action:@selector(oreClcick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _OreNumLab = [UILabel new];
    _OreNumLab.font = [UIFont systemFontOfSize:11];
    _OreNumLab.textColor = [UIColor whiteColor];
    _OreNumLab.textAlignment = NSTextAlignmentCenter;
    _OreNumLab.text = @"2";
    [self addSubview:_OreNumLab];
    [_OreNumLab HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.centerX.equalTo(@0);
        make.height.equalTo(@15);
    }];
}


- (void)setIsShake:(BOOL)isShake
{
    _isShake = isShake;
    @HWweak(self);
    if (isShake) {
        int base = arc4random()%5+1;
        float random = 1./base;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(random * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [UIView animateWithDuration:.7 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                @HWstrong(self);
                self.transform = CGAffineTransformTranslate(self.transform, 0, -10);
            } completion:^(BOOL finished) {
                @HWweak(self);
                if (!_isShake) {
                    [self.layer removeAllAnimations];
                    self.transform = CGAffineTransformIdentity;
                }
                [UIView animateWithDuration:0.5 delay:0 options:UIViewAnimationOptionCurveEaseInOut|UIViewAnimationOptionAllowUserInteraction animations:^{
                    @HWstrong(self);
                    self.transform = CGAffineTransformIdentity;
                } completion:^(BOOL finished) {
                    @HWstrong(self);
                    [self setIsShake:_isShake];
                }];
            }];
        });
    } else {
        [self.layer removeAllAnimations];
    }
}

- (void)oreClcick:(UIButton *)sender {
    @HWweak(self);
    if (_oreClickBlock) {
        _oreClickBlock(weakClass.model);
    }
    self.isShake = NO;
}

- (void)setModel:(oreListModel *)model
{
    if ([model.status isEqualToString:@"0"]) {
        [self setIsShake:YES];
    }else {
        [self setIsShake:NO];
    }
    self.OreNumLab.text = [NSString stringWithFormat:@"%.1f",model.oreAmount];
}

@end
