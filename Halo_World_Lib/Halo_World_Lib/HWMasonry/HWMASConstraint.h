//
//  HWMASConstraint.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASUtilities.h"

/**
 *	Enables Constraints to be created with chainable syntax
 *  Constraint can represent single NSLayoutConstraint (HWMASViewConstraint) 
 *  or a group of NSLayoutConstraints (HWMASComposisteConstraint)
 */
@interface HWMASConstraint : NSObject

// Chaining Support

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (HWMASConstraint * (^)(HWMASEdgeInsets insets))insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (HWMASConstraint * (^)(CGFloat inset))inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (HWMASConstraint * (^)(CGSize offset))sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (HWMASConstraint * (^)(CGPoint offset))centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (HWMASConstraint * (^)(CGFloat offset))offset;

/**
 *  Modifies the NSLayoutConstraint constant based on a value type
 */
- (HWMASConstraint * (^)(NSValue *value))valueOffset;

/**
 *	Sets the NSLayoutConstraint multiplier property
 */
- (HWMASConstraint * (^)(CGFloat multiplier))multipliedBy;

/**
 *	Sets the NSLayoutConstraint multiplier to 1.0/dividedBy
 */
- (HWMASConstraint * (^)(CGFloat divider))dividedBy;

/**
 *	Sets the NSLayoutConstraint priority to a float or HWMASLayoutPriority
 */
- (HWMASConstraint * (^)(HWMASLayoutPriority priority))priority;

/**
 *	Sets the NSLayoutConstraint priority to HWMASLayoutPriorityLow
 */
- (HWMASConstraint * (^)(void))priorityLow;

/**
 *	Sets the NSLayoutConstraint priority to HWMASLayoutPriorityMedium
 */
- (HWMASConstraint * (^)(void))priorityMedium;

/**
 *	Sets the NSLayoutConstraint priority to HWMASLayoutPriorityHigh
 */
- (HWMASConstraint * (^)(void))priorityHigh;

/**
 *	Sets the constraint relation to NSLayoutRelationEqual
 *  returns a block which accepts one of the following:
 *    HWMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HWMASConstraint * (^)(id attr))equalTo;

/**
 *	Sets the constraint relation to NSLayoutRelationGreaterThanOrEqual
 *  returns a block which accepts one of the following:
 *    HWMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HWMASConstraint * (^)(id attr))greaterThanOrEqualTo;

/**
 *	Sets the constraint relation to NSLayoutRelationLessThanOrEqual
 *  returns a block which accepts one of the following:
 *    HWMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HWMASConstraint * (^)(id attr))lessThanOrEqualTo;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HWMASConstraint *)with;

/**
 *	Optional semantic property which has no effect but improves the readability of constraint
 */
- (HWMASConstraint *)and;

/**
 *	Creates a new HWMASCompositeConstraint with the called attribute and reciever
 */
- (HWMASConstraint *)left;
- (HWMASConstraint *)top;
- (HWMASConstraint *)right;
- (HWMASConstraint *)bottom;
- (HWMASConstraint *)leading;
- (HWMASConstraint *)trailing;
- (HWMASConstraint *)width;
- (HWMASConstraint *)height;
- (HWMASConstraint *)centerX;
- (HWMASConstraint *)centerY;
- (HWMASConstraint *)baseline;

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (HWMASConstraint *)firstBaseline;
- (HWMASConstraint *)lastBaseline;

#endif

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (HWMASConstraint *)leftMargin;
- (HWMASConstraint *)rightMargin;
- (HWMASConstraint *)topMargin;
- (HWMASConstraint *)bottomMargin;
- (HWMASConstraint *)leadingMargin;
- (HWMASConstraint *)trailingMargin;
- (HWMASConstraint *)centerXWithinMargins;
- (HWMASConstraint *)centerYWithinMargins;

#endif


/**
 *	Sets the constraint debug name
 */
- (HWMASConstraint * (^)(id key))key;

// NSLayoutConstraint constant Setters
// for use outside of HWMAS_updateConstraints/HWMAS_makeConstraints blocks

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInsets:(HWMASEdgeInsets)insets;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeTop, NSLayoutAttributeLeft, NSLayoutAttributeBottom, NSLayoutAttributeRight
 */
- (void)setInset:(CGFloat)inset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeWidth, NSLayoutAttributeHeight
 */
- (void)setSizeOffset:(CGSize)sizeOffset;

/**
 *	Modifies the NSLayoutConstraint constant,
 *  only affects HWMASConstraints in which the first item's NSLayoutAttribute is one of the following
 *  NSLayoutAttributeCenterX, NSLayoutAttributeCenterY
 */
- (void)setCenterOffset:(CGPoint)centerOffset;

/**
 *	Modifies the NSLayoutConstraint constant
 */
- (void)setOffset:(CGFloat)offset;


// NSLayoutConstraint Installation support

#if TARGET_OS_MAC && !(TARGET_OS_IPHONE || TARGET_OS_TV)
/**
 *  Whether or not to go through the animator proxy when modifying the constraint
 */
@property (nonatomic, copy, readonly) HWMASConstraint *animator;
#endif

/**
 *  Activates an NSLayoutConstraint if it's supported by an OS. 
 *  Invokes install otherwise.
 */
- (void)activate;

/**
 *  Deactivates previously installed/activated NSLayoutConstraint.
 */
- (void)deactivate;

/**
 *	Creates a NSLayoutConstraint and adds it to the appropriate view.
 */
- (void)install;

/**
 *	Removes previously installed NSLayoutConstraint
 */
- (void)uninstall;

@end


/**
 *  Convenience auto-boxing macros for HWMASConstraint methods.
 *
 *  Defining HWMAS_SHORTHAND_GLOBALS will turn on auto-boxing for default syntax.
 *  A potential drawback of this is that the unprefixed macros will appear in global scope.
 */
#define HWMAS_equalTo(...)                 equalTo(HWMASBoxValue((__VA_ARGS__)))
#define HWMAS_greaterThanOrEqualTo(...)    greaterThanOrEqualTo(HWMASBoxValue((__VA_ARGS__)))
#define HWMAS_lessThanOrEqualTo(...)       lessThanOrEqualTo(HWMASBoxValue((__VA_ARGS__)))

#define HWMAS_offset(...)                  valueOffset(HWMASBoxValue((__VA_ARGS__)))


#ifdef HWMAS_SHORTHAND_GLOBALS

#define equalTo(...)                     HWMAS_equalTo(__VA_ARGS__)
#define greaterThanOrEqualTo(...)        HWMAS_greaterThanOrEqualTo(__VA_ARGS__)
#define lessThanOrEqualTo(...)           HWMAS_lessThanOrEqualTo(__VA_ARGS__)

#define offset(...)                      HWMAS_offset(__VA_ARGS__)

#endif


@interface HWMASConstraint (AutoboxingSupport)

/**
 *  Aliases to corresponding relation methods (for shorthand macros)
 *  Also needed to aid autocompletion
 */
- (HWMASConstraint * (^)(id attr))HWMAS_equalTo;
- (HWMASConstraint * (^)(id attr))HWMAS_greaterThanOrEqualTo;
- (HWMASConstraint * (^)(id attr))HWMAS_lessThanOrEqualTo;

/**
 *  A dummy method to aid autocompletion
 */
- (HWMASConstraint * (^)(id offset))HWMAS_offset;

@end
