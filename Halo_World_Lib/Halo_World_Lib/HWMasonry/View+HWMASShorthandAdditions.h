//
//  UIView+HWMASShorthandAdditions.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "View+HWMASAdditions.h"

#ifdef HWMAS_SHORTHAND

/**
 *	Shorthand view additions without the 'HWMAS_' prefixes,
 *  only enabled if HWMAS_SHORTHAND is defined
 */
@interface HWMAS_VIEW (HWMASShorthandAdditions)

@property (nonatomic, strong, readonly) HWMASViewAttribute *left;
@property (nonatomic, strong, readonly) HWMASViewAttribute *top;
@property (nonatomic, strong, readonly) HWMASViewAttribute *right;
@property (nonatomic, strong, readonly) HWMASViewAttribute *bottom;
@property (nonatomic, strong, readonly) HWMASViewAttribute *leading;
@property (nonatomic, strong, readonly) HWMASViewAttribute *trailing;
@property (nonatomic, strong, readonly) HWMASViewAttribute *width;
@property (nonatomic, strong, readonly) HWMASViewAttribute *height;
@property (nonatomic, strong, readonly) HWMASViewAttribute *centerX;
@property (nonatomic, strong, readonly) HWMASViewAttribute *centerY;
@property (nonatomic, strong, readonly) HWMASViewAttribute *baseline;
@property (nonatomic, strong, readonly) HWMASViewAttribute *(^attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) HWMASViewAttribute *firstBaseline;
@property (nonatomic, strong, readonly) HWMASViewAttribute *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) HWMASViewAttribute *leftMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *rightMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *topMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *bottomMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *leadingMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *trailingMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *centerXWithinMargins;
@property (nonatomic, strong, readonly) HWMASViewAttribute *centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) HWMASViewAttribute *safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

- (NSArray *)makeConstraints:(void(^)(HWMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(HWMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(HWMASConstraintMaker *make))block;

@end

#define HWMAS_ATTR_FORWARD(attr)  \
- (HWMASViewAttribute *)attr {    \
    return [self HWMAS_##attr];   \
}

@implementation HWMAS_VIEW (HWMASShorthandAdditions)

HWMAS_ATTR_FORWARD(top);
HWMAS_ATTR_FORWARD(left);
HWMAS_ATTR_FORWARD(bottom);
HWMAS_ATTR_FORWARD(right);
HWMAS_ATTR_FORWARD(leading);
HWMAS_ATTR_FORWARD(trailing);
HWMAS_ATTR_FORWARD(width);
HWMAS_ATTR_FORWARD(height);
HWMAS_ATTR_FORWARD(centerX);
HWMAS_ATTR_FORWARD(centerY);
HWMAS_ATTR_FORWARD(baseline);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

HWMAS_ATTR_FORWARD(firstBaseline);
HWMAS_ATTR_FORWARD(lastBaseline);

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

HWMAS_ATTR_FORWARD(leftMargin);
HWMAS_ATTR_FORWARD(rightMargin);
HWMAS_ATTR_FORWARD(topMargin);
HWMAS_ATTR_FORWARD(bottomMargin);
HWMAS_ATTR_FORWARD(leadingMargin);
HWMAS_ATTR_FORWARD(trailingMargin);
HWMAS_ATTR_FORWARD(centerXWithinMargins);
HWMAS_ATTR_FORWARD(centerYWithinMargins);

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

HWMAS_ATTR_FORWARD(safeAreaLayoutGuideTop);
HWMAS_ATTR_FORWARD(safeAreaLayoutGuideBottom);
HWMAS_ATTR_FORWARD(safeAreaLayoutGuideLeft);
HWMAS_ATTR_FORWARD(safeAreaLayoutGuideRight);

#endif

- (HWMASViewAttribute *(^)(NSLayoutAttribute))attribute {
    return [self HWMAS_attribute];
}

- (NSArray *)makeConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *))block {
    return [self HWMAS_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *))block {
    return [self HWMAS_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *))block {
    return [self HWMAS_remakeConstraints:block];
}

@end

#endif
