//
//  HWAssetsDetailTableViewCell.m
//  Halo_World_Lib
//
//  Created by Seth on 2018/4/16.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsDetailTableViewCell.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"

@interface HWAssetsDetailTableViewCell()

@property (nonatomic, strong) UIImageView * iconIMGV;
@property (nonatomic, strong) UILabel * contenLAB;
@property (nonatomic, strong) UILabel * numLAB;

@end

@implementation HWAssetsDetailTableViewCell

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
    
    _iconIMGV = [[UIImageView alloc] initWithImage:[HWUIHelper imageWithCameradispatchName:@"黄色icon"]];
    [self addSubview:_iconIMGV];
    [_iconIMGV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(@0);
        make.left.equalTo(@63);
    }];
    
    _contenLAB = [UILabel new];
    _contenLAB.font = [UIFont fontWithName:@"Helvetica" size:14];
    _contenLAB.textColor = [UIColor whiteColor];
    _contenLAB.textAlignment = NSTextAlignmentLeft;
    _contenLAB.text = @"收到KCASH";
    [self addSubview:_contenLAB];
    [_contenLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@94);
    }];

    _numLAB = [UILabel new];
    _numLAB.font = [UIFont fontWithName:@"Helvetica" size:14];
    _numLAB.textColor = [UIColor whiteColor];
    _numLAB.textAlignment = NSTextAlignmentRight;
    _numLAB.text = @"+5.5";
    [self addSubview:_numLAB];
    [_numLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@169);
    }];
}

- (void)setItem:(HWRecordModel *)item {
    _item = item;
    NSString * operationType = @"收到";
    NSString * operationType_T = @"+";
    if ([item.operationType isEqualToString:@"0"]) {
        operationType = @"支出";
        operationType_T = @"-";
    }
    
    if ([item.tokenType isEqualToString:@"LET"]) {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"黄色icon"];
    }else if ([item.tokenType isEqualToString:@"SSP"]) {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"粉色icon"];
    }else {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"蓝色icon"];
    }
    
    _contenLAB.text = item.tokenType;
    _numLAB.text = [NSString stringWithFormat:@"%@%.4f",operationType_T, item.tokenNumber];
}

@end
