//
//  BookmarkFolderDefaultCell.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkFolderDefaultCell.h"
#import "BookmarkFolder.h"

@interface BookmarkFolderDefaultCell ()

@property (weak, nonatomic) IBOutlet UIImageView *folder;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UIImageView *disclosure;

@end

@implementation BookmarkFolderDefaultCell

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self) {
        // Background
        UIImage *background = [[UIImage imageNamed:@"BookmarkFolderDefaultCellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 10.0, 1.0, 10.0)];
        self.backgroundView = [[UIImageView alloc] initWithImage:background];
    }
    return self;
}

- (void)setBookmarkFolder:(BookmarkFolder *)bookmarkFolder
{
    _bookmarkFolder = bookmarkFolder;
    self.name.text = bookmarkFolder.name;
}

@end
