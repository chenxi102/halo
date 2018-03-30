//
//  HWAssetsDetailedTableView.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailedTableView.h"
#import "HWMasonry.h"
#import "HWHttpService.h"
#import "HWUIHelper.h"
#import "HWAssetsDetailedTableViewCell.h"

@interface HWAssetsDetailedTableView ()<UITableViewDataSource,UITableViewDelegate>

//@property (nonatomic, strong) UIView * paramSetNavView;

@property (nonatomic, strong) UILabel * titleLAB;
@property (nonatomic, strong) UITableView * tabView;


@end

@implementation HWAssetsDetailedTableView

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
        //        table.tableHeaderView = self.paramSetNavView;
        table;
    });
    [self addSubview:_tabView];
    [_tabView HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@20);
        make.right.equalTo(@-20);
        make.top.equalTo(@70);
        make.bottom.equalTo(@-110);
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
    _titleLAB.font = [UIFont fontWithName:@"Helvetica" size:20];
    _titleLAB.textColor = [UIColor whiteColor];
    _titleLAB.textAlignment = NSTextAlignmentCenter;
    _titleLAB.text = [HWHttpService shareInstance].selfOre_assetsRecordStr;
    [self addSubview:_titleLAB];
    [_titleLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@70);
    }];
    
    _backBTN = [UIButton new];
    [_backBTN setImage:[HWUIHelper imageWithCameradispatchName:@"按钮"] forState:(UIControlStateNormal)];
    [self addSubview:_backBTN];
    [_backBTN HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerX.equalTo(@0);
        make.width.equalTo(@50);
        make.height.equalTo(@50);
        make.bottom.equalTo(@-30);
    }];
}

- (void)setDatas_mut:(NSMutableArray<HWRecordModel *> *)datas_mut {
    _datas_mut = datas_mut;
    [self.tabView reloadData];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 44;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return _datas_mut.count;
}

- (UITableViewCell*)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    HWAssetsDetailedTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HWAssetsDetailedTableViewCell"];
    if (!cell) {
        cell = [[HWAssetsDetailedTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HWAssetsDetailedTableViewCell"];
    }
    cell.item = _datas_mut[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 48;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}
@end
