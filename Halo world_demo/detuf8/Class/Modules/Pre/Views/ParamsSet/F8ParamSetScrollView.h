//
//  F8ParamSetScrollView.h
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CameraButton;
@class CameraControlScrollView;

@protocol CameraControlScrollDelegate <NSObject>
- (void)CameraControlScrollItemClicked:(CameraButton*_Nullable)camera;
- (void)CameraControlScrollDidScroll;
- (void)CameraControlScrollBeginScroll;
- (void)CameraControlScrollEndScroll;
@end

//MARK: 模式滑动按钮
@interface F8ParamSetScrollView : UIScrollView<CameraControlScrollDelegate>

@property (nonatomic, strong) CameraButton * _Nullable cameraSelectBtn;
@property (nonatomic, assign) NSInteger currentIndex;   // 移动按钮位置
@property (nonatomic, assign) NSInteger preIndex;     // 移动按钮位置
@property (nonatomic, assign) CGFloat currentValue;   // 移动按钮的值
@property (nonatomic, weak) id <CameraControlScrollDelegate>_Nullable scrDelegate;
- (instancetype _Nullable )initWithDatas:(F8ParamMode * _Nullable)items width:(CGFloat)itemWidth screenCount:(NSInteger)screenCount withIndex:(CGFloat)index;
- (void)reset;

@end


@interface CameraButton : UIButton
@property (nonatomic, assign) CGFloat value;
@property (nonatomic, assign) NSInteger index;
@end
