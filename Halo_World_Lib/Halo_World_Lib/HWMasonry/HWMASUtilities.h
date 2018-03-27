//
//  HWMASUtilities.h
//  HWMASonry
//
//  Created by Jonas Budelmann on 19/08/13.
//  Copyright (c) 2013 Jonas Budelmann. All rights reserved.
//

#import <Foundation/Foundation.h>



#if TARGET_OS_IPHONE || TARGET_OS_TV

    #import <UIKit/UIKit.h>
    #define HWMAS_VIEW UIView
    #define HWMAS_VIEW_CONTROLLER UIViewController
    #define HWMASEdgeInsets UIEdgeInsets

    typedef UILayoutPriority HWMASLayoutPriority;
    static const HWMASLayoutPriority HWMASLayoutPriorityRequired = UILayoutPriorityRequired;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultHigh = UILayoutPriorityDefaultHigh;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultMedium = 500;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultLow = UILayoutPriorityDefaultLow;
    static const HWMASLayoutPriority HWMASLayoutPriorityFittingSizeLevel = UILayoutPriorityFittingSizeLevel;

#elif TARGET_OS_MAC

    #import <AppKit/AppKit.h>
    #define HWMAS_VIEW NSView
    #define HWMASEdgeInsets NSEdgeInsets

    typedef NSLayoutPriority HWMASLayoutPriority;
    static const HWMASLayoutPriority HWMASLayoutPriorityRequired = NSLayoutPriorityRequired;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultHigh = NSLayoutPriorityDefaultHigh;
    static const HWMASLayoutPriority HWMASLayoutPriorityDragThatCanResizeWindow = NSLayoutPriorityDragThatCanResizeWindow;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultMedium = 501;
    static const HWMASLayoutPriority HWMASLayoutPriorityWindowSizeStayPut = NSLayoutPriorityWindowSizeStayPut;
    static const HWMASLayoutPriority HWMASLayoutPriorityDragThatCannotResizeWindow = NSLayoutPriorityDragThatCannotResizeWindow;
    static const HWMASLayoutPriority HWMASLayoutPriorityDefaultLow = NSLayoutPriorityDefaultLow;
    static const HWMASLayoutPriority HWMASLayoutPriorityFittingSizeCompression = NSLayoutPriorityFittingSizeCompression;

#endif

/**
 *	Allows you to attach keys to objects matching the variable names passed.
 *
 *  view1.HWMAS_key = @"view1", view2.HWMAS_key = @"view2";
 *
 *  is equivalent to:
 *
 *  HWMASAttachKeys(view1, view2);
 */
#define HWMASAttachKeys(...)                                                        \
    {                                                                             \
        NSDictionary *keyPairs = NSDictionaryOfVariableBindings(__VA_ARGS__);     \
        for (id key in keyPairs.allKeys) {                                        \
            id obj = keyPairs[key];                                               \
            NSAssert([obj respondsToSelector:@selector(setHWMAS_key:)],             \
                     @"Cannot attach HWMAS_key to %@", obj);                        \
            [obj setHWMAS_key:key];                                                 \
        }                                                                         \
    }

/**
 *  Used to create object hashes
 *  Based on http://www.mikeash.com/pyblog/friday-qa-2010-06-18-implementing-equality-and-hashing.html
 */
#define HWMAS_NSUINT_BIT (CHAR_BIT * sizeof(NSUInteger))
#define HWMAS_NSUINTROTATE(val, howmuch) ((((NSUInteger)val) << howmuch) | (((NSUInteger)val) >> (HWMAS_NSUINT_BIT - howmuch)))

/**
 *  Given a scalar or struct value, wraps it in NSValue
 *  Based on EXPObjectify: https://github.com/specta/expecta
 */
static inline id _HWMASBoxValue(const char *type, ...) {
    va_list v;
    va_start(v, type);
    id obj = nil;
    if (strcmp(type, @encode(id)) == 0) {
        id actual = va_arg(v, id);
        obj = actual;
    } else if (strcmp(type, @encode(CGPoint)) == 0) {
        CGPoint actual = (CGPoint)va_arg(v, CGPoint);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(CGSize)) == 0) {
        CGSize actual = (CGSize)va_arg(v, CGSize);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(HWMASEdgeInsets)) == 0) {
        HWMASEdgeInsets actual = (HWMASEdgeInsets)va_arg(v, HWMASEdgeInsets);
        obj = [NSValue value:&actual withObjCType:type];
    } else if (strcmp(type, @encode(double)) == 0) {
        double actual = (double)va_arg(v, double);
        obj = [NSNumber numberWithDouble:actual];
    } else if (strcmp(type, @encode(float)) == 0) {
        float actual = (float)va_arg(v, double);
        obj = [NSNumber numberWithFloat:actual];
    } else if (strcmp(type, @encode(int)) == 0) {
        int actual = (int)va_arg(v, int);
        obj = [NSNumber numberWithInt:actual];
    } else if (strcmp(type, @encode(long)) == 0) {
        long actual = (long)va_arg(v, long);
        obj = [NSNumber numberWithLong:actual];
    } else if (strcmp(type, @encode(long long)) == 0) {
        long long actual = (long long)va_arg(v, long long);
        obj = [NSNumber numberWithLongLong:actual];
    } else if (strcmp(type, @encode(short)) == 0) {
        short actual = (short)va_arg(v, int);
        obj = [NSNumber numberWithShort:actual];
    } else if (strcmp(type, @encode(char)) == 0) {
        char actual = (char)va_arg(v, int);
        obj = [NSNumber numberWithChar:actual];
    } else if (strcmp(type, @encode(bool)) == 0) {
        bool actual = (bool)va_arg(v, int);
        obj = [NSNumber numberWithBool:actual];
    } else if (strcmp(type, @encode(unsigned char)) == 0) {
        unsigned char actual = (unsigned char)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedChar:actual];
    } else if (strcmp(type, @encode(unsigned int)) == 0) {
        unsigned int actual = (unsigned int)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedInt:actual];
    } else if (strcmp(type, @encode(unsigned long)) == 0) {
        unsigned long actual = (unsigned long)va_arg(v, unsigned long);
        obj = [NSNumber numberWithUnsignedLong:actual];
    } else if (strcmp(type, @encode(unsigned long long)) == 0) {
        unsigned long long actual = (unsigned long long)va_arg(v, unsigned long long);
        obj = [NSNumber numberWithUnsignedLongLong:actual];
    } else if (strcmp(type, @encode(unsigned short)) == 0) {
        unsigned short actual = (unsigned short)va_arg(v, unsigned int);
        obj = [NSNumber numberWithUnsignedShort:actual];
    }
    va_end(v);
    return obj;
}

#define HWMASBoxValue(value) _HWMASBoxValue(@encode(__typeof__((value))), (value))
