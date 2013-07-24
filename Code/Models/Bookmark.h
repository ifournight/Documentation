//
//  Bookmark.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class BookmarkFolder;

typedef NS_ENUM(NSInteger, BookmarkType) {
    BookmarkTypeGuide,
    BookmarkTypeReference,
    BookmarkTypeSampleCode
};

@interface Bookmark : NSObject<NSCoding>

@property (nonatomic, strong) NSString *name;
@property (nonatomic, assign) BookmarkType type;
@property (nonatomic, strong) NSURL *URL;
@property (nonatomic, strong) NSString *libraryIdentifier;
@property (nonatomic, strong) NSString *libraryName;
@property (nonatomic, weak) BookmarkFolder *folder;

- (id)initWithName:(NSString *)name;

- (NSURL *)URLForBookmark;

@end


