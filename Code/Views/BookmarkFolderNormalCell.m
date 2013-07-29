//
//  BookmarkFolderNormalCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkFolderNormalCell.h"
#import "BookmarkFolder.h"

@interface BookmarkFolderNormalCell ()

// Left view in normal mode.
@property (weak, nonatomic) IBOutlet UIImageView *folder;
// Folder's name.
@property (weak, nonatomic) IBOutlet UILabel *name;
// Folder's bookmarks count
@property (weak, nonatomic) IBOutlet UILabel *count;
// Right view in normal mode.
@property (weak, nonatomic) IBOutlet UIImageView *discloure;
// Left view in editing mode.
@property (weak, nonatomic) IBOutlet UIButton *delete;
// Right view in editing mode.
@property (weak, nonatomic) IBOutlet UIButton *edit;

@end

@implementation BookmarkFolderNormalCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // BackgroundView
        UIImage *background = [[UIImage imageNamed:@"BookmarkFolderNormalCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(3.0, 13.0, 3.0, 13.0)
                                                                                                         resizingMode:UIImageResizingModeTile];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
        // TODO: Selection BackgroundView
    }
    return self;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        // Pre-animation
        self.delete.hidden = NO;
        self.edit.hidden = NO;
        self.delete.alpha = 0.0;
        self.edit.alpha = 0.0;
        [UIView animateWithDuration:0.25 delay:0.0 options:0 animations:^{
            self.folder.alpha = 0.0;
            self.discloure.alpha = 0.0;
            self.delete.alpha = 1.0;
            self.edit.alpha = 1.0;
        } completion:^(BOOL finished) {

        }];
    }   else {
        self.folder.alpha = 1.0;
        self.discloure.alpha = 1.0;
        [UIView animateWithDuration:0.2 delay:0.0 options:0 animations:^{
            self.delete.alpha = 0.0;
            self.edit.alpha = 0.0;
        } completion:^(BOOL finished) {
            self.delete.hidden = YES;
            self.edit.hidden = YES;
        }];
    }
}

- (void)setBookmarkFolder:(BookmarkFolder *)bookmarkFolder
{
    [_bookmarkFolder removeObserver:self forKeyPath:@"name"];
    [_bookmarkFolder removeObserver:self forKeyPath:@"bookmarks"];
    
    _bookmarkFolder = bookmarkFolder;
    // KVO Observation.
    [bookmarkFolder addObserver:self forKeyPath:@"name" options:NSKeyValueObservingOptionNew context:NULL];
    [bookmarkFolder addObserver:self forKeyPath:@"bookmarks" options:NSKeyValueObservingOptionNew context:NULL];
    self.name.text = _bookmarkFolder.name;
    self.count.text = [NSString stringWithFormat:@"%D", _bookmarkFolder.bookmarks.count];
}

- (IBAction)deleteButtonPressed:(id)sender {
    [self.delegate bookmarkFolderCell:self didTapDelelteButton:sender];
}

- (IBAction)editButtonPressed:(id)sender {
    [self.delegate bookmarkFolderCell:self didTapEditButton:sender];
}

#pragma mark - Bookmark Folder KVO

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    if ([object isKindOfClass:[BookmarkFolder class]]) {
        if ([keyPath isEqualToString:@"name"]) {
            self.name.text = self.bookmarkFolder.name;
        }   else if ([keyPath isEqualToString:@"bookmarks"]) {
            self.count.text = [NSString stringWithFormat:@"%D", self.bookmarkFolder.bookmarks.count];
        }
    }
}

@end
