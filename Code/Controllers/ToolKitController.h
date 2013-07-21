//
//  ToolKitController.h
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SSegmentedControl.h"

// A custom container controller. It has a toolbar and a containerView.
// Toolbar has a segmented control usded to switch ToolKitController's child controllers.
// Container view is the container view for child controllers.
@interface ToolKitController : UIViewController<SSegmentedControlDelegate>

// ToolKitController has a toolbar.
// It has a segmented control used to switch children controllers, and a setting button.
// Toolbar can hide in certain case, to indicate that It's unable to switch child controllers,
// e.g. When selected controller is in edit mode.
@property (weak, nonatomic) IBOutlet UIToolbar *toolbar;

@property (weak, nonatomic) IBOutlet UIView *containerView;

@property (strong, nonatomic) NSArray *viewControllers;

@property (assign, nonatomic) NSInteger selectedIndex;

//- (void)hideToolbar;

@end

