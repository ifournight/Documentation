//
//  SearchHeader.m
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SearchHeader.h"
#import "Appearance.h"

@interface SearchHeader ()

@property (strong, nonatomic) UILabel *headerLabel;

@end

@implementation SearchHeader

- (id)initWithReuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithReuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = [UIColor clearColor];
        
        UIImage *background = [[Appearance share] imageForSearchHeaderBackground];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
        
        _headerLabel = [[UILabel alloc] init];
        _headerLabel.backgroundColor = [UIColor clearColor];
        _headerLabel.numberOfLines = 1;
        [_headerLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
        [[Appearance share] addTextShadowForLabel:_headerLabel
                                        withColor:[UIColor whiteColor]
                                           offset:CGSizeMake(0, 1)];
        [self.contentView addSubview:_headerLabel];
        [self.contentView setTranslatesAutoresizingMaskIntoConstraints:NO];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setHeader:(NSString *)header
{
    if (_header != header) {
        _header = header;
        self.headerLabel.attributedText = [[NSAttributedString alloc] initWithString:header
                                                                          attributes:[[Appearance share] textAttributesForSearchHeader]];
        [self.headerLabel sizeToFit];
        [self layoutIfNeeded];
    }
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = @{@"Header": self.headerLabel};
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-44-[Header]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-7-[Header]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
}

@end