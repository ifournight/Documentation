//
//  BookmarkFolder.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Bookmark;

typedef NS_ENUM(NSInteger, BookmarkFolderType) {
    BookmarkFolderTypeNormal,
    BookmarkFolderTypeDefault
};

@interface BookmarkFolder : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BookmarkFolderType type;
@property (nonatomic, strong) NSMutableArray *bookmarks;

+ (id)newFolder;
+ (id)newFolderWithName:(NSString *)name bookmarks:(NSArray *)bookmarks;
+ (id)defaultFolder;

@end