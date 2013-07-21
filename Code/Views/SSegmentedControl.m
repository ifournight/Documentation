//
//  SSegmentedControl.m
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SSegmentedControl.h"

const UIEdgeInsets SSegmentedControlCentralBackgroundInsets = {0, 3, 0, 3};
const UIEdgeInsets SSegmentedControlLeftBackgroundInsets = {0, 15, 0, 3};
const UIEdgeInsets SSegmentedControlRightBackgroundInsets = {0, 3, 0, 15};
const UIEdgeInsets SSegmentedControlBorderInsets = {0, 18, 0, 18};

NSString* const SSegmentedControlBorderImageName = @"Segmented-Border";
NSString* const SSegmentedControlDividerImageName = @"Segmented-Divider";
NSString* const SSegmentedControlLeftBackgroundImageName = @"Segmented-Left-Background";
NSString* const SSegmentedControlRightBackgroundImageName = @"Segmented-Right-Background";
NSString* const SSegmentedControlCentralBackgroundImageName = @"Segmented-Central-Background";
NSString* const SSegmentedControlLeftBackgroundSelectedImageName = @"Segmented-Left-Background-Selected";
NSString* const SSegmentedControlRightBackgroundSelectedImageName = @"Segmented-Right-Background-Selected";
NSString* const SSegmentedControlCentralBackgroundSelectedImageName = @"Segmented-Central-Background-Selected";

@interface SSegmentedControl ()

@property (nonatomic, strong) NSArray *segments;

@property (nonatomic, strong) NSArray *dividers;

@property (nonatomic, assign) NSInteger segmentWidth;

- (void)selectSegment:(UIButton *)segment animated:(BOOL)animated;

@end

@implementation SSegmentedControl

