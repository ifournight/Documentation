//
//  PromptView.m
//  Documentation
//
//  Created by Song Hui on 13-7-28.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "PromptView.h"
#import "Appearance.h"

@implementation PromptView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor blackColor];
        self.alpha = 0.85;
        self.layer.cornerRadius = 15.0;
        
        _promptLabel = [[UILabel alloc] init];
        _promptLabel.backgroundColor = [UIColor clearColor];
        _promptLabel.font = [[Appearance share] helveticaNeveBoldWithSize:18.0];
        _promptLabel.textColor = [UIColor whiteColor];
        _promptLabel.textAlignment = NSTextAlignmentCenter;
        _promptLabel.alpha = 0.85;
        [self addSubview:_promptLabel];
    }
    return self;
}

- (void)show
{
    self.hidden = NO;
}

- (void)hide
{
    self.hidden = YES;
}

- (void)promptWithDuration:(CGFloat)durationTime
{
    [self show];
    [self performSelector:@selector(hide) withObject:nil afterDelay:durationTime];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize selfSize = self.frame.size;
    [self.promptLabel sizeToFit];
    CGSize labelSize = self.promptLabel.bounds.size;
    CGRect labelFrame = CGRectIntegral(CGRectInset(self.bounds, (CGFloat)(selfSize.width - labelSize.width) / 2.0, (CGFloat)(selfSize.height - labelSize.height) / 2.0));
    self.promptLabel.frame = labelFrame;
}

@end
