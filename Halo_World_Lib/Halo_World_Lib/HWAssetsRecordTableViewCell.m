//
//  HWAssetsRecordTableViewCell.m
//  Halo_World_Lib
//
//  Created by Seth Chen on 2018/3/30.
//  Copyright © 2018年 JianYiMei. All rights reserved.
//

#import "HWAssetsRecordTableViewCell.h"
#import "HWMasonry.h"
#import "HWUIHelper.h"

@interface HWAssetsRecordTableViewCell()

@property (nonatomic, strong) UIImageView * iconIMGV;
@property (nonatomic, strong) UILabel * contenLAB;
@property (nonatomic, strong) UILabel * timeLAB;
@property (nonatomic, strong) UILabel * numLAB;




@end

@implementation HWAssetsRecordTableViewCell

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
//    _botLine.image =  [HWUIHelper imageWithCameradispatchName:@"条形"];
    _botLine.backgroundColor =  HWHexColor(0x333333);
    [_botLine HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.left.equalTo(@40);
        make.right.bottom.equalTo(@-40);
        make.bottom.equalTo(@0);
        make.height.equalTo(@.3);
    }];
    
    _iconIMGV = [[UIImageView alloc] initWithImage:[HWUIHelper imageWithCameradispatchName:@"黄色icon"]];
    [self addSubview:_iconIMGV];
    [_iconIMGV HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.width.height.equalTo(@20);
        make.centerY.equalTo(@0);
        make.left.equalTo(@40);
    }];
    
    _contenLAB = [UILabel new];
    _contenLAB.font = [UIFont fontWithName:@"Helvetica" size:11];
    _contenLAB.textColor = [UIColor whiteColor];
    _contenLAB.textAlignment = NSTextAlignmentLeft;
    _contenLAB.text = @"收到KCASH";
    [self addSubview:_contenLAB];
    [_contenLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0).offset(-7);
        make.left.equalTo(@80);
    }];
    
    _timeLAB = [UILabel new];
    _timeLAB.font = [UIFont fontWithName:@"Helvetica" size:11];
    _timeLAB.textColor = [UIColor whiteColor];
    _timeLAB.textAlignment = NSTextAlignmentLeft;
    _timeLAB.text = @"4月1号";
    [self addSubview:_timeLAB];
    [_timeLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0).offset(7);
        make.left.equalTo(@80);
    }];
    
    _numLAB = [UILabel new];
    _numLAB.font = [UIFont fontWithName:@"Helvetica" size:14];
    _numLAB.textColor = [UIColor redColor];
    _numLAB.textAlignment = NSTextAlignmentRight;
    _numLAB.text = @"+5.5";
    [self addSubview:_numLAB];
    [_numLAB HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
        make.centerY.equalTo(@0);
        make.left.equalTo(@199);
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
    NSString * operationType = @"收到";
    NSString * operationType_T = @"+";
    UIColor * color = [UIColor greenColor];
    if ([item.operationType isEqualToString:@"0"]) {
        operationType = @"支出";
        operationType_T = @"-";
        color = [UIColor redColor];
    }
    
    if ([item.tokenType isEqualToString:@"LET"]) {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"黄色icon"];
    }else if ([item.tokenType isEqualToString:@"SSP"]) {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"粉色icon"];
    }else {
        _iconIMGV.image = [HWUIHelper imageWithCameradispatchName:@"蓝色icon"];
    }
    
    _contenLAB.text = [NSString stringWithFormat:@"%@%@",operationType, item.tokenType];
    _numLAB.textColor = color;
    _numLAB.text = [NSString stringWithFormat:@"%@%.4f",operationType_T, item.tokenNumber];
    _timeLAB.text = [NSString stringWithFormat:@"%@", [self praseTime:item.createTime]];
}

- (NSString *)praseTime:(NSString *)time
{
    NSString * year = [time substringWithRange:NSMakeRange(0, 4)];
    NSString * mounth = [time substringWithRange:NSMakeRange(4, 2)];
    NSString * day = [time substringWithRange:NSMakeRange(6, 2)];
    
    NSString * hours = [time substringWithRange:NSMakeRange(8, 2)];
    NSString * mins = [time substringWithRange:NSMakeRange(10, 2)];
    NSString * secs = [time substringWithRange:NSMakeRange(12, 2)];
    return [NSString stringWithFormat:@"%d/%d/%d  %d:%d:%d", year.intValue, mounth.intValue, day.intValue, hours.intValue, mins.intValue, secs.intValue];
}

@end
