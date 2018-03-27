//
//  NSArray+HWMASAdditions.m
//  
//
//  Created by Daniel Hammond on 11/26/13.
//
//

#import "NSArray+HWMASAdditions.h"
#import "View+HWMASAdditions.h"

@implementation NSArray (HWMASAdditions)

- (NSArray *)HWMAS_makeConstraints:(void(^)(HWMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HWMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HWMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view HWMAS_makeConstraints:block]];
    }
    return constraints;
}

- (NSArray *)HWMAS_updateConstraints:(void(^)(HWMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HWMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HWMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view HWMAS_updateConstraints:block]];
    }
    return constraints;
}

- (NSArray *)HWMAS_remakeConstraints:(void(^)(HWMASConstraintMaker *make))block {
    NSMutableArray *constraints = [NSMutableArray array];
    for (HWMAS_VIEW *view in self) {
        NSAssert([view isKindOfClass:[HWMAS_VIEW class]], @"All objects in the array must be views");
        [constraints addObjectsFromArray:[view HWMAS_remakeConstraints:block]];
    }
    return constraints;
}

- (void)HWMAS_distributeViewsAlongAxis:(HWMASAxisType)axisType withFixedSpacing:(CGFloat)fixedSpacing leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HWMAS_VIEW *tempSuperView = [self HWMAS_commonSuperviewOfViews];
    if (axisType == HWMASAxisTypeHorizontal) {
        HWMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HWMAS_VIEW *v = self[i];
            [v HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
                if (prev) {
                    make.width.equalTo(prev);
                    make.left.equalTo(prev.HWMAS_right).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
    else {
        HWMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HWMAS_VIEW *v = self[i];
            [v HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
                if (prev) {
                    make.height.equalTo(prev);
                    make.top.equalTo(prev.HWMAS_bottom).offset(fixedSpacing);
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }                    
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
                
            }];
            prev = v;
        }
    }
}

- (void)HWMAS_distributeViewsAlongAxis:(HWMASAxisType)axisType withFixedItemLength:(CGFloat)fixedItemLength leadSpacing:(CGFloat)leadSpacing tailSpacing:(CGFloat)tailSpacing {
    if (self.count < 2) {
        NSAssert(self.count>1,@"views to distribute need to bigger than one");
        return;
    }
    
    HWMAS_VIEW *tempSuperView = [self HWMAS_commonSuperviewOfViews];
    if (axisType == HWMASAxisTypeHorizontal) {
        HWMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HWMAS_VIEW *v = self[i];
            [v HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
                make.width.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.right.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.right.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.left.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
    else {
        HWMAS_VIEW *prev;
        for (int i = 0; i < self.count; i++) {
            HWMAS_VIEW *v = self[i];
            [v HWMAS_makeConstraints:^(HWMASConstraintMaker *make) {
                make.height.equalTo(@(fixedItemLength));
                if (prev) {
                    if (i == self.count - 1) {//last one
                        make.bottom.equalTo(tempSuperView).offset(-tailSpacing);
                    }
                    else {
                        CGFloat offset = (1-(i/((CGFloat)self.count-1)))*(fixedItemLength+leadSpacing)-i*tailSpacing/(((CGFloat)self.count-1));
                        make.bottom.equalTo(tempSuperView).multipliedBy(i/((CGFloat)self.count-1)).with.offset(offset);
                    }
                }
                else {//first one
                    make.top.equalTo(tempSuperView).offset(leadSpacing);
                }
            }];
            prev = v;
        }
    }
}

- (HWMAS_VIEW *)HWMAS_commonSuperviewOfViews
{
    HWMAS_VIEW *commonSuperview = nil;
    HWMAS_VIEW *previousView = nil;
    for (id object in self) {
        if ([object isKindOfClass:[HWMAS_VIEW class]]) {
            HWMAS_VIEW *view = (HWMAS_VIEW *)object;
            if (previousView) {
                commonSuperview = [view HWMAS_closestCommonSuperview:commonSuperview];
            } else {
                commonSuperview = view;
            }
            previousView = view;
        }
    }
    NSAssert(commonSuperview, @"Can't constrain views that do not share a common superview. Make sure that all the views in this array have been added into the same view hierarchy.");
    return commonSuperview;
}

@end
