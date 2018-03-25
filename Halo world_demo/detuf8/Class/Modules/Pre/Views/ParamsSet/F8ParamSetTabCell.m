//
//  F8ParamSetTabCell.m
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamSetTabCell.h"
#import "F8ParamSetScrollView.h"


@interface F8ParamSetTabCell()<CameraControlScrollDelegate>

@property (nonatomic, strong) UIImageView * iconIMGV;
@property (nonatomic, strong) UILabel * iconLAB;
@property (nonatomic, strong) F8ParamMode * items;

@property (nonatomic, copy) void(^callBack)(ParamCommandType, CGFloat);

// ParamCellType_scorrowView
@property (nonatomic, strong) F8ParamSetScrollView * paramSetScrollView;
@property (nonatomic, strong) UIImageView * arrowIMGV;

// ParamCellType_sliderView
@property (nonatomic, strong) F8Slider * paramSliderView;
@property (nonatomic, strong) UILabel * paramSliderValueLAB;


@end

@implementation F8ParamSetTabCell
- (void)dealloc{
    DeBugLog(@"F8ParamSetTabCell dealloc");
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style
              reuseIdentifier:(NSString *)reuseIdentifier
             ParamSetViewType:(F8ParamSetViewType)paramSetViewType
                        items:(F8ParamMode *)items
                     curIndex:(NSInteger)curIndex
                     callBack:(void(^)(ParamCommandType, CGFloat))callback
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _paramSetViewType = paramSetViewType;
        _items = items;
        _callBack = callback;
        self.backgroundColor = [UIColor clearColor];
        self.alpha = 1;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
    @weak(self)
    _topLine = [UIView new];
    [self addSubview:_topLine];
    _topLine.backgroundColor = RGB_A(203,199,204,1);
    [_topLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    _botLine = [UIView new];
    [self addSubview:_botLine];
    _botLine.backgroundColor = RGB_A(199,203,204,1);
    [_botLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(@([AppUtil convertUnitWidthStand:79]));
        make.right.bottom.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    _iconIMGV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"曝光模式"]];
    [self addSubview:_iconIMGV];
    [_iconIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
        make.width.height.equalTo(@18);
        make.centerY.equalTo(@0);
        make.left.equalTo(@20);
    }];
    
    _iconLAB = [UILabel new];
    _iconLAB.textAlignment = NSTextAlignmentCenter;
    _iconLAB.textColor = RGB_A(114,116,116,1);
    _iconLAB.font = [UIFont  systemFontOfSize:12];
    _iconLAB.hidden = YES;
    [self addSubview:_iconLAB];
    [_iconLAB mas_makeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@20);
    }];
//    [self titleNeedToShow:NO];
    
    if (_paramSetViewType != ParamCellType_imgView) {
        NSInteger width = [AppUtil convertUnitWidthStand:244/5];
        NSInteger screenCount = 5;
        NSInteger averageWidth = [self getAverageWidth];
        NSInteger averageScreenCount = 244/averageWidth;
        
        if (averageScreenCount >= 5) {
            screenCount = 5;
            width = [AppUtil convertUnitWidthStand:244/5];
        } else if (averageScreenCount >= 4 && averageScreenCount < 5) {
            screenCount = 4;
            width = [AppUtil convertUnitWidthStand:244/4];
        } else if (averageScreenCount >= 3 && averageScreenCount < 4) {
            screenCount = 3;
            width = [AppUtil convertUnitWidthStand:244/3];
        } else {
            screenCount = 2;
            width = [AppUtil convertUnitWidthStand:244/2];
        }
        
        _paramSetScrollView = [[F8ParamSetScrollView alloc] initWithDatas:_items width:width screenCount:screenCount withIndex:_items.pramaIndex];
        [self addSubview: _paramSetScrollView];
        _paramSetScrollView.scrDelegate = self;
        [_paramSetScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.top.equalTo(@1);
            make.bottom.equalTo(@-1);
            make.width.equalTo(@([AppUtil convertUnitWidthStand:244]));
        }];
        
        _arrowIMGV = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"三角icon"]];
        [self addSubview:_arrowIMGV];
        [_arrowIMGV mas_makeConstraints:^(MASConstraintMaker *make) {
            make.width.equalTo(@8);
            make.height.equalTo(@6);
            make.right.equalTo(@(-([AppUtil convertUnitWidthStand:244]/2+20)));
            make.bottom.equalTo(@0);
        }];
        
