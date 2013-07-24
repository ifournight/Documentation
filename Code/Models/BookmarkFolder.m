//
//  BookmarkFolder.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkFolder.h"
#import "Bookmark.h"

@implementation BookmarkFolder

+ (id)newFolder
{
    BookmarkFolder *newFolder = [[BookmarkFolder alloc] init];
    
    if (newFolder) {
        newFolder.name = @"New Folder";
        newFolder.type = BookmarkFolderTypeNormal;
        newFolder.bookmarks = [[NSMutableArray alloc] init];
    }
    
    return newFolder;
}

+ (id)newFolderWithName:(NSString *)name bookmarks:(NSArray *)bookmarks
{
    BookmarkFolder *newFolder = [BookmarkFolder newFolder];
    
    if (newFolder) {
        newFolder.name = name;
        [newFolder.bookmarks addObjectsFromArray:bookmarks];
    }
    
    return newFolder;
}

+ (id)defaultFolder
{
    BookmarkFolder *defaultFolder = [[BookmarkFolder alloc] init];
    
    if (defaultFolder) {
        defaultFolder.name = @"Bookmarks";
        defaultFolder.type = BookmarkFolderTypeDefault;
        defaultFolder.bookmarks = [[NSMutableArray alloc] init];
    }
    
    return defaultFolder;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:@"name"];
        _type = [aDecoder decodeIntegerForKey:@"type"];
        _bookmarks = [aDecoder decodeObjectForKey:@"bookmarks"];
        if (!_bookmarks) {
            _bookmarks = [[NSMutableArray alloc] init];
        }
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:@"name"];
    [aCoder encodeInteger:self.type forKey:@"type"];
    if (!self.bookmarks) {
        self.bookmarks = [[NSMutableArray alloc] init];
    }
    [aCoder encodeObject:self.bookmarks forKey:@"bookmarks"];
}

@end