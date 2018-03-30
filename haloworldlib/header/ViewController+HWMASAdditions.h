//
//  UIViewController+HWMASAdditions.h
//  HWMASonry
//
//  Created by Craig Siemens on 2015-06-23.
//
//

#import "HWMASUtilities.h"
#import "HWMASConstraintMaker.h"
#import "HWMASViewAttribute.h"

#ifdef HWMAS_VIEW_CONTROLLER

@interface HWMAS_VIEW_CONTROLLER (HWMASAdditions)

/**
 *	following properties return a new HWMASViewAttribute with appropriate UILayoutGuide and NSLayoutAttribute
 */
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_topLayoutGuide;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_bottomLayoutGuide;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_topLayoutGuideTop;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_topLayoutGuideBottom;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_bottomLayoutGuideTop;
@property (nonatomic, strong, readonly) HWMASViewAttribute *HWMAS_bottomLayoutGuideBottom;


@end

#endif
