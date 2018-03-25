//
//  F8ParamSetScrollView.m
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamSetScrollView.h"
#import "F8ParamMode.h"

@interface F8ParamSetScrollView()<UIScrollViewDelegate>

@property (nonatomic, strong) F8ParamMode* paramMode;
@property (nonatomic, strong) NSMutableArray<CameraButton*>* _BTNitems;
@property (nonatomic, assign) CGFloat _width;        // 当前每个单元的长度  和 screenCount意义相近

@property (nonatomic, assign) NSInteger screenCount; // 当前屏幕显示个数 ： 为了计算起始位置，以及起始偏移
@property (nonatomic, assign) CGFloat startOffsetx;  // 起始偏移量 : 单双数是不一样的

@end

@implementation F8ParamSetScrollView

- (void)dealloc {
    NSLog(@"CameraControlScrollView previews dealloc");
}

- (instancetype _Nullable )initWithDatas:(F8ParamMode * _Nullable)items width:(CGFloat)itemWidth screenCount:(NSInteger)screenCount withIndex:(CGFloat)index;
{
    
    self = [super init];
    if (self) {
        _paramMode = items;
        __width = itemWidth;
        _screenCount = screenCount;
        _startOffsetx =  screenCount%2==0?.5:0;
        _currentValue = index;
        self.delegate = self;
        self.bouncesZoom = NO;
        self.bounces = NO;
        self.showsVerticalScrollIndicator = NO;
        self.showsHorizontalScrollIndicator = NO;
        __BTNitems = [NSMutableArray array];
        [self setUp];
        self.currentValue = _currentValue;
    }
    return self;
}

- (void)setUp
{
    __weak typeof(self)weakself = self;
    long __count;
    __count = _paramMode.pramas.count + _screenCount/2*2;
  
    self.contentSize = CGSizeMake(__width*__count, self.height);
    
    for (int _ = 0; _ < _paramMode.pramas.count; _ ++) {
        F8ParamSubMode * mode =  _paramMode.pramas[_];
        NSString * tempStr = mode.pramaTitle;
        CameraButton * tempbBtn = [CameraButton buttonWithType:UIButtonTypeCustom];
        tempbBtn.value = mode.pramaValue;
        tempbBtn.index = _;
        [tempbBtn setTitleColor:RGB_A(50,52,52,.7) forState:UIControlStateNormal];
        [tempbBtn setTitleColor:RGB_A(50,52,52,1) forState:UIControlStateSelected];
        [tempbBtn setTitle:tempStr forState:UIControlStateNormal];
        tempbBtn.titleLabel.font = [UIFont systemFontOfSize:13];
//        tempbBtn.backgroundColor = [UIColor yellowColor];
//        tempbBtn.titleLabel.backgroundColor = [UIColor redColor];
        tempbBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
        [self addSubview:tempbBtn];
        [tempbBtn addTarget:self action:@selector(itemsTap:) forControlEvents:UIControlEventTouchUpInside];
      
        [tempbBtn mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakself)self = weakself;
            make.left.equalTo(@(self._width*(_+_screenCount/2)));
            make.top.equalTo(@(0));
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(self._width));
        }];
        [self._BTNitems addObject:tempbBtn];
    }
}

- (void)itemsTap:(CameraButton*)sender
{
    // 去重
    if (sender.index == _currentIndex) {
        return;
    }
    self.preIndex = self.currentIndex;
    if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollItemClicked:)]) {
        [self.scrDelegate CameraControlScrollItemClicked:sender];
    }
    for (CameraButton * btn in __BTNitems) {
        btn.selected = NO;
    }
    sender.selected = YES;
    self.cameraSelectBtn = sender;
    _currentValue = sender.value;
    self.currentIndex = sender.index;
}

// 无动画  初始化用
- (void)setCurrentValue:(CGFloat)currentValue
{
    _currentValue = currentValue;
    for (CameraButton * btn in __BTNitems)
    {
        btn.selected = NO;
        NSString *btnValueStr = [NSString stringWithFormat:@"%.2f", btn.value];
        NSString *cValueStr = [NSString stringWithFormat:@"%.2f", _currentValue];
        if ([btnValueStr isEqualToString:cValueStr])
        {
            btn.selected = YES;
            self.cameraSelectBtn = btn;
            _currentIndex = btn.index;
            _preIndex = _currentIndex;
        }
    }
    [self roll:_currentIndex withAnimation:NO];
}

