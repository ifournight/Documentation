//
//  ToolKitController.m
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "ToolKitController.h"
#import "Appearance.h"
#import "SSegmentedControl.h"
#import "SearchController.h"
#import "BookmarkFolderController.h"

@interface ToolKitController ()

// Switch trigger by segmented controller will be added to transitionQueue for potential bug.
@property (nonatomic, strong) NSMutableArray *transitionQueue;

- (void)selectViewControllerAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated;

- (void)excuteTransitionAnimated:(BOOL)animated;

@end

@implementation ToolKitController

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
    // Clips Subviews
    self.containerView.clipsToBounds = YES;
    // Custom ToolKitBar
    [[Appearance share] customToolKitBar:self.toolbar];
    // SSegmentedControl
    SSegmentedControl *segmentedControl = [[Appearance share] segmentedControl];
    NSLayoutConstraint *segmentedControlHorizontalConstraint = [NSLayoutConstraint constraintWithItem:segmentedControl
                                                                                            attribute:NSLayoutAttributeCenterX
                                                                                            relatedBy:NSLayoutRelationEqual
                                                                                               toItem:self.toolbar
                                                                                            attribute:NSLayoutAttributeCenterX
                                                                                           multiplier:1
                                                                                             constant:0];
    
    NSLayoutConstraint *segmentedControlVerticalConstraint = [NSLayoutConstraint constraintWithItem:segmentedControl
                                                                                          attribute:NSLayoutAttributeCenterY
                                                                                          relatedBy:NSLayoutRelationEqual
                                                                                             toItem:self.toolbar
                                                                                          attribute:NSLayoutAttributeCenterY
                                                                                         multiplier:1 constant:0];
    [self.toolbar addSubview:segmentedControl];
    [segmentedControl setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.view addConstraint:segmentedControlHorizontalConstraint];
    [self.view addConstraint:segmentedControlVerticalConstraint];
    segmentedControl.delegate = self;
    // TODO:Child Controllers
    SearchController *searchController = [[SearchController alloc] initWithNibName:nil bundle:nil];
    BookmarkFolderController *bookmarkFolderController = [[BookmarkFolderController alloc] initWithNibName:nil bundle:nil];
    UINavigationController *bookmarkNavigationController = [[UINavigationController alloc] initWithRootViewController:bookmarkFolderController];
//    UIViewController *viewController1 = [[UIViewController alloc] init];
    UIViewController *viewController2 = [[UIViewController alloc] init];
//    UIViewController *viewController3 = [[UIViewController alloc] init];
//    viewController1.view.backgroundColor = [UIColor colorWithRed:0.212 green:0.608 blue:0.906 alpha:1.0];
    viewController2.view.backgroundColor = [UIColor colorWithRed:0.804 green:0.373 blue:0.624 alpha:1.0];
//    viewController3.view.backgroundColor = [UIColor colorWithRed:0.992 green:0.310 blue:0.341 alpha:1.0];
    UIViewAutoresizing autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleBottomMargin;
//    viewController1.view.autoresizingMask = autoresizingMask;
    viewController2.view.autoresizingMask = autoresizingMask;
//    viewController3.view.autoresizingMask = autoresizingMask;
    self.viewControllers = @[searchController, viewController2, bookmarkNavigationController];
    // Default Selection
    self.transitionQueue = [[NSMutableArray alloc] init];
    [self selectViewControllerAtIndex:0 animated:NO];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Child Controllers Management
- (void)segmentedControl:(SSegmentedControl *)segmentedControl
 didSelectSegmentAtIndex:(NSInteger)selectedIndex
{
    [self selectViewControllerAtIndex:selectedIndex animated:YES];
}

- (void)selectViewControllerAtIndex:(NSInteger)selectedIndex animated:(BOOL)animated
{
    if (animated) {
        // Only excuste transition when select unselected index.
        if (self.selectedIndex == selectedIndex) {
            return;
        }
        NSArray *transition = @[@(self.selectedIndex), @(selectedIndex)];
        if (self.transitionQueue.count == 0) {
            [self.transitionQueue addObject:transition];
            [self excuteTransitionAnimated:YES];
        }   else {
            [self.transitionQueue addObject:transition];
        }
    }   else {
        // Add child controller to containerView with no animation.
        UIViewController *selectedController = self.viewControllers[selectedIndex];
        [self addChildViewController:selectedController];
        [self beginAppearanceTransition:YES animated:NO];
        selectedController.view.frame = [self centralFrame];
        [self.containerView addSubview:selectedController.view];
        [self endAppearanceTransition];
        [selectedController didMoveToParentViewController:self];
        self.selectedIndex = selectedIndex;
    }
}

