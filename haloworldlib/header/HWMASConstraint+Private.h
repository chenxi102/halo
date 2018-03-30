//
//  HWMASConstraint+Private.h
//  HWMASonry
//
//  Created by Nick Tymchenko on 29/04/14.
//  Copyright (c) 2014 cloudling. All rights reserved.
//

#import "HWMASConstraint.h"

@protocol HWMASConstraintDelegate;


@interface HWMASConstraint ()

/**
 *  Whether or not to check for an existing constraint instead of adding constraint
 */
@property (nonatomic, assign) BOOL updateExisting;

/**
 *	Usually HWMASConstraintMaker but could be a parent HWMASConstraint
 */
@property (nonatomic, weak) id<HWMASConstraintDelegate> delegate;

/**
 *  Based on a provided value type, is equal to calling:
 *  NSNumber - setOffset:
 *  NSValue with CGPoint - setPointOffset:
 *  NSValue with CGSize - setSizeOffset:
 *  NSValue with HWMASEdgeInsets - setInsets:
 */
- (void)setLayoutConstantWithValue:(NSValue *)value;

@end


@interface HWMASConstraint (Abstract)

/**
 *	Sets the constraint relation to given NSLayoutRelation
 *  returns a block which accepts one of the following:
 *    HWMASViewAttribute, UIView, NSValue, NSArray
 *  see readme for more details.
 */
- (HWMASConstraint * (^)(id, NSLayoutRelation))equalToWithRelation;

/**
 *	Override to set a custom chaining behaviour
 */
- (HWMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end


@protocol HWMASConstraintDelegate <NSObject>

/**
 *	Notifies the delegate when the constraint needs to be replaced with another constraint. For example
 *  A HWMASViewConstraint may turn into a HWMASCompositeConstraint when an array is passed to one of the equality blocks
 */
- (void)constraint:(HWMASConstraint *)constraint shouldBeReplacedWithConstraint:(HWMASConstraint *)replacementConstraint;

- (HWMASConstraint *)constraint:(HWMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute;

@end
