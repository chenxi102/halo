
//
//  HWAssetsDetailedView.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailedView.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"

@interface HWAssetsDetailedView()

//@property (nonatomic, strong) F8assetsDetailedView * assetsDetailedView;
//@property (nonatomic, assign) F8ParamSetViewType paramSetViewType;
//@property (nonatomic, strong) UILabel * titleLAB;
//
@property (nonatomic, copy) NSString * title;
@property (nonatomic, strong) UITableView * assetsDetailedView;

@end

@implementation HWAssetsDetailedView
- (void)dealloc{
    NSLog(@"F8ParamSetView dealloc");
}

- (void)setup {
    @HWweak(self)
//    _assetsDetailedView = [[UITableView new] initWithParamSetViewType:_paramSetViewType refreshCallBack:^{
//        @strong(self);
//        [self performBlock:^{
//            [self setupFrame];
//        } afterDelay:.01];
//    }];
    _assetsDetailedView.backgroundColor = [UIColor whiteColor];
    _assetsDetailedView.clipsToBounds = YES;
    _assetsDetailedView.layer.cornerRadius = 13;
    [self addSubview: _assetsDetailedView];
    _assetsDetailedView.transform = CGAffineTransformMakeTranslation(0, 500);
    [_assetsDetailedView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@15);
        make.bottom.right.equalTo(@-15);
        make.height.equalTo(@(500));
    }];
}

- (void)disappear
{
    [UIView animateWithDuration:.3 animations:^{
        self.assetsDetailedView.transform = CGAffineTransformMakeTranslation(0, 500);
    } completion:^(BOOL finished) {
        [UIView animateWithDuration:.2 animations:^{
            self.alpha = 0;
        } completion:^(BOOL finished) {
            [self removeFromSuperview];
        }];
    }];
}

- (void)show {
    [UIView animateWithDuration:.2 animations:^{
        self.assetsDetailedView.transform = CGAffineTransformIdentity;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:.3];
    } completion:^(BOOL finished) {
        
    }];
}

@end