//        [RACObserve(self.paramSetScrollView, contentOffset) subscribeNext:^(id  _Nullable x) {
//            
//        }];
        
    } else {
        
        _paramSliderView = [F8Slider new];
        _paramSliderView.minimumValue = ((F8ParamSubMode*)(_items.pramas[0])).pramaValue;
        _paramSliderView.maximumValue = ((F8ParamSubMode*)(_items.pramas[1])).pramaValue;
        _paramSliderView.minimumTrackTintColor = RGB_A(199,203,204,1);
        _paramSliderView.maximumTrackTintColor = RGB_A(199,203,204,1);;//RGB_A(112,116,116,1);
        [_paramSliderView setThumbImage:[UIImage imageNamed:@"滑动圆"] forState:(UIControlStateNormal)];
        _paramSliderView.value = _items.pramaIndex;
        [self addSubview:_paramSliderView];
        [_paramSliderView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-60);
            make.centerY.equalTo(@1);
            make.width.equalTo(@([AppUtil convertUnitWidthStand:204]));
        }];
        [_paramSliderView addTarget:self action:@selector(sliderTouchDown:) forControlEvents:UIControlEventTouchDown];
        [_paramSliderView addTarget:self action:@selector(sliderValuChanged:) forControlEvents:UIControlEventValueChanged];
        [_paramSliderView addTarget:self action:@selector(sliderValuChangedEND:) forControlEvents:UIControlEventTouchUpInside|UIControlEventTouchUpOutside|UIControlEventTouchCancel];
        
        _paramSliderValueLAB = [UILabel new];
        [self addSubview:_paramSliderValueLAB];
        _paramSliderValueLAB.text = [NSString stringWithFormat:@"%d",(int)_paramSliderView.value];
        _paramSliderValueLAB.textAlignment = NSTextAlignmentCenter;
        _paramSliderValueLAB.textColor = RGB_A(50,52,52,1);
        [_paramSliderValueLAB mas_makeConstraints:^(MASConstraintMaker *make) {
            @strong(self)
            make.right.equalTo(@0);
            make.top.bottom.equalTo(@0);
            make.left.equalTo(self.paramSliderView.mas_right);
        }];
    }
    
    [self set_Icon];
}

- (float)getAverageWidth {
    float width = 0;
    for (F8ParamSubMode * m in _items.pramas) {
        width += [m.pramaTitle boundingRectWithSize:(CGSize){10000,20} options:(NSStringDrawingUsesLineFragmentOrigin) attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13 ]} context:nil].size.width+10;
    }
    width = width/_items.pramas.count;
    return width;
}

// MARK: 滚动轴的代理
- (void)CameraControlScrollBeginScroll {
    [self titleNeedToShow:YES];
}

- (void)CameraControlScrollEndScroll {
    [self titleNeedToShow:NO];
}

- (void)CameraControlScrollItemClicked:(CameraButton*)camera {
    if (_callBack) {
        _callBack(self.items.pramaType, camera.value);
    }
    [self titleNeedToShow:YES];
}

// MARK: slider
- (void)sliderTouchDown:(F8Slider *)sender {
    [self titleNeedToShow:YES];
}

- (void)sliderValuChanged:(F8Slider *)sender {
    self.paramSliderValueLAB.text = [NSString stringWithFormat:@"%d",(int)sender.value];
}

- (void)sliderValuChangedEND:(F8Slider *)sender {
    
    [self titleNeedToShow:NO];
    self.paramSliderValueLAB.text = [NSString stringWithFormat:@"%d",(int)sender.value];
    if (!self.paramSliderView.isSlidering) {
        [self titleNeedToShow:NO];
        if (_callBack) {
            _callBack(self.items.pramaType, sender.value);
        }
    }
}

// MARK: 通用
- (void)titleNeedToShow:(BOOL)isNeed {
    
    if (self.items.pramaType ==  ParamCommandType_contentType||self.items.pramaType ==  ParamCommandType_resolution) {
        return;
    }
    
    [UIView animateWithDuration:.2 animations:^{
        [self performBlock:^{
            if (isNeed) {
                _iconIMGV.hidden = YES;
                _iconLAB.hidden = NO;
            }else{
                _iconIMGV.hidden = NO;
                _iconLAB.hidden = YES;
            }
        } afterDelay:0.01];
    }];
}

