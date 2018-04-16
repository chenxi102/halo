//
//  HWAssetsRecordTableView.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsRecordTableView.h"
#import "HWMasonry.h"
#import "HWHttpService.h"
#import "HWUIHelper.h"
#import "HWAssetsRecordTableViewCell.h"

@interface HWAssetsRecordTableView ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) UIView * paramSetNavView;

@property (nonatomic, strong) UILabel * titleLAB;
@property (nonatomic, strong) UITableView * tabView;


@end

@implementation HWAssetsRecordTableView

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self setup];
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
        table.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        table.alpha = 1;
        table.tableFooterView = [UIView new];
        table.tableHeaderView = [UIView new];
        table;
    });
    [self addSubview:_tabView];
    [_tabView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@0);
        make.right.equalTo(@0);
        make.top.equalTo(@48);
        make.bottom.equalTo(@-20);
    }];
    
    UILabel * noneDatatipLab = [UILabel new];
    noneDatatipLab.font = [UIFont fontWithName:@"Helvetica" size:16];
    noneDatatipLab.textColor = [UIColor redColor];
    noneDatatipLab.textAlignment = NSTextAlignmentRight;
    noneDatatipLab.text = @"暂无数据";
    noneDatatipLab.hidden = YES;
    [_tabView addSubview:noneDatatipLab];
    self.noneDatatipLab = noneDatatipLab;
    [noneDatatipLab HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerX.centerY.equalTo(@0);
    }];
    
    _titleLAB = [UILabel new];
    _titleLAB.font = [UIFont fontWithName:@"Helvetica" size:18];
    _titleLAB.textColor = HWHexColor(0xFFE07A);
    _titleLAB.textAlignment = NSTextAlignmentCenter;
    _titleLAB.text = [HWHttpService shareInstance].selfOre_userAssetsRecordtr;
    [self addSubview:_titleLAB];
    [_titleLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@47);
    }];
    
    UILabel * topline = [UILabel new];
    [self addSubview:topline];
    topline.backgroundColor = HWHexColor(0x84E3E4);;
    [topline HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@3);
        make.right.equalTo(@-3);
        make.top.equalTo(@0);
        make.height.equalTo(@0.5);
    }];
    
    UILabel * bottomline = [UILabel new];
    [self addSubview:bottomline];
    bottomline.backgroundColor = HWHexColor(0xFFE07A);;
    [bottomline HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@23);
        make.right.equalTo(@-23);
        make.top.equalTo(@47.5);
        make.height.equalTo(@0.5);
    }];
}

- (void)setDatas_mut:(NSMutableArray<HWRecordModel *> *)datas_mut {
    _datas_mut = datas_mut;
    [self.tabView reloadData];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas_mut.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWAssetsRecordTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HWAssetsRecordTableViewCell"];
    if (!cell) {
        cell = [[HWAssetsRecordTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HWAssetsRecordTableViewCell"];
    }
    cell.item = _datas_mut[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 38;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
