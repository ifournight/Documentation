//
//  SDirectionPanGestureRecognizer.m
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SDirectionPanGestureRecognizer.h"

@interface SDirectionPanGestureRecognizer()

@property (nonatomic, assign) BOOL directionPan;

@end

@implementation SDirectionPanGestureRecognizer

//  Designated initializer.
- (id)initWithTarget:(id)target action:(SEL)action
{
    self = [super initWithTarget:target action:action];
    if (self) {
        [self reset];
    }
    return self;
}

- (id)initWithTarget:(id)target action:(SEL)action direction:(SDirectionPanGestureRecognizerDirection)direction
{
    self = [self initWithTarget:target action:action];
    if (self) {
        self.direction = direction;
    }
    return self;
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesMoved:touches withEvent:event];
    if (self.state == UIGestureRecognizerStateFailed) return;
    CGPoint nowPoint = [[touches anyObject] locationInView:self.view];
    CGPoint prePoint = [[touches anyObject] previousLocationInView:self.view];
    self.moveX = nowPoint.x - prePoint.x;
    self.moveY = nowPoint.y - prePoint.y;
    if (self.moveX == 0 && self.moveY == 0) return;
    if (!self.directionPan) {
        if (self.direction == SDirectionPanGestureRecognizerDirectionHorizontal) {
            if (abs(self.moveX) >= abs(self.moveY)) {
                self.directionPan = YES;
            }   else {
                self.state = UIGestureRecognizerStateFailed;
            }
        }   else if (self.direction == SDirectionPanGestureRecognizerDirectionVertical) {
            if (abs(self.moveY) >= abs(self.moveX)) {
                self.directionPan = YES;
            }   else {
                self.state = UIGestureRecognizerStateFailed;
            }
        }
    }
}

- (void)reset
{
    [super reset];
    self.directionPan = NO;
    self.moveX = 0;
    self.moveY = 0;
}

@end

