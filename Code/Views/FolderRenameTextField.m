//
//  FolderRenameTextField.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "FolderRenameTextField.h"
#import "Appearance.h"

@implementation FolderRenameTextField

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self setup];
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [self setup];
    }
    return self;
}

- (void)setup
{
    // font
    self.font = [[Appearance share] helveticaNeveWithSize:14.0];
    // textColot
    self.textColor = [UIColor colorWithRed:0.86 green:0.86 blue:0.86 alpha:1.0];
    // textAlignment
    self.textAlignment = NSTextAlignmentLeft;
    // clearsOnBeginEditing
    self.clearsOnBeginEditing = YES;
    // background
    self.background = [[Appearance share] imageForRenameTextFieldBackground];
    // clearButtonMode
    self.clearButtonMode = UITextFieldViewModeWhileEditing;
    // leftView
    UILabel *label = [[UILabel alloc] init];
    label.font = [[Appearance share] helveticaNeveWithSize:14.0];
    label.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0];
    label.text = @"Name";
    self.leftView = label;
    // leftViewMode
    self.leftViewMode = UITextFieldViewModeAlways;
}

- (CGRect)clearButtonRectForBounds:(CGRect)bounds
{
    CGRect rect = [super clearButtonRectForBounds:bounds];
    return rect;
}

- (CGRect)leftViewRectForBounds:(CGRect)bounds
{
    return CGRectMake(10, 15, 54, 16);
}

- (CGRect)borderRectForBounds:(CGRect)bounds
{
    return CGRectMake(0, 0, bounds.size.width, bounds.size.height);
}

@end