- (id)initWithImages:(NSArray *)images
      selectedImages:(NSArray *)selectedImages
        segmentWidth:(CGFloat)segmentWidth
{
    if (self = [super init]) {
        
        // Check whether the images' count equals selected images' count.
        if (images.count != selectedImages.count) {
            NSLog(@"Segmented Control Initialization method Error.");
        }
        
        // Control Images Preparation.
        UIImage *borderImage = [[UIImage imageNamed:SSegmentedControlBorderImageName] resizableImageWithCapInsets:SSegmentedControlBorderInsets];
        UIImage *dividerImage = [UIImage imageNamed:SSegmentedControlDividerImageName];
        UIImage *leftBackgroundImage = [[UIImage imageNamed:SSegmentedControlLeftBackgroundImageName] resizableImageWithCapInsets:SSegmentedControlLeftBackgroundInsets];
        UIImage *rightBackgroundImage = [[UIImage imageNamed:SSegmentedControlRightBackgroundImageName] resizableImageWithCapInsets:SSegmentedControlRightBackgroundInsets];
        UIImage *centralBackgroundImage = [[UIImage imageNamed:SSegmentedControlCentralBackgroundImageName] resizableImageWithCapInsets:SSegmentedControlCentralBackgroundInsets];
        UIImage *leftBackgroundSelectedImage = [[UIImage imageNamed:SSegmentedControlLeftBackgroundSelectedImageName] resizableImageWithCapInsets:SSegmentedControlLeftBackgroundInsets];
        UIImage *rightBackgroundSelectedImage = [[UIImage imageNamed:SSegmentedControlRightBackgroundSelectedImageName] resizableImageWithCapInsets:SSegmentedControlRightBackgroundInsets];
        UIImage *centralBackgroundSelectedImage = [[UIImage imageNamed:SSegmentedControlCentralBackgroundSelectedImageName] resizableImageWithCapInsets:SSegmentedControlCentralBackgroundInsets];
        
        // Views Dictionary
        NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
        
        // Border
        self.backgroundColor = [UIColor clearColor];
        UIImageView *borderView = [[UIImageView alloc] initWithImage:borderImage];
        [borderView setTranslatesAutoresizingMaskIntoConstraints:NO];
        //        self.layer.contents = (__bridge id)([borderImage CGImage]);
        [viewsDictionary setObject:borderView  forKey:@"Border"];
        [self addSubview:borderView];
        NSArray *borderHorizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[Border]|" options:0 metrics:nil views:viewsDictionary];
        NSArray *borderVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|[Border]|" options:0 metrics:nil views:viewsDictionary];
        [self addConstraints:borderHorizontalConstraints];
        [self addConstraints:borderVerticalConstraints];
        
        // Segments Creation.
        // Each segments are actually UIButtons.
        NSInteger segmentCount = images.count;
        NSMutableArray *segments = [[NSMutableArray alloc] init];
        for (int i = 0; i < segmentCount; i++) {
            UIButton *segment = [[UIButton alloc] init];
            // Images
            [segment setImage:images[i] forState:UIControlStateNormal];
            [segment setImage:selectedImages[i] forState:UIControlStateSelected];
            // BackgroundImages
            if (i == 0) {
                [segment setBackgroundImage:leftBackgroundImage forState:UIControlStateNormal];
                [segment setBackgroundImage:leftBackgroundSelectedImage forState:UIControlStateSelected];
            }   else if (i == segmentCount - 1) {
                [segment setBackgroundImage:rightBackgroundImage forState:UIControlStateNormal];
                [segment setBackgroundImage:rightBackgroundSelectedImage forState:UIControlStateSelected];
            }   else {
                [segment setBackgroundImage:centralBackgroundImage forState:UIControlStateNormal];
                [segment setBackgroundImage:centralBackgroundSelectedImage forState:UIControlStateSelected];
            }
            // Target
            [segment addTarget:self action:@selector(segmentTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
            // UIControlAligment
            segment.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            segment.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
            [segments addObject:segment];
            
            [segment setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:segment];
        }
        
        // Dividers Creation.
        NSInteger dividerCount = segmentCount - 1;
        NSMutableArray *dividers = [[NSMutableArray alloc] init];
        for (int i = 0; i < dividerCount; i++) {
            UIImageView *divider = [[UIImageView alloc] initWithImage:dividerImage];
            [dividers addObject:divider];
            
            [divider setTranslatesAutoresizingMaskIntoConstraints:NO];
            [self addSubview:divider];
        }
        
        // Layout Constraints
        
        [viewsDictionary setObject:self forKey:@"self"];
        for (int i = 0; i < segmentCount; i ++) {
            [viewsDictionary setObject:segments[i] forKey:[NSString stringWithFormat:@"%@%d", @"segment", i]];
        }
        for (int i = 0; i < dividerCount; i ++) {
            [viewsDictionary setObject:dividers[i] forKey:[NSString stringWithFormat:@"%@%d", @"divider", i]];
        }
        
        // Compose Horizontal Constraints
        NSString *horizontalVisualFormat = @"";
        
        for (int i = 0; i < segmentCount; i ++) {
            if (i == 0) {
                horizontalVisualFormat = [horizontalVisualFormat stringByAppendingFormat:@"H:|-1-"];
            }
            horizontalVisualFormat = [horizontalVisualFormat stringByAppendingFormat:@"[%@(==%d)]", [NSString stringWithFormat:@"segment%d", i], (NSInteger)segmentWidth];
            if (i < dividerCount) {
                horizontalVisualFormat = [horizontalVisualFormat stringByAppendingFormat:@"[%@(==1)]", [NSString stringWithFormat:@"divider%d", i]];
            }
            if (i == segmentCount - 1) {
                horizontalVisualFormat = [horizontalVisualFormat stringByAppendingFormat:@"-1-|"];
            }
        }
        
        //        NSLog(@"SSegmentedControl Horizontal Visual Format: %@", horizontalVisualFormat);
        
        NSArray *horizontalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:horizontalVisualFormat options:0 metrics:nil views:viewsDictionary];
        
        [self addConstraints:horizontalConstraints];
        
        // Compose Vertical Constraints
        
        for (int j = 0; j < segmentCount; j ++) {
            NSString *segmentVerticalVisualFormat = [NSString stringWithFormat:@"V:|[%@%d]|", @"segment", j];
            //            NSLog(@"SSegmentedControl Segment Vertical Format: %@", segmentVerticalVisualFormat);
            
            NSArray *segmentVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:segmentVerticalVisualFormat options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:segmentVerticalConstraints];
        }
        
        for (int j = 0; j < dividerCount; j ++) {
            NSString *dividerVerticalVisualFormat = [NSString stringWithFormat:@"V:|[%@%d]|", @"divider", j];
            //            NSLog(@"SSegmentedControl Divider Vertical Format: %@", dividerVerticalVisualFormat);
            NSArray *dividerVerticalConstraints = [NSLayoutConstraint constraintsWithVisualFormat:dividerVerticalVisualFormat options:0 metrics:nil views:viewsDictionary];
            
            [self addConstraints:dividerVerticalConstraints];
        }
        
        NSInteger selfWidth = segmentWidth * segmentCount + dividerCount * 1 + 2;
        __unused NSInteger selfHeight = 44;
        NSArray *selfWidthConstraints = [NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:[self(==%d)]", selfWidth] options:0 metrics:nil views:viewsDictionary];
        NSArray *selfHeightConstraints = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[self(==44)]" options:0 metrics:nil views:viewsDictionary];
        
        [self addConstraints:selfWidthConstraints];
        [self addConstraints:selfHeightConstraints];
        
        // Properties Assignment
        _segments = segments;
        _dividers = dividers;
        
        _segmentWidth = segmentWidth;
        
        // Default Selected Index;
        [self selectSegment:_segments[0] animated:YES];
    }
    return self;
}

#pragma mark - Selection

- (void)segmentTouchUpInside:(UIButton *)segment
{
    [self selectSegment:segment animated:YES];
    [self.delegate segmentedControl:self
            didSelectSegmentAtIndex:self.selectedIndex];
}

- (void)selectSegment:(UIButton *)selectedSegment animated:(BOOL)animated
{
    for (UIButton *segment in self.segments) {
        if (segment == selectedSegment) {
            segment.selected = YES;
            self.selectedIndex = [self.segments indexOfObject:segment];
        }   else {
            segment.selected = NO;
        }
    }
}

#pragma mark - Auto Layout About

- (CGSize)intrinsicContentSize
{
    return self.segments ? CGSizeMake([self selfWidth], [self selfHeight]) : CGSizeZero;
}

- (CGFloat)selfWidth
{
    if (self.segments == nil) {
        return 0;
    }   else {
        return self.segments.count * self.segmentWidth + self.dividers.count * 1 + 2;
    }
}

- (CGFloat)selfHeight
{
    return 44;
}

@end