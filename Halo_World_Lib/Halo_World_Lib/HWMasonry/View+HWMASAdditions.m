//
//  UIView+HWMASAdditions.m
//  HWMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "View+HWMASAdditions.h"
#import <objc/runtime.h>

@implementation HWMAS_VIEW (HWMASAdditions)

- (NSArray *)HWMAS_makeConstraints:(void(^)(HWMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HWMASConstraintMaker *constraintMaker = [[HWMASConstraintMaker alloc] initWithView:self];
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)HWMAS_updateConstraints:(void(^)(HWMASConstraintMaker *))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HWMASConstraintMaker *constraintMaker = [[HWMASConstraintMaker alloc] initWithView:self];
    constraintMaker.updateExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

- (NSArray *)HWMAS_remakeConstraints:(void(^)(HWMASConstraintMaker *make))block {
    self.translatesAutoresizingMaskIntoConstraints = NO;
    HWMASConstraintMaker *constraintMaker = [[HWMASConstraintMaker alloc] initWithView:self];
    constraintMaker.removeExisting = YES;
    block(constraintMaker);
    return [constraintMaker install];
}

#pragma mark - NSLayoutAttribute properties

- (HWMASViewAttribute *)HWMAS_left {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeft];
}

- (HWMASViewAttribute *)HWMAS_top {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTop];
}

- (HWMASViewAttribute *)HWMAS_right {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRight];
}

- (HWMASViewAttribute *)HWMAS_bottom {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottom];
}

- (HWMASViewAttribute *)HWMAS_leading {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeading];
}

- (HWMASViewAttribute *)HWMAS_trailing {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailing];
}

- (HWMASViewAttribute *)HWMAS_width {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeWidth];
}

- (HWMASViewAttribute *)HWMAS_height {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeHeight];
}

- (HWMASViewAttribute *)HWMAS_centerX {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterX];
}

- (HWMASViewAttribute *)HWMAS_centerY {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterY];
}

- (HWMASViewAttribute *)HWMAS_baseline {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBaseline];
}

- (HWMASViewAttribute *(^)(NSLayoutAttribute))HWMAS_attribute
{
    return ^(NSLayoutAttribute attr) {
        return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:attr];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (HWMASViewAttribute *)HWMAS_firstBaseline {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeFirstBaseline];
}
- (HWMASViewAttribute *)HWMAS_lastBaseline {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (HWMASViewAttribute *)HWMAS_leftMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HWMASViewAttribute *)HWMAS_rightMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeRightMargin];
}

- (HWMASViewAttribute *)HWMAS_topMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTopMargin];
}

- (HWMASViewAttribute *)HWMAS_bottomMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HWMASViewAttribute *)HWMAS_leadingMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HWMASViewAttribute *)HWMAS_trailingMargin {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HWMASViewAttribute *)HWMAS_centerXWithinMargins {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HWMASViewAttribute *)HWMAS_centerYWithinMargins {
    return [[HWMASViewAttribute alloc] initWithView:self layoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

- (HWMASViewAttribute *)HWMAS_safeAreaLayoutGuide {
    return [[HWMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (HWMASViewAttribute *)HWMAS_safeAreaLayoutGuideTop {
    return [[HWMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HWMASViewAttribute *)HWMAS_safeAreaLayoutGuideBottom {
    return [[HWMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (HWMASViewAttribute *)HWMAS_safeAreaLayoutGuideLeft {
    return [[HWMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeLeft];
}
- (HWMASViewAttribute *)HWMAS_safeAreaLayoutGuideRight {
    return [[HWMASViewAttribute alloc] initWithView:self item:self.safeAreaLayoutGuide layoutAttribute:NSLayoutAttributeRight];
}

#endif

#pragma mark - associated properties

- (id)HWMAS_key {
    return objc_getAssociatedObject(self, @selector(HWMAS_key));
}

- (void)setHWMAS_key:(id)key {
    objc_setAssociatedObject(self, @selector(HWMAS_key), key, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

#pragma mark - heirachy

- (instancetype)HWMAS_closestCommonSuperview:(HWMAS_VIEW *)view {
    HWMAS_VIEW *closestCommonSuperview = nil;

    HWMAS_VIEW *secondViewSuperview = view;
    while (!closestCommonSuperview && secondViewSuperview) {
        HWMAS_VIEW *firstViewSuperview = self;
        while (!closestCommonSuperview && firstViewSuperview) {
            if (secondViewSuperview == firstViewSuperview) {
                closestCommonSuperview = secondViewSuperview;
            }
            firstViewSuperview = firstViewSuperview.superview;
        }
        secondViewSuperview = secondViewSuperview.superview;
    }
    return closestCommonSuperview;
}

@end
