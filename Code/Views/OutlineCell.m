//
//  OutlineCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "OutlineCell.h"
#import "Outline.h"
#import "Appearance.h"

@interface OutlineCell ()

@property (nonatomic, strong) NSLayoutConstraint *leadingCons;

@end

@implementation OutlineCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
        UIImage *background = [[Appearance share] imageForTokenCellBackground];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
        
        _outlineButton = [[Appearance share] outlineButton];
        [_outlineButton addTarget:self action:@selector(expandOrCollapse)
                 forControlEvents:UIControlEventTouchUpInside];
        [_outlineButton setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_outlineButton];
        
        _main = [[UILabel alloc] init];
        _main.backgroundColor = [UIColor clearColor];
        _main.numberOfLines = 0;
        [_main setTranslatesAutoresizingMaskIntoConstraints:NO];
        [self.contentView addSubview:_main];
        
        [self setupConstraints];
    }
    return self;
}

- (void)setOutline:(Outline *)outline
{
    if (_outline != outline) {
        _outline = outline;
        
        self.outlineButton.hidden = _outline.children.count > 0 ? NO : YES;
        self.outlineButton.selected = _outline.expanded ? YES : NO;
        
        self.main.attributedText = [[NSAttributedString alloc] initWithString:_outline.title
                                                                   attributes:[[Appearance share] textAttributesForOutlineMain]];
        
        self.leadingCons.constant = outline.level * 10;
        
        self.main.preferredMaxLayoutWidth = [self mainPreferedMaxLayoutWidth];
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
    NSDictionary *viewDictionarys = @{@"OB" : self.outlineButton,
                                      @"M" : self.main};
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[OB(==44)]" options:0 metrics:nil views:viewDictionarys]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|-3-[M]" options:0 metrics:nil views:viewDictionarys]];
    [self.contentView addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:[OB(==44)][M]-10-|" options:0 metrics:nil views:viewDictionarys]];
    NSLayoutConstraint *leadingCons = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|[OB]" options:0 metrics:nil views:viewDictionarys][0];
    self.leadingCons = leadingCons;
    [self.contentView addConstraint:self.leadingCons];
    [self.main setContentHuggingPriority:749 forAxis:UILayoutConstraintAxisHorizontal];
    
    self.main.preferredMaxLayoutWidth = [self mainPreferedMaxLayoutWidth];
}

- (CGSize)intrinsicContentSize
{
    if (self.outline) {
        CGSize mainSize = self.main.intrinsicContentSize;
        CGFloat cellWidth = self.outlineButton.intrinsicContentSize.width + mainSize.width + self.outline.level * 10 + 10;
        CGFloat cellHeight = MAX(mainSize.height + 13, 44);
        return CGSizeMake(cellWidth, cellHeight);
    }   else {
        return CGSizeZero;
    }
}

- (CGFloat)mainPreferedMaxLayoutWidth
{
    return 320 - 44 - self.outline.level * 10 - 10;
}

- (void)expandOrCollapse
{
    self.outlineButton.selected = self.outlineButton.selected ? NO : YES;
    [self.delegate outlineCellDidTapButton:self];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    //    NSLog(@"Outline Cell %@ button frame: %@", self.outline.title, NSStringFromCGRect(self.outlineButton.frame));
    //    NSLog(@"Outline Cell %@ main frame: %@", self.outline.title, NSStringFromCGRect(self.main.frame));
}

@end

