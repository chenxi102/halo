//
//  F8ParamSetTabView.m
//  detuf8
//
//  Created by Seth on 2018/3/6.
//  Copyright © 2018年 detu. All rights reserved.
//

#import "F8ParamSetTabView.h"
#import "F8ParamSetTabCell.h"
#import "F8ParamMode.h"

@interface F8ParamSetTabView()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UIView * paramSetNavView;
@property (nonatomic, strong) UIButton * resetBTN;
@property (nonatomic, strong) UILabel * titleLAB;

@property (nonatomic, strong) UITableView * tabView;

@property (nonatomic, strong) NSMutableArray <F8ParamMode *>* datas_mut;

@property (nonatomic, copy) void(^refreshUIBlock)(void); // 弹窗 UI 高度 刷新



@end

@implementation F8ParamSetTabView
- (void)dealloc{
    DeBugLog(@"F8ParamSetTabView dealloc");
}

- (UIView *)paramSetNavView {
    
    if (!_paramSetNavView) {
        _paramSetNavView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, _tabView.width, 38)];

        _titleLAB = [UILabel new];
        [_paramSetNavView addSubview:_titleLAB];
        _titleLAB.font = [UIFont systemFontOfSize:15];
        _titleLAB.textAlignment = NSTextAlignmentLeft;
        [_titleLAB mas_makeConstraints:^(MASConstraintMaker *make) {
            make.left.equalTo(@20);
            make.top.bottom.equalTo(@0);
            make.centerY.equalTo(@0);
        }];
        if (self.paramSetViewType == ParamCellType_expView) {
            _titleLAB.text = @"曝光设置";
        }else if (self.paramSetViewType == ParamCellType_imgView) {
            _titleLAB.text = @"画质设置";
        }else
            _titleLAB.text = @"基础设置";
        
        _resetBTN = [UIButton new];
        [_resetBTN setImage:[UIImage imageNamed:@"重置"] forState:UIControlStateNormal];
        [_paramSetNavView addSubview:_resetBTN];
        [_resetBTN mas_makeConstraints:^(MASConstraintMaker *make) {
            make.right.equalTo(@-20);
            make.centerY.equalTo(@0);
            make.width.height.equalTo(@30);
        }];
        @weak(self)
        [_resetBTN addBlockForControlEvents:UIControlEventTouchUpInside block:^(id  _Nonnull sender) {
            @strong(self)
            // 传递点击到VC
            if(self.clickStartBlock)self.clickStartBlock(0, 0);
            [F8ParamSetHandle restParamWithType:self.paramSetViewType Res:^(int code) {
                [self performBlock:^{
                    if (code == 0) {
                        [self initData];
                    }
                    // 传值到VC
                    if(self.resultBlock)self.resultBlock(0, code);
                } afterDelay:0.01];
            }];
        }];
    }
    
    return _paramSetNavView;
}

