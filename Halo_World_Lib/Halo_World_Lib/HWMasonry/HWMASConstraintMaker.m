//
//  HWMASConstraintMaker.m
//  HWMASonry
//
//  Created by Jonas Budelmann on 20/07/13.
//  Copyright (c) 2013 cloudling. All rights reserved.
//

#import "HWMASConstraintMaker.h"
#import "HWMASViewConstraint.h"
#import "HWMASCompositeConstraint.h"
#import "HWMASConstraint+Private.h"
#import "HWMASViewAttribute.h"
#import "View+HWMASAdditions.h"

@interface HWMASConstraintMaker () <HWMASConstraintDelegate>

@property (nonatomic, weak) HWMAS_VIEW *view;
@property (nonatomic, strong) NSMutableArray *constraints;

@end

@implementation HWMASConstraintMaker

- (id)initWithView:(HWMAS_VIEW *)view {
    self = [super init];
    if (!self) return nil;
    
    self.view = view;
    self.constraints = NSMutableArray.new;
    
    return self;
}

- (NSArray *)install {
    if (self.removeExisting) {
        NSArray *installedConstraints = [HWMASViewConstraint installedConstraintsForView:self.view];
        for (HWMASConstraint *constraint in installedConstraints) {
            [constraint uninstall];
        }
    }
    NSArray *constraints = self.constraints.copy;
    for (HWMASConstraint *constraint in constraints) {
        constraint.updateExisting = self.updateExisting;
        [constraint install];
    }
    [self.constraints removeAllObjects];
    return constraints;
}

#pragma mark - HWMASConstraintDelegate

- (void)constraint:(HWMASConstraint *)constraint shouldBeReplacedWithConstraint:(HWMASConstraint *)replacementConstraint {
    NSUInteger index = [self.constraints indexOfObject:constraint];
    NSAssert(index != NSNotFound, @"Could not find constraint %@", constraint);
    [self.constraints replaceObjectAtIndex:index withObject:replacementConstraint];
}

- (HWMASConstraint *)constraint:(HWMASConstraint *)constraint addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    HWMASViewAttribute *viewAttribute = [[HWMASViewAttribute alloc] initWithView:self.view layoutAttribute:layoutAttribute];
    HWMASViewConstraint *newConstraint = [[HWMASViewConstraint alloc] initWithFirstViewAttribute:viewAttribute];
    if ([constraint isKindOfClass:HWMASViewConstraint.class]) {
        //replace with composite constraint
        NSArray *children = @[constraint, newConstraint];
        HWMASCompositeConstraint *compositeConstraint = [[HWMASCompositeConstraint alloc] initWithChildren:children];
        compositeConstraint.delegate = self;
        [self constraint:constraint shouldBeReplacedWithConstraint:compositeConstraint];
        return compositeConstraint;
    }
    if (!constraint) {
        newConstraint.delegate = self;
        [self.constraints addObject:newConstraint];
    }
    return newConstraint;
}

- (HWMASConstraint *)addConstraintWithAttributes:(HWMASAttribute)attrs {
    __unused HWMASAttribute anyAttribute = (HWMASAttributeLeft | HWMASAttributeRight | HWMASAttributeTop | HWMASAttributeBottom | HWMASAttributeLeading
                                          | HWMASAttributeTrailing | HWMASAttributeWidth | HWMASAttributeHeight | HWMASAttributeCenterX
                                          | HWMASAttributeCenterY | HWMASAttributeBaseline
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
                                          | HWMASAttributeFirstBaseline | HWMASAttributeLastBaseline
#endif
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
                                          | HWMASAttributeLeftMargin | HWMASAttributeRightMargin | HWMASAttributeTopMargin | HWMASAttributeBottomMargin
                                          | HWMASAttributeLeadingMargin | HWMASAttributeTrailingMargin | HWMASAttributeCenterXWithinMargins
                                          | HWMASAttributeCenterYWithinMargins
#endif
                                          );
    
    NSAssert((attrs & anyAttribute) != 0, @"You didn't pass any attribute to make.attributes(...)");
    
    NSMutableArray *attributes = [NSMutableArray array];
    
    if (attrs & HWMASAttributeLeft) [attributes addObject:self.view.HWMAS_left];
    if (attrs & HWMASAttributeRight) [attributes addObject:self.view.HWMAS_right];
    if (attrs & HWMASAttributeTop) [attributes addObject:self.view.HWMAS_top];
    if (attrs & HWMASAttributeBottom) [attributes addObject:self.view.HWMAS_bottom];
    if (attrs & HWMASAttributeLeading) [attributes addObject:self.view.HWMAS_leading];
    if (attrs & HWMASAttributeTrailing) [attributes addObject:self.view.HWMAS_trailing];
    if (attrs & HWMASAttributeWidth) [attributes addObject:self.view.HWMAS_width];
    if (attrs & HWMASAttributeHeight) [attributes addObject:self.view.HWMAS_height];
    if (attrs & HWMASAttributeCenterX) [attributes addObject:self.view.HWMAS_centerX];
    if (attrs & HWMASAttributeCenterY) [attributes addObject:self.view.HWMAS_centerY];
    if (attrs & HWMASAttributeBaseline) [attributes addObject:self.view.HWMAS_baseline];
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)
    
    if (attrs & HWMASAttributeFirstBaseline) [attributes addObject:self.view.HWMAS_firstBaseline];
    if (attrs & HWMASAttributeLastBaseline) [attributes addObject:self.view.HWMAS_lastBaseline];
    
