//
//  RevealSideController.h
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

UIKIT_EXTERN NSString *const RevealSideControllerNeedRevealSideNotification;
UIKIT_EXTERN NSString *const RevealSideControllerNeedHideSideNotification;

// A container controller, has a full-screen central controller and a side controller hidden left.
// Side controller can be revealed by a left-to-right horizontal pan gesture.
@interface RevealSideController : UIViewController

// To be the superview of central controller's view.
@property (weak, nonatomic) IBOutlet UIView *centralView;

// Dim the central view when side view revealed.
@property (weak, nonatomic) IBOutlet UIView *dimView;

// To be the superview of side controller's view.
@property (weak, nonatomic) IBOutlet UIView *sideView;

// Side view's shadow.
@property (weak, nonatomic) IBOutlet UIView *sideShadowView;

// Side Controller, use setter.
@property (strong, nonatomic) UIViewController *sideController;

// Central Controller, use setter.
@property (strong, nonatomic) UIViewController *centralController;

// Reveal side with animation.
- (void)revealSide;

// Hide side with animation.
- (void)hideSide;

@end
