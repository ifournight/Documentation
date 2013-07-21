//
//  SSegmentedControl.h
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol SSegmentedControlDelegate;

// Custom control with more appearance customazition.
@interface SSegmentedControl : UIView

// Selected Index
@property (nonatomic, assign) NSInteger selectedIndex;

// Delegate
@property (nonatomic, weak) id<SSegmentedControlDelegate> delegate;

// Image/ selected images are segments' images.
// SSegmentedControl will use image's count to determine segment's count.
// It takes advantage of New Auto Layout API. With given segmentWidth, Control can auto-layout itself.
// Because The minimal touch rect is 44x44 according to Apple, SSegmentedControl will have a fixed height 44.
- (id)initWithImages:(NSArray *)images
      selectedImages:(NSArray *)selectedImages
        segmentWidth:(CGFloat)segmentWidth;

@end

// Use this protocol to receive message when control selected.
@protocol SSegmentedControlDelegate <NSObject>

- (void)segmentedControl:(SSegmentedControl *)segmentedControl
 didSelectSegmentAtIndex:(NSInteger)selectedIndex;

@end

