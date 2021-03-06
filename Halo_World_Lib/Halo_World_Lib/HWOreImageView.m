
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
@property (nonatomic, copy) void(^oreClickBlock)(HWOreImageView*, oreListModel *);

@property (nonatomic, strong) UILabel * stealOreNumLab;


@property (strong, nonatomic) UIImage *particleImage;
@property (assign, nonatomic) CGFloat particleScale;
@property (assign, nonatomic) CGFloat particleScaleRange;

@property (strong, nonatomic) NSArray *emitterCells;
@property (strong, nonatomic) CAEmitterLayer *chargeLayer;
@property (strong, nonatomic) CAEmitterLayer *explosionLayer;
@end

@implementation HWOreImageView

- (instancetype)initWithClickBLock:(void(^)(HWOreImageView *,oreListModel *))res
{
    self = [super init];
    if (self) {
        _oreClickBlock = res;
        [self setup];
        [self setupAnimation];
        self.particleImage = [HWUIHelper imageWithCameradispatchName:@"矿石"];
        self.particleScale = 0.05;
        self.particleScaleRange = 0.02;
    }
    return self;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
//        [self setupAnimation];
        self.particleImage = [HWUIHelper imageWithCameradispatchName:@"矿石"];
        self.particleScale = 0.05;
        self.particleScaleRange = 0.02;
        _OreNumLab.textColor = HWRGB(0, 253, 253);
        [self setIsShake:YES];
    }
    return self;
}

- (void)setup {
    _OreImageView = [UIButton new];
    [_OreImageView setImage:[HWUIHelper imageWithCameradispatchName:@"原力觉醒中icon"] forState:(UIControlStateNormal)];
    [self addSubview:_OreImageView];
    [_OreImageView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.top.centerX.equalTo(@0);
        make.size.HWMAS_equalTo((CGSize){35, 35});
    }];
    [_OreImageView addTarget:self action:@selector(oreClcick:) forControlEvents:(UIControlEventTouchUpInside)];
    
    _OreNumLab = [UILabel new];
    _OreNumLab.font = [UIFont systemFontOfSize:11];
    _OreNumLab.textColor = [UIColor whiteColor];
    _OreNumLab.textAlignment = NSTextAlignmentCenter;
    _OreNumLab.text = @"原力觉醒中···";
    [self addSubview:_OreNumLab];
    [_OreNumLab HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.bottom.equalTo(@0);
        make.centerX.equalTo(@0);
        make.height.equalTo(@23);
    }];
    
//    _stealOreNumLab = [UILabel new];
//    _stealOreNumLab.font = [UIFont systemFontOfSize:10];
//    _stealOreNumLab.textColor = [UIColor redColor];
//    _stealOreNumLab.backgroundColor = [[UIColor whiteColor] colorWithAlphaComponent:0.3];
//    _stealOreNumLab.textAlignment = NSTextAlignmentCenter;
//    _stealOreNumLab.clipsToBounds = YES;
//    _stealOreNumLab.layer.cornerRadius = 10;
//    _stealOreNumLab.text = @"40";
//    [self addSubview:_stealOreNumLab];
//    [_stealOreNumLab HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        make.top.equalTo(@0);
//        make.right.equalTo(@10);
//        make.height.width.equalTo(@20);
//    }];
    
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
                self.transform = CGAffineTransformTranslate(self.transform, 0, -5);
            } completion:^(BOOL finished) {
                @HWstrong(self);
                if (!_isShake) {
                    [self.layer removeAllAnimations];
                    self.transform = CGAffineTransformIdentity;
                }
                @HWweak(self);
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
    {
        @HWstrong(self);
        if (_oreClickBlock) {
            _oreClickBlock(self,self.model);
        }
        [self animate];
    }
}

- (void)setOreNum:(float)num {
    self.OreNumLab.text = [NSString stringWithFormat:@"%.5f",num];
}

- (void)setModel:(oreListModel *)model
{
    _model = model;
    if (model.oreCellType == OreCellType_reapSelf) {
        if ([model.status isEqualToString:@"0"]) {
            [self setIsShake:YES];
        }else {
            [self setIsShake:NO];
        }
        self.particleImage = [HWUIHelper imageWithCameradispatchName:@"矿石"];
        [_OreImageView setImage:[HWUIHelper imageWithCameradispatchName:@"矿石"] forState:(UIControlStateNormal)];
        
    } else {
        
        self.particleImage = [HWUIHelper imageWithCameradispatchName:@"小眼睛"];
        [_OreImageView setImage:[HWUIHelper imageWithCameradispatchName:@"小眼睛"] forState:(UIControlStateNormal)];
        
        // 偷取他人的矿  supportHandle :1.自取 2.支持可偷
        // status :0 未收 1 已收
        if ([model.supportHandle isEqualToString:@"2"]&&[model.status isEqualToString:@"0"]) {
            [self setIsShake:YES];
            self.OreImageView.enabled = YES;
            self.OreNumLab.textColor = [UIColor whiteColor];
        }else {
            [self setIsShake:NO];
            self.OreImageView.enabled = NO;
            self.OreNumLab.textColor = [UIColor lightGrayColor];
        }
    }
   
    self.OreNumLab.text = [NSString stringWithFormat:@"%.5f",model.oreAmount];
    int base = arc4random()%5+1;
    float random = 1.*M_PI/base;
    self.OreImageView.transform = CGAffineTransformRotate(self.OreImageView.transform, random);
}



