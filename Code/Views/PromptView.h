//
//  PromptView.h
//  Documentation
//
//  Created by Song Hui on 13-7-28.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

// View has a black transparent background color and a prompt label.
// The view can show itself for designated duration and disappear.
@interface PromptView : UIView

// You can change promptLabel's text to your intented prompt text content.
@property (nonatomic, strong) UILabel *promptLabel;

// Use this method to let promptView appear for duration and disappear.
- (void)promptWithDuration:(CGFloat)durationTime;

@end