- (void)set_Icon {
    _iconIMGV.hidden = NO;
    _iconLAB.hidden = YES;
    switch (self.items.pramaType) {
        case ParamCommandType_exp:
            [_iconIMGV setImage:[UIImage imageNamed:@"曝光模式"]];
            _iconLAB.text = @"曝光模式";
            break;
        case ParamCommandType_iso:
            [_iconIMGV setImage:[UIImage imageNamed:@"iso"]];
            _iconLAB.text = @"ISO";
            break;
        case ParamCommandType_shutter:
            [_iconIMGV setImage:[UIImage imageNamed:@"快门"]];
            _iconLAB.text = @"快门时间";
            break;
        case ParamCommandType_wb:
            [_iconIMGV setImage:[UIImage imageNamed:@"白平衡"]];
            _iconLAB.text = @"白平衡";
            break;
        case ParamCommandType_tep:
            [_iconIMGV setImage:[UIImage imageNamed:@"色温"]];
            _iconLAB.text = @"色温";
            break;
        case ParamCommandType_ev:
            [_iconIMGV setImage:[UIImage imageNamed:@"EV"]];
            _iconLAB.text = @"EV";
            break;
        case ParamCommandType_hdr:
            [_iconIMGV setImage:[UIImage imageNamed:@"hdr"]];
            _iconLAB.text = @"HDR模式";
            break;
        case ParamCommandType_light:
            [_iconIMGV setImage:[UIImage imageNamed:@"亮度"]];
            _iconLAB.text = @"亮度";
            break;
        case ParamCommandType_contrast:
            [_iconIMGV setImage:[UIImage imageNamed:@"对比度"]];
            _iconLAB.text = @"对比度";
            break;
        case ParamCommandType_sharpness:
            [_iconIMGV setImage:[UIImage imageNamed:@"锐度"]];
            _iconLAB.text = @"锐度";
            break;
        case ParamCommandType_saturation:
            [_iconIMGV setImage:[UIImage imageNamed:@"饱和度"]];
            _iconLAB.text = @"饱和度";
            break;
        case ParamCommandType_contentType:
            _iconIMGV.hidden = YES;
            _iconLAB.hidden = NO;
            _iconLAB.text = @"内容类型";
            break;
        case ParamCommandType_resolution:
            _iconIMGV.hidden = YES;
            _iconLAB.hidden = NO;
            _iconLAB.text = @"分辨率";
            break;
        default:
            break;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [_paramSetScrollView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(@-20);
        make.top.equalTo(@0);
        make.bottom.equalTo(@0);
        make.width.equalTo(@([AppUtil convertUnitWidthStand:244]));
    }];
}


@end















@implementation F8Slider
#define SLIDER_X_BOUND 30
#define SLIDER_Y_BOUND 40
CGRect lastBounds;
- (CGRect)thumbRectForBounds:(CGRect)bounds trackRect:(CGRect)rect value:(float)value;
{
    rect.origin.x = rect.origin.x;
    rect.size.width = rect.size.width;
    CGRect result = [super thumbRectForBounds:bounds trackRect:rect value:value];
    //记录下最终的frame
    lastBounds = result;
    return result;
}
//检查点击事件点击范围是否能够交给self处理
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    //调用父类方法,找到能够处理event的view
    UIView* result = [super hitTest:point withEvent:event];
    if (result != self) {
        /*如果这个view不是self,我们给slider扩充一下响应范围,
         这里的扩充范围数据就可以自己设置了
         */
        if ((point.y >= -15) &&
            (point.y < (lastBounds.size.height + SLIDER_Y_BOUND)) &&
            (point.x >= 0 && point.x < CGRectGetWidth(self.bounds))) {
            //如果在扩充的范围类,就将event的处理权交给self
            result = self;
        }
    }
    //否则,返回能够处理的view
    return result;
}
//检查是点击事件的点是否在slider范围内
- (BOOL)pointInside:(CGPoint)point withEvent:(UIEvent *)event {
    //调用父类判断
    BOOL result = [super pointInside:point withEvent:event];
    if (!result) {
        //同理,如果不在slider范围类,扩充响应范围
        if ((point.x >= (lastBounds.origin.x - SLIDER_X_BOUND)) && (point.x <= (lastBounds.origin.x + lastBounds.size.width + SLIDER_X_BOUND))
            && (point.y >= -SLIDER_Y_BOUND) && (point.y < (lastBounds.size.height + SLIDER_Y_BOUND))) {
            //在扩充范围内,返回yes
            result = YES;
        }
    }
    //NSLog(@"UISlider(%d).pointInside: (%f, %f) result=%d", self, point.x, point.y, result);
    //否则返回父类的结果
    return result;
}

- (BOOL)beginTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    self.isSlidering = [super beginTrackingWithTouch:touch withEvent:event];
    return _isSlidering;
}

- (void)endTrackingWithTouch:(UITouch *)touch withEvent:(UIEvent *)event {
    
    [super endTrackingWithTouch:touch withEvent:event];
    self.isSlidering = NO;
}

@end

