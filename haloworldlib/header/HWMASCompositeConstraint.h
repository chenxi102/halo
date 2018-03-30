//
//  HWMASCompositeConstraint.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 21/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASConstraint.h"
#import "HWMASUtilities.h"

/**
 *	A group of HWMASConstraint objects
 */
@interface HWMASCompositeConstraint : HWMASConstraint

/**
 *	Creates a composite with a predefined array of children
 *
 *	@param	children	child HWMASConstraints
 *
 *	@return	a composite constraint
 */
- (id)initWithChildren:(NSArray *)children;

@end
