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
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
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
    [self.delegate bookmarkCell:self selectControlDidPressed:selectControl];
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:YES];
    if (editing) {
        self.selectControl.hidden = NO;
        self.selectControl.selected = NO;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }   else {
        self.selectControl.selected = NO;
        self.selectControl.hidden = YES;
        self.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    [self layoutSubviews];
}

- (void)setBookmark:(Bookmark *)bookmark
{
    _bookmark = bookmark;
    // Type
    self.type.image = [[Appearance share] imageForBookmarkType:bookmark.type];
    // Name Attributed String
    NSAttributedString *attributedText = [[NSAttributedString alloc] initWithString:bookmark.name attributes:[[Appearance share] textAttributesForBookmarkName]];
    self.name.attributedText = attributedText;
    [self setNeedsLayout];
}

- (CGSize)intrinsicContentSize
{
    if (self.bookmark) {
        CGFloat nameLabelWidthToFit = self.bounds.size.width - 44.0;
        CGSize nameLabelSize = [self.name sizeThatFits:CGSizeMake(nameLabelWidthToFit, CGFLOAT_MAX)];
        CGFloat cellHeight = MAX(nameLabelSize.height + 13, 44);
        return CGSizeMake(320.0, cellHeight);
    }   else {
        return CGSizeZero;
    }
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