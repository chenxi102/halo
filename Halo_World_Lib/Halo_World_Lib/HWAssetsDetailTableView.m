//
//  HWAssetsDetailTableView.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/4/16.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailTableView.h"
#import "HWMasonry.h"
#import "HWHttpService.h"
#import "HWUIHelper.h"
#import "HWAssetsDetailTableViewCell.h"


@interface HWAssetsDetailTableView()<UITableViewDataSource,UITableViewDelegate>
@property (nonatomic, strong) UILabel * titleLAB;
@property (nonatomic, strong) UITableView * tabView;
@end

@implementation HWAssetsDetailTableView
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
        table.contentInset = UIEdgeInsetsMake(10, 0, 0, 0);
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
        make.bottom.equalTo(@0);
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
    _titleLAB.textColor = HWHexColor(0x84E3E4);;
    _titleLAB.textAlignment = NSTextAlignmentCenter;
    _titleLAB.text = [HWHttpService shareInstance].selfOre_userAssetsStr;
    [self addSubview:_titleLAB];
    [_titleLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.right.top.equalTo(@0);
        make.height.equalTo(@48);
    }];
    
    UILabel * bottomline = [UILabel new];
    [self addSubview:bottomline];
    bottomline.backgroundColor = HWHexColor(0x84E3E4);
    [bottomline HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@23);
        make.right.equalTo(@-23);
        make.top.equalTo(@47.5);
        make.height.equalTo(@0.3);
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
    HWAssetsDetailTableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:@"HWAssetsDetailTableViewCell"];
    if (!cell) {
        cell = [[HWAssetsDetailTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"HWAssetsDetailTableViewCell"];
    }
    cell.item = _datas_mut[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 30;
    
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

@end
