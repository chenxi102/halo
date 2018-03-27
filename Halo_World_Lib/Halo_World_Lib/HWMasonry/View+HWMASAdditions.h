//
//  UIView+HWMASAdditions.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASUtilities.h"
#import "HWMASConstraintMaker.h"
#import "HWMASViewAttribute.h"

/**
 *	Provides constraint maker block
 *  and convience methods for creating HWMASViewAttribute which are view + NSLayoutAttribute pairs
 */
@interface HWMAS_VIEW (HWMASAdditions)

/**
 *	following properties return a new HWMASViewAttribute with current view and appropriate NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_left;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_top;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_right;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_bottom;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_leading;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_trailing;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_width;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_height;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_centerX;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_centerY;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_baseline;
@property (nonatomic, strong, readonly) HWMASViewAttribute *(^HWMAS_attribute)(NSLayoutAttribute attr);

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_firstBaseline;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_leftMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_rightMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_topMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_bottomMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_leadingMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_trailingMargin;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_centerXWithinMargins;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_centerYWithinMargins;

#endif

#if (__IPHONE_OS_VERSION_MAX_ALLOWED >= 110000) || (__TV_OS_VERSION_MAX_ALLOWED >= 110000)

@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_safeAreaLayoutGuide API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_safeAreaLayoutGuideTop API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_safeAreaLayoutGuideBottom API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_safeAreaLayoutGuideLeft API_AVAILABLE(ios(11.0),tvos(11.0));
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_safeAreaLayoutGuideRight API_AVAILABLE(ios(11.0),tvos(11.0));

#endif

/**
 *	a key to associate with this view
 */
@property (nonatomic, strong) id HWMAS_key;

/**
 *	Finds the closest common superview between this view and another view
 *
 *	@param	view	other view
 *
 *	@return	returns nil if common superview could not be found
 */
- (instancetype)HWMAS_closestCommonSuperview:(HWMAS_VIEW *)view;

/**
 *  Creates a HWMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created HWMASConstraints
 */
- (NSArray *)HWMAS_makeConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *make))block;

/**
 *  Creates a HWMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  If an existing constraint exists then it will be updated instead.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HWMASConstraints
 */
- (NSArray *)HWMAS_updateConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *make))block;

/**
 *  Creates a HWMASConstraintMaker with the callee view.
 *  Any constraints defined are added to the view or the appropriate superview once the block has finished executing.
 *  All constraints previously installed for the view will be removed.
 *
 *  @param block scope within which you can build up the constraints which you wish to apply to the view.
 *
 *  @return Array of created/updated HWMASConstraints
 */
- (NSArray *)HWMAS_remakeConstraints:(void(NS_NOESCAPE ^)(HWMASConstraintMaker *make))block;

@end