- (void)initData {
    
    [self.datas_mut removeAllObjects];
    
    if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_photo)
    {
        if (_paramSetViewType == ParamCellType_expView) {
            if ([F8SocketAPI shareInstance].cameraInfo.exposure_mode == 1) {
                [self.datas_mut addObject:[F8ParamTools getPicEXPDataSource]];
                [self.datas_mut addObject:[F8ParamTools getPicISODataSource]];
                [self.datas_mut addObject:[F8ParamTools getPicShutterDataSource]];
                [self.datas_mut addObject:[F8ParamTools getPicWBDataSource]];
                // 白平衡是自定义  显示色温
                if ([F8SocketAPI shareInstance].cameraInfo.PicWB == 1) {
                    [self.datas_mut addObject:[F8ParamTools getPicTepDataSource]];
                }
            } else {
                [self.datas_mut addObject:[F8ParamTools getPicEXPDataSource]];
                [self.datas_mut addObject:[F8ParamTools getPicEVDataSource]];
                [self.datas_mut addObject:[F8ParamTools getPicShutterDataSource]];
            }
        } else if (_paramSetViewType == ParamCellType_imgView)  {
            [self.datas_mut addObject:[F8ParamTools getPicHDRDataSource]];
            [self.datas_mut addObject:[F8ParamTools getPicBrightnessDataSource]];
            [self.datas_mut addObject:[F8ParamTools getPicContrastDataSource]];
            [self.datas_mut addObject:[F8ParamTools getPicSharpnessDataSource]];
            [self.datas_mut addObject:[F8ParamTools getPicSaturationDataSource]];
        } else {
            [self.datas_mut addObject:[F8ParamTools getContentDataSource]];
            [self.datas_mut addObject:[F8ParamTools getPicResDataSource]];
        }
    }
    else if ([F8SocketAPI shareInstance].cameraInfo.cameraModeStruct.mode == F8CameraType_video) {
        if (_paramSetViewType == ParamCellType_expView) {
            [self.datas_mut addObject:[F8ParamTools getMovEVDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovWBDataSource]];
            // 白平衡是自定义  显示色温
            if ([F8SocketAPI shareInstance].cameraInfo.MovWB == 1) {
                [self.datas_mut addObject:[F8ParamTools getMovTepDataSource]];
            }
        } else if (_paramSetViewType == ParamCellType_imgView)  {
            [self.datas_mut addObject:[F8ParamTools getMovHDRDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovBrightnessDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovContrastDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovSharpnessDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovSaturationDataSource]];
        } else {
            [self.datas_mut addObject:[F8ParamTools getContentDataSource]];
            [self.datas_mut addObject:[F8ParamTools getMovSensorModeDataSource]];
        }
    }
    
    if(self.refreshUIBlock)self.refreshUIBlock();
    
    [self.tabView  reloadData];
//    [self refreshSlider];
}

- (instancetype)initWithParamSetViewType:(F8ParamSetViewType)paramSetViewType refreshCallBack:(void(^)(void))res
{
    self = [super init];
    if (self) {
        self.refreshUIBlock = res;
        self.datas_mut = [NSMutableArray array];
        self.paramSetViewType = paramSetViewType;
        [self setup];
        [self initData];
    }
    return self;
}

- (void)setup {

    _tabView = ({
        UITableView * table = [[UITableView alloc] init];
        table.separatorStyle = UITableViewCellSeparatorStyleNone;
        table.bounces = NO;
        table.delegate = (id)self;
        table.dataSource = (id)self;
        table.backgroundColor = [UIColor clearColor];
        table.alpha = 1;
        table.tableFooterView = [UIView new];
//        table.tableHeaderView = self.paramSetNavView;
        table;
    });
    [self addSubview:_tabView];
    [_tabView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
        make.top.equalTo(@38);
    }];
}

#pragma mark - UITableViewDataSource

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    return self.paramSetNavView;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 38;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas_mut.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    @weak(self)
    F8ParamSetTabCell * cell = [[F8ParamSetTabCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell" ParamSetViewType:self.paramSetViewType items:_datas_mut[indexPath.row] curIndex:_datas_mut[indexPath.row].pramaIndex callBack:^(ParamCommandType type, CGFloat index) {
        @strong(self)
        DeBugLog(@"param index is %f", index);
        [self performBlock:^{
            
            
            
            // 传递点击到VC
            if(self.clickStartBlock)self.clickStartBlock(type, index);
            
            @weak(self)
            [F8ParamSetHandle setParamCommandType:type value:index Res:^(int abool) {
                @strong(self)
                [self performBlock:^{
                   
                    if (abool == 0)
                    {   //  不同曝光模式 展示UI不同
                        if (type == ParamCommandType_exp) {
                            [F8SocketAPI shareInstance].cameraInfo.exposure_mode = (int)index;
                            [self initData];
                            
                        }// 白平衡是自定义  显示色温
                        else if (type == ParamCommandType_wb) {
                            [self initData];
                        }
                    }else{
                        [self initData];
                        if(self.refreshUIBlock)self.refreshUIBlock();
                    }
                    
                    // 传值到VC
                    if(self.resultBlock)self.resultBlock(type, abool);
                    
                } afterDelay:.2];
            }];
            
            
            
        } afterDelay:.2];
        
    }];
    if (indexPath.row == 0) {
        cell.topLine.hidden = NO;
        cell.botLine.hidden = NO;
    } else {
        cell.topLine.hidden = YES;
        cell.botLine.hidden = NO;
    }
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
    
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
