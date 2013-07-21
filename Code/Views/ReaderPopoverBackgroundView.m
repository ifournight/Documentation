//
//  ReaderPopoverBackgroundView.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "ReaderPopoverBackgroundView.h"
#import "Appearance.h"

#define ArrowBase 18.0
#define ArrowHeight 10.0
#define ActualArrowHeight 12.0
#define ArrowBorderSpacing -2.0

@interface ReaderPopoverBackgroundView ()

@property (nonatomic, strong) UIImageView *border;
@property (nonatomic, strong) UIImageView *arrow;

@end

@implementation ReaderPopoverBackgroundView

@synthesize arrowOffset = _arrowOffset, arrowDirection = _arrowDirection;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        UIImage *borderImage = [[Appearance share] imageForReaderPopoverBorder];
        UIImage *arrowImage = [[Appearance share] imageForReaderPopoverArrow];
        _border = [[UIImageView alloc] initWithImage:borderImage];
        _arrow = [[UIImageView alloc] initWithImage:arrowImage];
        [self addSubview:_border];
        [self addSubview:_arrow];
//        [_border setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [_arrow setTranslatesAutoresizingMaskIntoConstraints:NO];
//        [self setNeedsUpdateConstraints];
    }
    return self;
}

+ (BOOL)wantsDefaultContentAppearance
{
    return NO;
}

+ (CGFloat)arrowBase
{
    return ArrowBase;
}

+ (CGFloat)arrowHeight
{
    return ArrowHeight;
}

+ (UIEdgeInsets)contentViewInsets{
    return UIEdgeInsetsMake(1.0, 1.0, 1.0, 1.0);
}

- (void)setArrowOffset:(CGFloat)arrowOffset
{
    _arrowOffset = arrowOffset;
//    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

- (void)setArrowDirection:(UIPopoverArrowDirection)arrowDirection
{
    _arrowDirection = arrowDirection;
//    [self setNeedsUpdateConstraints];
    [self setNeedsLayout];
}

//
//- (void)updateConstraints
//{
//    [super updateConstraints];
//    // Remove constraints
//    [self removeConstraints:self.constraints];
//    [self.arrow removeConstraints:self.arrow.constraints];
//    [self.border removeConstraints:self.border.constraints];
//    // Updata constraints
//    CGFloat popoverWidth = self.frame.size.width;
//    CGFloat popoverHeight = self.frame.size.height;
//    CGFloat arrowLeadingSpace = 0.0;
//    NSDictionary *viewsDictionary = @{@"A": self.arrow, @"B" : self.border};
//    NSMutableDictionary *metrics = [NSMutableDictionary dictionaryWithObjectsAndKeys:@(ArrowBorderSpacing), @"ABSpace",
//                                    @(ActualArrowHeight),@"AH", @(ArrowBase), @"AW", nil];
//    switch (self.arrowDirection) {
//        case UIPopoverArrowDirectionUp:
//            arrowLeadingSpace = popoverWidth/2 + self.arrowOffset - ArrowBase/2;
//            [metrics setObject:@(arrowLeadingSpace) forKey:@"LSpace"];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LSpace-[A(==AW)]"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[A(==AH)]-ABSpace-[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            
//            break;
//        case UIPopoverArrowDirectionDown:
//            arrowLeadingSpace = popoverWidth/2 + self.arrowOffset - ArrowBase/2;
//            [metrics setObject:@(arrowLeadingSpace) forKey:@"LSpace"];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-LSpace-[A(==AW)]"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[B]-ABSpace-[A(==AH)]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            break;
//        case UIPopoverArrowDirectionLeft:
//            arrowLeadingSpace = popoverHeight/2 + self.arrowOffset - ArrowBase/2;
//            [metrics setObject:@(arrowLeadingSpace) forKey:@"LSpace"];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[A(==AH)]-ABSpace-[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-LSpace-[A(==AW)]"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            break;
//        case UIPopoverArrowDirectionRight:
//            arrowLeadingSpace = popoverHeight/2 + self.arrowOffset - ArrowBase/2;
//            [metrics setObject:@(arrowLeadingSpace) forKey:@"LSpace"];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[B]-ABSpace-[A(==AH)]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[B]|"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-LSpace-[A(==AW)]"
//                                                                         options:0
//                                                                         metrics:metrics
//                                                                           views:viewsDictionary]];
//            break;
//        default:
//            break;
//    }
//}

- (void)layoutSubviews
{
    [super layoutSubviews];
    [[Appearance share] customReaderPopoverBorderShadow:self.border];
    // Get rid of the default shadow.
    self.layer.shadowOpacity = 0.0;
    // Layout subviews
    CGFloat popoverWidth = self.frame.size.width;
    CGFloat popoverHeight = self.frame.size.height;
    CGFloat arrowLeadingSpace = 0.0;
    switch (self.arrowDirection) {
        case UIPopoverArrowDirectionUp:
            arrowLeadingSpace = popoverWidth/2 + self.arrowOffset - ArrowBase/2;
            self.arrow.frame = CGRectMake(arrowLeadingSpace, 0, ArrowBase, ActualArrowHeight);
            self.border.frame = CGRectMake(0, ArrowHeight, popoverWidth, popoverHeight - ArrowHeight);
            break;
        case UIPopoverArrowDirectionDown:
            arrowLeadingSpace = popoverWidth/2 + self.arrowOffset - ArrowBase/2;
            self.arrow.frame = CGRectMake(arrowLeadingSpace, popoverHeight - ActualArrowHeight, ArrowBase, ActualArrowHeight);
            self.border.frame = CGRectMake(0, 0, popoverWidth, popoverHeight - ArrowHeight);
            break;
        case UIPopoverArrowDirectionLeft:
            arrowLeadingSpace = popoverHeight/2 + self.arrowOffset - ArrowBase/2;
            self.arrow.frame = CGRectMake(0, arrowLeadingSpace, ArrowBase, ActualArrowHeight);
            self.border.frame = CGRectMake(ArrowHeight, 0, popoverWidth - ArrowHeight, popoverHeight);
            break;
        case UIPopoverArrowDirectionRight:
            arrowLeadingSpace = popoverHeight/2 + self.arrowOffset - ArrowBase/2;
            self.arrow.frame = CGRectMake(popoverWidth - ActualArrowHeight, arrowLeadingSpace, ArrowBase, ActualArrowHeight);
            self.border.frame = CGRectMake(0, 0, popoverWidth - ArrowHeight, popoverHeight);
            break;
        default:
            break;
    }
}

@end
