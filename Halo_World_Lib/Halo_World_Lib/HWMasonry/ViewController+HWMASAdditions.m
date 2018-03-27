//
//  UIViewController+HWMASAdditions.m
//  HWMASonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "ViewController+HWMASAdditions.h"

#ifdef HWMAS_VIEW_CONTROLLER

@implementation HWMAS_VIEW_CONTROLLER (HWMASAdditions)

- (HWMASViewAttribute *)HWMAS_topLayoutGuide {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}
- (HWMASViewAttribute *)HWMAS_topLayoutGuideTop {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HWMASViewAttribute *)HWMAS_topLayoutGuideBottom {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.topLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}

- (HWMASViewAttribute *)HWMAS_bottomLayoutGuide {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HWMASViewAttribute *)HWMAS_bottomLayoutGuideTop {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeTop];
}
- (HWMASViewAttribute *)HWMAS_bottomLayoutGuideBottom {
    return [[HWMASViewAttribute alloc] initWithView:self.view item:self.bottomLayoutGuide layoutAttribute:NSLayoutAttributeBottom];
}



@end

#endif
