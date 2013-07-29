//
//  RevealSideController.m
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "RevealSideController.h"
#import "Appearance.h"
#import "RevealSideController.h"
#import "SDirectionPanGestureRecognizer.h"
#import "ToolKitController.h"
#import "ReaderController.h"

NSString *const RevealSideControllerNeedRevealSideNotification = @"RevealSideControllerNeedRevealSideNotification";
NSString *const RevealSideControllerNeedHideSideNotification = @"RevealSideControllerNeedHideSideNotification";

typedef NS_ENUM(NSInteger, RevealSideControllerSideState)
{
    RevealSideControllerSideStateHidden,
    RevealSideControllerSideStateRevealed,
    RevealSideControllerSideStateHiding,
    RevealSideControllerSideStateRevealing
};

@interface RevealSideController ()

// Indicate the side's state.
@property (nonatomic, assign) RevealSideControllerSideState sideState;

// The Horizontal Pan Gesture Recognizer.
@property (nonatomic, strong) SDirectionPanGestureRecognizer *horizontalPan;

@end

@implementation RevealSideController

#pragma mark - Life Cycle

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup Gesture Recognizer.
    self.horizontalPan = [[SDirectionPanGestureRecognizer alloc] initWithTarget:self
                                                                         action:@selector(handleHorizontalPan:)
                                                                      direction:SDirectionPanGestureRecognizerDirectionHorizontal];
    [self.view addGestureRecognizer:self.horizontalPan];
    // Default side state.
    self.sideState = RevealSideControllerSideStateRevealed;
    self.sideController = [[ToolKitController alloc] initWithNibName:nil bundle:nil];
    // Side View shadow
    UIImage *SideShadow = [[Appearance share] imageForSideViewShadow];
    self.sideShadowView.layer.contents = (id)[SideShadow CGImage];
    // Central Controller
    self.centralController = [[ReaderController alloc] initWithNibName:nil bundle:nil];
    // Notification
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToNeedRevealSideNotification:)
                                                 name:RevealSideControllerNeedRevealSideNotification
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(respondsToNeedHideSideNotification:)
                                                 name:RevealSideControllerNeedHideSideNotification
                                               object:nil];
}

- (void)setSideController:(UIViewController *)sideController
{
    if (_sideController != nil) {
        [self beginAppearanceTransition:NO animated:YES];
        [_sideController.view  removeFromSuperview];
        [self endAppearanceTransition];
        [_sideController removeFromParentViewController];
    }
    _sideController = sideController;
    if (_sideController != nil) {
        // Child View Controller
        [self addChildViewController:_sideController];
        [self beginAppearanceTransition:YES animated:YES];
        _sideController.view.frame = self.sideView.bounds;
        [self.sideView addSubview:_sideController.view];
        [self endAppearanceTransition];
        [_sideController didMoveToParentViewController:self];
    }
}

- (void)setCentralController:(UIViewController *)centralController
{
    if (_centralController != nil) {
        [self beginAppearanceTransition:NO animated:YES];
        [_centralController.view removeFromSuperview];
        [self endAppearanceTransition];
        [_sideController removeFromParentViewController];
    }
    _centralController = centralController;
    if (_centralController != nil) {
        [self addChildViewController:_centralController];
        [self beginAppearanceTransition:YES animated:YES];
        _centralController.view.frame = self.centralView.bounds;
        [self.centralView addSubview:_centralController.view];
        [self endAppearanceTransition];
        [_centralController didMoveToParentViewController:self];
    }
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Hide/ Reveal Side

- (void)handleHorizontalPan:(SDirectionPanGestureRecognizer *)horizontalPan
{
    CGFloat moveX = horizontalPan.moveX;
    if (self.sideState == RevealSideControllerSideStateHidden) {
        if (moveX > 0) {
            [self revealSide];
        }
    }   else if (self.sideState == RevealSideControllerSideStateRevealed) {
        if (moveX < 0) {
            [self hideSide];
        }
    }
}

- (void)hideSide
{
    if (self.sideState == RevealSideControllerSideStateHidden) {
        // No need to hide if already hidden.
        return;
    }
    self.sideState = RevealSideControllerSideStateHiding;
    CGFloat sideWidth = self.sideView.frame.size.width;
    
    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
//                         self.sideViewLeadingConstraint.constant = -sideWidth;
                         self.sideView.center = CGPointMake(self.sideView.center.x - sideWidth, self.sideView.center.y);
                         [self.view layoutIfNeeded];
                         self.sideShadowView.alpha = 0.0;
                         self.dimView.alpha = 0.0;
                     }
                     completion:^(BOOL finished) {
                         self.sideState = RevealSideControllerSideStateHidden;
                     }];
}

- (void)revealSide
{
    if (self.sideState == RevealSideControllerSideStateRevealed) {
        // No need to reveal if already reveavled.
        return;
    }
    self.sideState = RevealSideControllerSideStateRevealing;
    CGFloat sideWidth = self.sideView.frame.size.width;

    [UIView animateWithDuration:0.25
                          delay:0.0
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
//                         self.sideViewLeadingConstraint.constant = 0;
                         self.sideView.center = CGPointMake(self.sideView.center.x + sideWidth, self.sideView.center.y);
                         [self.view layoutIfNeeded];
                         self.sideShadowView.alpha = 1.0;
                         self.dimView.alpha = 0.6;
                     }
                     completion:^(BOOL finished) {
                         self.sideState = RevealSideControllerSideStateRevealed;
                     }];
    
}

- (void)respondsToNeedRevealSideNotification:(NSNotification *)notification
{
    [self revealSide];
}

- (void)respondsToNeedHideSideNotification:(NSNotification *)notification
{
    [self hideSide];
}

@end
