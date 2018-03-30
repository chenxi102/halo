//
//  HWMASViewConstraint.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASViewAttribute.h"
#import "HWMASConstraint.h"
#import "HWMASLayoutConstraint.h"
#import "HWMASUtilities.h"

/**
 *  A single constraint.
 *  Contains the attributes neccessary for creating a NSLayoutConstraint and adding it to the appropriate view
 */
@interface HWMASViewConstraint : HWMASConstraint <NSCopying>

/**
 *	First item/view and first attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HWMASViewAttribute *firstViewAttribute;

/**
 *	Second item/view and second attribute of the NSLayoutConstraint
 */
@property (nonatomic, strong, readonly) HWMASViewAttribute *secondViewAttribute;

/**
 *	initialises the HWMASViewConstraint with the first part of the equation
 *
 *	@param	firstViewAttribute	view.HWMAS_left, view.HWMAS_width etc.
 *
 *	@return	a new view constraint
 */
- (id)initWithFirstViewAttribute:(HWMASViewAttribute *)firstViewAttribute;

/**
 *  Returns all HWMASViewConstraints installed with this view as a first item.
 *
 *  @param  view  A view to retrieve constraints for.
 *
 *  @return An array of HWMASViewConstraints.
 */
+ (NSArray *)installedConstraintsForView:(HWMAS_VIEW *)view;

@end
