//
//  HWMASConstraintMaker.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASConstraint.h"
#import "HWMASUtilities.h"

typedef NS_OPTIONS(NSInteger, HWMASAttribute) {
    HWMASAttributeLeft = 1 << NSLayoutAttributeLeft,
    HWMASAttributeRight = 1 << NSLayoutAttributeRight,
    HWMASAttributeTop = 1 << NSLayoutAttributeTop,
    HWMASAttributeBottom = 1 << NSLayoutAttributeBottom,
    HWMASAttributeLeading = 1 << NSLayoutAttributeLeading,
    HWMASAttributeTrailing = 1 << NSLayoutAttributeTrailing,
    HWMASAttributeWidth = 1 << NSLayoutAttributeWidth,
    HWMASAttributeHeight = 1 << NSLayoutAttributeHeight,
    HWMASAttributeCenterX = 1 << NSLayoutAttributeCenterX,
    HWMASAttributeCenterY = 1 << NSLayoutAttributeCenterY,
    HWMASAttributeBaseline = 1 << NSLayoutAttributeBaseline,
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    HWMASAttributeFirstBaseline = 1 << NSLayoutAttributeFirstBaseline,
    HWMASAttributeLastBaseline = 1 << NSLayoutAttributeLastBaseline,
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    HWMASAttributeLeftMargin = 1 << NSLayoutAttributeLeftMargin,
    HWMASAttributeRightMargin = 1 << NSLayoutAttributeRightMargin,
    HWMASAttributeTopMargin = 1 << NSLayoutAttributeTopMargin,
    HWMASAttributeBottomMargin = 1 << NSLayoutAttributeBottomMargin,
    HWMASAttributeLeadingMargin = 1 << NSLayoutAttributeLeadingMargin,
    HWMASAttributeTrailingMargin = 1 << NSLayoutAttributeTrailingMargin,
    HWMASAttributeCenterXWithinMargins = 1 << NSLayoutAttributeCenterXWithinMargins,
    HWMASAttributeCenterYWithinMargins = 1 << NSLayoutAttributeCenterYWithinMargins,

#endif
    
};

/**
 *  Provides factory methods for creating HWMASConstraints.
 *  Constraints are collected until they are ready to be installed
 *
 */
@interface HWMASConstraintMaker : NSObject

/**
 *	The following properties return a new HWMASViewConstraint
 *  with the first item set to the makers associated view and the appropriate HWMASViewAttribute
 */
@property (nonatomic, strong, readonly) HWMASConstraint *left;
@property (nonatomic, strong, readonly) HWMASConstraint *top;
@property (nonatomic, strong, readonly) HWMASConstraint *right;
@property (nonatomic, strong, readonly) HWMASConstraint *bottom;
@property (nonatomic, strong, readonly) HWMASConstraint *leading;
@property (nonatomic, strong, readonly) HWMASConstraint *trailing;
@property (nonatomic, strong, readonly) HWMASConstraint *width;
@property (nonatomic, strong, readonly) HWMASConstraint *height;
@property (nonatomic, strong, readonly) HWMASConstraint *centerX;
@property (nonatomic, strong, readonly) HWMASConstraint *centerY;
@property (nonatomic, strong, readonly) HWMASConstraint *baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) HWMASConstraint *firstBaseline;
@property (nonatomic, strong, readonly) HWMASConstraint *lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) HWMASConstraint *leftMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *rightMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *topMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *bottomMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *leadingMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *trailingMargin;
@property (nonatomic, strong, readonly) HWMASConstraint *centerXWithinMargins;
@property (nonatomic, strong, readonly) HWMASConstraint *centerYWithinMargins;

#endif

/**
 *  Returns a block which creates a new HWMASCompositeConstraint with the first item set
 *  to the makers associated view and children corresponding to the set bits in the
 *  HWMASAttribute parameter. Combine multiple attributes via binary-or.
 */
@property (nonatomic, strong, readonly) HWMASConstraint *(^attributes)(HWMASAttribute attrs);

/**
 *	Creates a HWMASCompositeConstraint with type HWMASCompositeConstraintTypeEdges
 *  which generates the appropriate HWMASViewConstraint children (top, left, bottom, right)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HWMASConstraint *edges;

/**
 *	Creates a HWMASCompositeConstraint with type HWMASCompositeConstraintTypeSize
 *  which generates the appropriate HWMASViewConstraint children (width, height)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HWMASConstraint *size;

/**
 *	Creates a HWMASCompositeConstraint with type HWMASCompositeConstraintTypeCenter
 *  which generates the appropriate HWMASViewConstraint children (centerX, centerY)
 *  with the first item set to the makers associated view
 */
@property (nonatomic, strong, readonly) HWMASConstraint *center;

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *  Whether or not to remove existing constraints prior to installing
 */
@property (nonatomic, assign) BOOL removeExisting;

/**
 *	initialises the maker with a default view
 *
 *	@param	view	any HWMASConstraint are created with this view as the first item
 *
 *	@return	a new HWMASConstraintMaker
 */
- (id)initWithView:(HWMAS_VIEW *)view;

/**
 *	Calls install method on any HWMASConstraints which have been created by this maker
 *
 *	@return	an array of all the installed HWMASConstraints
 */
- (NSArray *)install;

- (HWMASConstraint * (^)(dispatch_block_t))group;

@end