// 冇动画
- (void)setCurrentIndex:(NSInteger)currentIndex
{
    _currentIndex = currentIndex;
    for (CameraButton * btn in __BTNitems)
    {
        btn.selected = NO;
        if (btn.index == _currentIndex)
        {
            btn.selected = YES;
            self.cameraSelectBtn = btn;
            _currentValue = btn.value;
        }
    }
    [self roll:_currentIndex withAnimation:YES];
}

- (void)roll:(NSInteger)scr withAnimation:(BOOL)abool {
    
    switch (scr) {
        case 0:
        {
            if (abool) {
                [UIView  animateWithDuration:.2 animations:^{
                    self.contentOffset = CGPointMake(0+_startOffsetx*self._width, 0);
                } completion:^(BOOL finished) {
                    [self performBlock:^{
                        if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollEndScroll)]) {
                            [self.scrDelegate CameraControlScrollEndScroll];
                        }
                    } afterDelay:.2];
                }];
            }else{
                self.contentOffset = CGPointMake(0+_startOffsetx*self._width, 0);
            }
        };
            break;
        default:{
            if (abool) {
                [UIView  animateWithDuration:.2 animations:^{
                    self.contentOffset = CGPointMake(scr *self._width+_startOffsetx*self._width, 0);
                } completion:^(BOOL finished) {
                    [self performBlock:^{
                        if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollEndScroll)]) {
                            [self.scrDelegate CameraControlScrollEndScroll];
                        }
                    } afterDelay:.2];
                }];
            }else{
                self.contentOffset = CGPointMake(scr *self._width+_startOffsetx*self._width, 0);
            }
        }
            break;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    __weak typeof(self)weakself = self;
    for (int _ = 0; _ < __BTNitems.count; _ ++) {
        [__BTNitems[_] mas_makeConstraints:^(MASConstraintMaker *make) {
            __strong typeof(weakself)self = weakself;
            make.left.equalTo(@(self._width*(_+_screenCount/2)));
            make.top.equalTo(@(0));
            make.height.equalTo(self.mas_height);
            make.width.equalTo(@(self._width));
        }];
    }
}

//
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollBeginScroll)]) {
        [self.scrDelegate CameraControlScrollBeginScroll];
    }
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    float offsetX = self.contentOffset.x;
    if (_startOffsetx == 0) {
        self.currentIndex = (offsetX+self._width*(0.5))/self._width;
    } else {
        _currentIndex = (offsetX)/self._width;
        self.currentIndex = _currentIndex > _paramMode.pramas.count-1?_currentIndex-1:_currentIndex;
    }
    
    
    if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollEndScroll)]) {
        [self.scrDelegate CameraControlScrollEndScroll];
    }
    
    if (self.preIndex != self.currentIndex) {
        self.preIndex = self.currentIndex;
        if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollItemClicked:)]) {
            [self.scrDelegate CameraControlScrollItemClicked:self.cameraSelectBtn];
        }
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    float offsetX = self.contentOffset.x;
    if (!decelerate) {
        if (_startOffsetx == 0) {
            self.currentIndex = (offsetX+self._width*(0.5))/self._width;
        } else {
            _currentIndex = (offsetX)/self._width;
            self.currentIndex = _currentIndex > _paramMode.pramas.count-1?_currentIndex-1:_currentIndex;
        }
        
        if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollEndScroll)]) {
            [self.scrDelegate CameraControlScrollEndScroll];
        }
        
        if (self.preIndex != self.currentIndex) {
            self.preIndex = self.currentIndex;
            if ([self.scrDelegate respondsToSelector:@selector(CameraControlScrollItemClicked:)]) {
                [self.scrDelegate CameraControlScrollItemClicked:self.cameraSelectBtn];
            }
        }
    }
}

- (void)reset {
    [self roll:_currentIndex withAnimation:YES];
}

- (void)CameraControlScrollItemClicked:(CameraButton * _Nullable)camera {
    
}

@end




@implementation CameraButton
@end
