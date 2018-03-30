//
//  NSArray+HWMASShorthandAdditions.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 22/07/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import "NSArray+HWMASAdditions.h"

#ifdef HWMAS_SHORTHAND

/**
 *	Shorthand array additions without the 'HWMAS_' prefixes,
 *  only enabled if HWMAS_SHORTHAND is defined
 */
@interface NSArray (HWMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(HWMASConstraintMaker *make))block;
- (NSArray *)updateConstraints:(void(^)(HWMASConstraintMaker *make))block;
- (NSArray *)remakeConstraints:(void(^)(HWMASConstraintMaker *make))block;

@end

@implementation NSArray (HWMASShorthandAdditions)

- (NSArray *)makeConstraints:(void(^)(HWMASConstraintMaker *))block {
    return [self HWMAS_makeConstraints:block];
}

- (NSArray *)updateConstraints:(void(^)(HWMASConstraintMaker *))block {
    return [self HWMAS_updateConstraints:block];
}

- (NSArray *)remakeConstraints:(void(^)(HWMASConstraintMaker *))block {
    return [self HWMAS_remakeConstraints:block];
}

@end

#endif
