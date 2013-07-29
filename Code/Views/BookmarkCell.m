//
//  BookmarkCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-28.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkCell.h"
#import "Appearance.h"

@implementation BookmarkCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // BackgroundView
        UIImageView *background = [[UIImageView alloc] initWithImage:[[Appearance share] imageForBookmarkCellBackground]];
        self.backgroundView = background;
        self.backgroundColor = [UIColor clearColor];
        // SelectionBackgroundView
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        // Name Label BackgroundColor
        self.name.numberOfLines = 0;
        self.name.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
}

- (IBAction)selectControlPressed:(UIButton *)selectControl {
    if (selectControl.selected) {
        selectControl.selected = NO;
        [self setSelected:NO animated:YES];
    }   else {
        selectControl.selected = YES;
        [self setSelected:YES animated:YES];
    }
}


- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    if (editing) {
        self.selectControl.hidden = NO;
    }   else {
        self.selectControl.hidden = YES;
    }
    [self layoutSubviews];
}

- (void)setBookmark:(Bookmark *)bookmark
{
    // Type
    self.type.image = [[Appearance share] imageForBookmarkType:bookmark.type];
    // Name Attributed String
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:bookmark.name attributes:[[Appearance share] textAttributesForBookmarkName]];
    self.name.attributedText = attributedText;
    [self setNeedsLayout];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    CGFloat nameLabelWidthToFit = 0.0;
    if (self.editing) {
        nameLabelWidthToFit = self.bounds.size.width - 44.0 * 2;
        CGSize nameLabelSize = [self.name sizeThatFits:CGSizeMake(nameLabelWidthToFit, CGFLOAT_MAX)];
        self.name.frame = CGRectMake(44, 3, nameLabelSize.width, nameLabelSize.height);
        self.selectControl.hidden = NO;
    }   else {
        nameLabelWidthToFit = self.bounds.size.width - 44.0;
        CGSize nameLabelSize = [self.name sizeThatFits:CGSizeMake(nameLabelWidthToFit, CGFLOAT_MAX)];
        self.name.frame = CGRectMake(44, 3, nameLabelSize.width, nameLabelSize.height);
        self.selectControl.hidden = YES;
    }
}

@end
