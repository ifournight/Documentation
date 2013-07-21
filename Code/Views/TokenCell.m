//
//  TokenCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "TokenCell.h"
#import "Appearance.h"
#import "SearchToken.h"
#import "TokenTagView.h"

@implementation TokenCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        
        UIImage *background = [[Appearance share] imageForTokenCellBackground];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
        
        _icon = [[UIImageView alloc] init];
        [self.contentView addSubview:_icon];
        
        _main = [[UILabel alloc] init];
        _main.backgroundColor = [UIColor clearColor];
        _main.numberOfLines = 0;
        [_main setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_main];
        
        _tagView = [[TokenTagView alloc] initWithTagDictionarys:nil];
        [_tagView setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_tagView];
        
        _description = [[UILabel alloc] init];
        _description.backgroundColor = [UIColor clearColor];
        _description.numberOfLines = 0;
        [_description setContentCompressionResistancePriority:749 forAxis:UILayoutConstraintAxisVertical];
        [_description setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_description];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setToken:(SearchToken *)token
{
    if (_token != token) {
        _token = token;
        
        self.icon.image = [[Appearance share] imageForTokenType:_token.type];
        [self.icon sizeToFit];
        
        NSMutableAttributedString *mainAttributedText = [[NSMutableAttributedString alloc] initWithString:_token.name
                                                                                               attributes:[[Appearance share] textAttributesForTokenMain]];
        for (NSValue *rangeValue in token.matchRanges) {
            NSRange range = [rangeValue rangeValue];
            [mainAttributedText setAttributes:[[Appearance share] textAttributesForTokenMainHighlight]
                                        range:range];
        }
        
        self.main.attributedText = mainAttributedText;
        
        NSMutableArray *tagDictionaries = [[NSMutableArray alloc] init];
        
        if (_token.container.length > 0) {
            [tagDictionaries addObject:@{TokenTagViewTextKey : _token.container,
                  TokenTagViewTypeKey : [NSNumber numberWithInteger:TokenTagViewTypeContainer]}];
        }
        
        if (_token.deprecated) {
            [tagDictionaries addObject:@{TokenTagViewTextKey : _token.deprecatedSinceVersion,
                  TokenTagViewTypeKey : [NSNumber numberWithInteger:TokenTagViewTypeDeprecated]}];
        }
        
        [self.tagView setTagDictionarys:tagDictionaries];
        
        if (_token.abstract) {
            NSAttributedString *descriptionAttributedText = [[NSAttributedString alloc] initWithString:_token.abstract
                                                                                            attributes:[[Appearance share] textAttributesForTokenDescription]];
            self.description.attributedText = descriptionAttributedText;
        }   else {
            self.description.attributedText = nil;
        }
        
        [self layoutIfNeeded];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)setupConstraints
{
    NSDictionary *viewsDictionary = @{@"Icon" : self.icon,
                                      @"Main" : self.main,
                                      @"Tag" : self.tagView,
                                      @"Description" : self.description
                                      };
    
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Icon][Main]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Icon][Tag]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[Icon][Description]"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[Main]-6-[Tag]-6-[Description]-10-|"
                                                                             options:0
                                                                             metrics:nil
                                                                               views:viewsDictionary]];
    
    [self.contentView addConstraint:[NSLayoutConstraint constraintWithItem:self.main
                                                                 attribute:NSLayoutAttributeTrailing
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.description
                                                                 attribute:NSLayoutAttributeTrailing
                                                                multiplier:1.0
                                                                  constant:0.0]];
    self.main.preferredMaxLayoutWidth = 260.0;
    self.description.preferredMaxLayoutWidth = self.main.preferredMaxLayoutWidth;
}

- (CGSize)intrinsicContentSize
{
    if (self.token) {
        CGSize mainSize = self.main.intrinsicContentSize;
        CGSize tagViewSize = self.tagView.intrinsicContentSize;
        CGSize descriptionSize = self.description.intrinsicContentSize;
        
        CGRect mainAlignmentRect = CGRectMake(0, 0, mainSize.width, mainSize.height);
        CGRect tagViewAlignmentRect = CGRectMake(0, 0, tagViewSize.width, tagViewSize.height);
        CGRect descriptionAlignmentRect = CGRectMake(0, 0, descriptionSize.width, descriptionSize.height);
        
        CGRect mainFrame = [self.main frameForAlignmentRect:mainAlignmentRect];
        CGRect tagViewFrame = [self.main frameForAlignmentRect:tagViewAlignmentRect];
        CGRect descriptionFrame = [self.description frameForAlignmentRect:descriptionAlignmentRect];
        
        //        NSLog(@"Token: %@ mainSize %@, tagSize%@, descriptionSize%@." , self.token.name, NSStringFromCGSize(mainSize), NSStringFromCGSize(tagViewSize), NSStringFromCGSize(descriptionSize));
        //
        //        NSLog(@"Token: %@ mainFrame %@, tagViewFrame%@, descriptionFrame%@." , self.token.name, NSStringFromCGRect(mainFrame), NSStringFromCGRect(tagViewFrame), NSStringFromCGRect(descriptionFrame));
        
        CGFloat cellWidth = CGRectGetWidth(mainFrame) + CGRectGetWidth(tagViewFrame) + CGRectGetWidth(descriptionFrame) + 10;
        CGFloat descriptionHeight = MIN(CGRectGetHeight(descriptionFrame), 32.0);
        CGFloat cellHeight = 0;
        if (descriptionHeight > 0) {
            cellHeight = CGRectGetHeight(mainFrame) + CGRectGetHeight(tagViewFrame) + descriptionHeight + 25;
        }   else {
            cellHeight = CGRectGetHeight(mainFrame) + CGRectGetHeight(tagViewFrame) + 15;
        }
        
        //        CGFloat cellWidth = self.icon.intrinsicContentSize.width + mainSize.width + 10;
        //        CGFloat cellHeight = mainSize.height + tagViewSize.height + descriptionSize.height + 25;
        
        return CGSizeMake(cellWidth, cellHeight);
    }   else {
        return CGSizeZero;
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
}

@end
