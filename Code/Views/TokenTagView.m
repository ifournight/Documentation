//
//  TokenTagView.m
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "TokenTagView.h"
#import "Appearance.h"

NSString *const TokenTagViewTextKey = @"TokenTagViewTextKey";
NSString *const TokenTagViewTypeKey = @"TokenTagViewTypeKey";

@interface TokenTagView ()

@property (strong, nonatomic) NSArray *labels;
@property (strong, nonatomic) NSArray *borders;

@end

@implementation TokenTagView

- (id)initWithTagDictionarys:(NSArray *)tagDictionarys
{
    if (self = [super init]) {
        self.tagDictionarys = tagDictionarys;
    }
    
    return self;
}

- (void)setTagDictionarys:(NSArray *)tagDictionarys
{
    if (_tagDictionarys != tagDictionarys) {
        
        
        for (UIView *subView in self.subviews) {
            [subView removeFromSuperview];
        }
        
        _tagDictionarys = tagDictionarys;
        
        if (_tagDictionarys) {
            NSMutableArray *labels = [[NSMutableArray alloc] init];
            NSMutableArray *borders = [[NSMutableArray alloc] init];
            for (NSDictionary *tagDictionary in tagDictionarys) {
                NSString *text = tagDictionary[TokenTagViewTextKey];
                TokenTagViewType type = [tagDictionary[TokenTagViewTypeKey] integerValue];
                NSDictionary *textAttributes = [[Appearance share] textAttributesForTagWithType:type];
                UIImage *borderImage = [[Appearance share] imageForTagBorderWithType:type];
                
                
                
                UILabel *tagLabel = [[UILabel alloc] init];
                tagLabel.backgroundColor = [UIColor clearColor];
                tagLabel.attributedText = [[NSAttributedString alloc] initWithString:text
                                                                          attributes:textAttributes];
                
                UIImageView *border = [[UIImageView alloc] initWithImage:borderImage];
                
                [labels addObject:tagLabel];
                [borders addObject:border];
                
                [border addSubview:tagLabel];
                [self addSubview:border];
            }
            
            self.labels = labels;
            self.borders = borders;
            
            [self setupConstraints];
        }
    }
}

- (void)setupConstraints
{
    NSMutableDictionary *viewsDictionary = [[NSMutableDictionary alloc] init];
    
    for (UILabel *label in self.labels) {
        [viewsDictionary setObject:label forKey:[NSString stringWithFormat:@"Label%d", [self.labels indexOfObject:label]]];
    }
    
    for (UIImageView *border in self.borders) {
        [viewsDictionary setObject:border forKey:[NSString stringWithFormat:@"Border%d", [self.borders indexOfObject:border]]];
    }
    
    //    NSLog(@"%@", viewsDictionary);
    
    for (UILabel *label in self.labels) {
        [label setTranslatesAutoresizingMaskIntoConstraints:NO];
        [label.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"H:|-4-[Label%d]-4-|", [self.labels indexOfObject:label]]
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary]];
        [label.superview addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|-4-[Label%d]-4-|", [self.labels indexOfObject:label]]
                                                                                options:0
                                                                                metrics:nil
                                                                                  views:viewsDictionary]];
    }
    
    NSString *borderHorizontalVisualFormat = @"";
    borderHorizontalVisualFormat = [borderHorizontalVisualFormat stringByAppendingString:@"H:|"];
    for (UIImageView *border in self.borders) {
        [border setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:[NSString stringWithFormat:@"V:|[Border%d]|", [self.borders indexOfObject:border]]
                                                                     options:0
                                                                     metrics:nil
                                                                       views:viewsDictionary]];
        borderHorizontalVisualFormat = [borderHorizontalVisualFormat stringByAppendingFormat:@"[Border%d]", [self.borders indexOfObject:border]];
        if ([self.borders indexOfObject:border] != self.borders.count - 1) {
            borderHorizontalVisualFormat = [borderHorizontalVisualFormat stringByAppendingString:@"-4-"];
        }
    }
    
    borderHorizontalVisualFormat = [borderHorizontalVisualFormat stringByAppendingString:@"|"];
    
    [self addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:borderHorizontalVisualFormat
                                                                 options:0
                                                                 metrics:nil
                                                                   views:viewsDictionary]];
    
    [self layoutIfNeeded];
}

- (CGSize)intrinsicContentSize
{
    CGSize intrinsicContentSize;
    if (self.tagDictionarys) {
        CGFloat width = 0.0;
        CGFloat height = 0.0;
        for (UILabel *label in self.labels) {
            width += label.intrinsicContentSize.width;
        }
        width += self.labels.count * 8 + (self.labels.count - 1) * 4;
        height = ((UILabel *)self.labels[0]).intrinsicContentSize.height + 8;
        intrinsicContentSize = CGSizeMake(width, height);
        return intrinsicContentSize;
    }   else {
        return CGSizeZero;
    }
}

@end