- (void)excuteTransitionAnimated:(BOOL)animated
{
    NSArray *transition = self.transitionQueue[0];
    NSInteger fromIndex = [transition[0] integerValue];
    NSInteger toIndex = [transition[1] integerValue];
    UIViewController *fromController = self.viewControllers[fromIndex];
    UIViewController *toController = self.viewControllers[toIndex];
    if (animated) {
        [self addChildViewController:toController];
        [self beginAppearanceTransition:YES animated:YES];
        if (fromIndex > toIndex) {
            toController.view.frame = [self leftFrame];
        }   else {
            toController.view.frame = [self rightFrame];
        }
        [self.containerView addSubview:toController.view];
        [UIView animateWithDuration:0.25
                              delay:0.0
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             if (fromIndex > toIndex) {
                                 fromController.view.frame = [self rightFrame];
                                 toController.view.frame = [self centralFrame];
                             }  else {
                                 fromController.view.frame = [self leftFrame];
                                 toController.view.frame = [self centralFrame];
                             }
                         }
                         completion:^(BOOL finished) {
                             [fromController willMoveToParentViewController:nil];
                             [fromController.view removeFromSuperview];
                             [self endAppearanceTransition];
                             [fromController removeFromParentViewController];
                             [toController didMoveToParentViewController:self];
                             self.selectedIndex = toIndex;
                             [self.transitionQueue removeObject:transition];
                             if (self.transitionQueue.count != 0) {
                                 [self excuteTransitionAnimated:YES];
                             }
                         }];
    }
}

#pragma mark - Show / Hide ToolKitBar.

- (void)showToolbarWithCompletionHandler:(void(^)(void))completionHandler
{
    CGSize fullSize = self.view.frame.size;
    CGRect containerFrame = CGRectMake(0, 0, fullSize.width, fullSize.height - 44);
    CGRect barFrame = CGRectMake(0, fullSize.height - 44, fullSize.width, 44);
    self.toolbar.hidden = NO;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.containerView.frame = containerFrame;
        self.toolbar.frame = barFrame;
    } completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)hideToolbarWithCompletionHandler:(void(^)(void))completionHandler
{
    CGSize fullSize = self.view.frame.size;
    CGRect containerFrame = CGRectMake(0, 0, fullSize.width, fullSize.height);
    CGRect barFrame = CGRectMake(0, fullSize.height, fullSize.width, 44);
    
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.containerView.frame = containerFrame;
        self.toolbar.frame = barFrame;
    } completion:^(BOOL finished) {
        self.toolbar.hidden = YES;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

#pragma mark - Frame Helper Method.

- (CGRect)centralFrame
{
    CGRect containerFrame = self.containerView.bounds;
    return containerFrame;
}

- (CGRect)leftFrame
{
    CGRect containerFrame = self.containerView.bounds;
    CGFloat containerWidth = containerFrame.size.width;
    return CGRectMake(-containerWidth, 0, containerFrame.size.width, containerFrame.size.height);
}

- (CGRect)rightFrame
{
    CGRect containerFrame = self.containerView.bounds;
    CGFloat containerWidth = containerFrame.size.width;
    return CGRectMake(containerWidth, 0, containerFrame.size.width, containerFrame.size.height);
}

#pragma Pesenting View Controller Subclass

- (BOOL)definesPresentationContext
{
    return YES;
}

@end

@implementation UIViewController (ToolKitController)

- (ToolKitController *)toolKitController
{
    UIViewController *parentController = self.parentViewController;
    if (parentController) {
        if ([parentController isKindOfClass:[ToolKitController class]]) {
            return (ToolKitController *)parentController;
        }   else {
            return parentController.toolKitController;
        }
    }   else {
        return nil;
    }
}

@end