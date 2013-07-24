//
//  BookmarkFolderDocument.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkFolder, Bookmark;

@interface BookmarkFolderDocument : UIDocument

@property (nonatomic, strong) BookmarkFolder *bookmarkFolder;

@end