#endif
    
#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)
    
    if (attrs & HWMASAttributeLeftMargin) [attributes addObject:self.view.HWMAS_leftMargin];
    if (attrs & HWMASAttributeRightMargin) [attributes addObject:self.view.HWMAS_rightMargin];
    if (attrs & HWMASAttributeTopMargin) [attributes addObject:self.view.HWMAS_topMargin];
    if (attrs & HWMASAttributeBottomMargin) [attributes addObject:self.view.HWMAS_bottomMargin];
    if (attrs & HWMASAttributeLeadingMargin) [attributes addObject:self.view.HWMAS_leadingMargin];
    if (attrs & HWMASAttributeTrailingMargin) [attributes addObject:self.view.HWMAS_trailingMargin];
    if (attrs & HWMASAttributeCenterXWithinMargins) [attributes addObject:self.view.HWMAS_centerXWithinMargins];
    if (attrs & HWMASAttributeCenterYWithinMargins) [attributes addObject:self.view.HWMAS_centerYWithinMargins];
    
#endif
    
    NSMutableArray *children = [NSMutableArray arrayWithCapacity:attributes.count];
    
    for (HWMASViewAttribute *a in attributes) {
        [children addObject:[[HWMASViewConstraint alloc] initWithFirstViewAttribute:a]];
    }
    
    HWMASCompositeConstraint *constraint = [[HWMASCompositeConstraint alloc] initWithChildren:children];
    constraint.delegate = self;
    [self.constraints addObject:constraint];
    return constraint;
}

#pragma mark - standard Attributes

- (HWMASConstraint *)addConstraintWithLayoutAttribute:(NSLayoutAttribute)layoutAttribute {
    return [self constraint:nil addConstraintWithLayoutAttribute:layoutAttribute];
}

- (HWMASConstraint *)left {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeft];
}

- (HWMASConstraint *)top {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTop];
}

- (HWMASConstraint *)right {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRight];
}

- (HWMASConstraint *)bottom {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottom];
}

- (HWMASConstraint *)leading {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeading];
}

- (HWMASConstraint *)trailing {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailing];
}

- (HWMASConstraint *)width {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeWidth];
}

- (HWMASConstraint *)height {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeHeight];
}

- (HWMASConstraint *)centerX {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterX];
}

- (HWMASConstraint *)centerY {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterY];
}

- (HWMASConstraint *)baseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBaseline];
}

- (HWMASConstraint *(^)(HWMASAttribute))attributes {
    return ^(HWMASAttribute attrs){
        return [self addConstraintWithAttributes:attrs];
    };
}

#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000) || (__MAC_OS_X_VERSION_MIN_REQUIRED >= 101100)

- (HWMASConstraint *)firstBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeFirstBaseline];
}

- (HWMASConstraint *)lastBaseline {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLastBaseline];
}

#endif


#if (__IPHONE_OS_VERSION_MIN_REQUIRED >= 80000) || (__TV_OS_VERSION_MIN_REQUIRED >= 9000)

- (HWMASConstraint *)leftMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeftMargin];
}

- (HWMASConstraint *)rightMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeRightMargin];
}

- (HWMASConstraint *)topMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTopMargin];
}

- (HWMASConstraint *)bottomMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeBottomMargin];
}

- (HWMASConstraint *)leadingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeLeadingMargin];
}

- (HWMASConstraint *)trailingMargin {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeTrailingMargin];
}

- (HWMASConstraint *)centerXWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterXWithinMargins];
}

- (HWMASConstraint *)centerYWithinMargins {
    return [self addConstraintWithLayoutAttribute:NSLayoutAttributeCenterYWithinMargins];
}

#endif


#pragma mark - composite Attributes

- (HWMASConstraint *)edges {
    return [self addConstraintWithAttributes:HWMASAttributeTop | HWMASAttributeLeft | HWMASAttributeRight | HWMASAttributeBottom];
}

- (HWMASConstraint *)size {
    return [self addConstraintWithAttributes:HWMASAttributeWidth | HWMASAttributeHeight];
}

- (HWMASConstraint *)center {
    return [self addConstraintWithAttributes:HWMASAttributeCenterX | HWMASAttributeCenterY];
}

#pragma mark - grouping

- (HWMASConstraint *(^)(dispatch_block_t group))group {
    return ^id(dispatch_block_t group) {
        NSInteger previousCount = self.constraints.count;
        group();

        NSArray *children = [self.constraints subarrayWithRange:NSMakeRange(previousCount, self.constraints.count - previousCount)];
        HWMASCompositeConstraint *constraint = [[HWMASCompositeConstraint alloc] initWithChildren:children];
        constraint.delegate = self;
        return constraint;
    };
}

@end
