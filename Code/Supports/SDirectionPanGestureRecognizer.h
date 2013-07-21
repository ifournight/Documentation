//
//  SDirectionPanGestureRecognizer.h
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIGestureRecognizerSubclass.h>

typedef NS_ENUM(NSUInteger, SDirectionPanGestureRecognizerDirection) {
    SDirectionPanGestureRecognizerDirectionHorizontal,
    SDirectionPanGestureRecognizerDirectionVertical
};

//  Subclass of UIPanGestureRecognizer that only enable one direction pan gesture.
//  The intended direction should be set by the property direction.
@interface SDirectionPanGestureRecognizer : UIPanGestureRecognizer

//  Gesture's movement along the x axis, only useful when gesture's direction is horizontal.
//  It is discrete, that is to say, represents the current pan's movement in touchesMoved:withEvent:, not the overall movement.
@property (nonatomic, assign) CGFloat moveX;

//  Gesture's movement along the y axis, only useful when gesture's direction is vertical.
//  It is discrete, that is to say, represents the current pan's movement in touchesMoved:withEvent:, not the overall movement.
@property (nonatomic, assign) CGFloat moveY;

//  The intended direction should be set by this property.
@property (nonatomic, assign) SDirectionPanGestureRecognizerDirection direction;

//  Not a designated initalizer, but a convenient one.
- (id)initWithTarget:(id)target action:(SEL)action direction:(SDirectionPanGestureRecognizerDirection)direction;

@end
