//
//  HWAssetsDetailedTableViewCell.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailedTableViewCell.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"

@interface HWAssetsDetailedTableViewCell()

@property (nonatomic, strong) UIImageView * iconIMGV;
@property (nonatomic, strong) UILabel * contenLAB;
@property (nonatomic, strong) UILabel * timeLAB;
@property (nonatomic, strong) UILabel * numLAB;




@end

@implementation HWAssetsDetailedTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    // Configure the view for the selected state
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.backgroundColor = [[UIColor clearColor] colorWithAlphaComponent:0];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        [self setup];
    }
    return self;
}

- (void)setup {
//    _topLine = [UIImageView new];
//    [self addSubview:_topLine];
//    _topLine.image =  [HWUIHelper imageWithCameradispatchName:@"条形"];
//    [_topLine HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
//        make.left.right.top.equalTo(@0);
//        make.height.equalTo(@.5);
//    }];
    
    _botLine = [UIImageView new];
    [self addSubview:_botLine];
    _botLine.image =  [HWUIHelper imageWithCameradispatchName:@"条形"];
    [_botLine HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.right.bottom.equalTo(@0);
        make.height.equalTo(@.5);
    }];
    
    _iconIMGV = [[UIImageView alloc] initWithImage:[HWUIHelper imageWithCameradispatchName:@"矿石"]];
    [self addSubview:_iconIMGV];
    [_iconIMGV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.width.height.equalTo(@35);
        make.centerY.equalTo(@0);
        make.left.equalTo(@0);
    }];
    
    _contenLAB = [UILabel new];
    _contenLAB.font = [UIFont fontWithName:@"Helvetica" size:14];
    _contenLAB.textColor = [UIColor whiteColor];
    _contenLAB.textAlignment = NSTextAlignmentLeft;
    _contenLAB.text = @"收到KCASH";
    [self addSubview:_contenLAB];
    [_contenLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0).offset(-9);
        make.left.equalTo(@80);
    }];
    
    _timeLAB = [UILabel new];
    _timeLAB.font = [UIFont fontWithName:@"Helvetica" size:11];
    _timeLAB.textColor = [UIColor whiteColor];
    _timeLAB.textAlignment = NSTextAlignmentLeft;
    _timeLAB.text = @"4月1号";
    [self addSubview:_timeLAB];
    [_timeLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0).offset(9);
        make.left.equalTo(@80);
    }];
    
    _numLAB = [UILabel new];
    _numLAB.font = [UIFont fontWithName:@"Helvetica" size:16];
    _numLAB.textColor = [UIColor redColor];
    _numLAB.textAlignment = NSTextAlignmentRight;
    _numLAB.text = @"+5.5";
    [self addSubview:_numLAB];
    [_numLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.right.equalTo(@-12);
    }];
}

/*
 
 @property (nonatomic,copy) NSString *recordId;          // 记录编号
 @property (nonatomic,assign) double token_number;       // 数量
 @property (nonatomic,copy) NSString *createTime;        // 创建时间
 @property (nonatomic,copy) NSString *token_type;        // 币种: LET KCASH ACT
 @property (nonatomic,copy) NSString *operationType;     // 操作: 0 支出 1收入
 @property (nonatomic,copy) NSString *userId;
 */
- (void)setItem:(HWRecordModel *)item {
    _item = item;
    NSString * operationType = @"收入";
    NSString * operationType_T = @"+";
    UIColor * color = [UIColor redColor];
    if ([item.operationType isEqualToString:@"0"]) {
        operationType = @"支出";
        operationType_T = @"-";
        color = [UIColor greenColor];
    }
    _contenLAB.text = [NSString stringWithFormat:@"%@%@",operationType, item.operationType];
    _numLAB.text = [NSString stringWithFormat:@"%@%.1f",operationType_T, item.token_number];
    _timeLAB.text = [NSString stringWithFormat:@"%@", item.createTime];
}

@end