// MARK: animation
- (void)setupAnimation {
    
    CAEmitterCell *explosionCell = [CAEmitterCell emitterCell];
    explosionCell.name = @"explosion";
    explosionCell.alphaRange = 0.20;
    explosionCell.alphaSpeed = -1.0;
    
    explosionCell.lifetime = 0.7;
    explosionCell.lifetimeRange = 0.3;
    explosionCell.birthRate = 0;
    explosionCell.velocity = 40.00;
    explosionCell.velocityRange = 10.00;
    
    _explosionLayer = [CAEmitterLayer layer];
    _explosionLayer.name = @"emitterLayer";
    _explosionLayer.emitterShape = kCAEmitterLayerCircle;
    _explosionLayer.emitterMode = kCAEmitterLayerOutline;
    _explosionLayer.emitterSize = CGSizeMake(50, 0);
    _explosionLayer.emitterCells = @[explosionCell];
    _explosionLayer.renderMode = kCAEmitterLayerOldestFirst;
    _explosionLayer.masksToBounds = NO;
    _explosionLayer.seed = 1366128504;
    [self.layer addSublayer:_explosionLayer];
    
    CAEmitterCell *chargeCell = [CAEmitterCell emitterCell];
    chargeCell.name = @"charge";
    chargeCell.alphaRange = 0.20;
    chargeCell.alphaSpeed = -1.0;
    
    chargeCell.lifetime = 0.3;
    chargeCell.lifetimeRange = 0.1;
    chargeCell.birthRate = 0;
    chargeCell.velocity = -40.0;
    chargeCell.velocityRange = 0.00;
    
    _chargeLayer = [CAEmitterLayer layer];
    _chargeLayer.name = @"emitterLayer";
    _chargeLayer.emitterShape = kCAEmitterLayerCircle;
    _chargeLayer.emitterMode = kCAEmitterLayerOutline;
    _chargeLayer.emitterSize = CGSizeMake(50, 0);
    _chargeLayer.emitterCells = @[chargeCell];
    _chargeLayer.renderMode = kCAEmitterLayerOldestFirst;
    _chargeLayer.masksToBounds = NO;
    _chargeLayer.seed = 1366128504;
    [self.layer addSublayer:_chargeLayer];
    
    self.emitterCells = @[chargeCell, explosionCell];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    CGPoint center = CGPointMake(CGRectGetMidX(self.bounds), CGRectGetMidY(self.bounds));
    self.chargeLayer.emitterPosition = center;
    self.explosionLayer.emitterPosition = center;
}

#pragma mark - Methods

- (void)animate {
    self.chargeLayer.beginTime = CACurrentMediaTime();
    [self.chargeLayer setValue:@80 forKeyPath:@"emitterCells.charge.birthRate"];
    [self performSelector:@selector(explode) withObject:nil afterDelay:0.2];
}

- (void)explode {
    [self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    self.explosionLayer.beginTime = CACurrentMediaTime();
    [self.explosionLayer setValue:@500 forKeyPath:@"emitterCells.explosion.birthRate"];
    [self performSelector:@selector(stop) withObject:nil afterDelay:0.1];
}

- (void)stop {
    [self.chargeLayer setValue:@0 forKeyPath:@"emitterCells.charge.birthRate"];
    [self.explosionLayer setValue:@0 forKeyPath:@"emitterCells.explosion.birthRate"];
}

#pragma mark - Properties

- (void)setParticleImage:(UIImage *)particleImage {
    _particleImage = particleImage;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.contents = (id)[particleImage CGImage];
    }
}

- (void)setParticleScale:(CGFloat)particleScale {
    _particleScale = particleScale;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scale = particleScale;
    }
}

- (void)setParticleScaleRange:(CGFloat)particleScaleRange {
    _particleScaleRange = particleScaleRange;
    for (CAEmitterCell *cell in self.emitterCells) {
        cell.scaleRange = particleScaleRange;
    }
}

@end
