//
//  BookmarkFolderDocument.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkFolderDocument.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"

@implementation BookmarkFolderDocument

- (BOOL)loadFromContents:(id)contents ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    if ([contents length] > 0) {
        self.bookmarkFolder = [NSKeyedUnarchiver unarchiveObjectWithData:contents];
    }
    
    return YES;
}

- (id)contentsForType:(NSString *)typeName error:(NSError *__autoreleasing *)outError
{
    NSData *contents = [NSKeyedArchiver archivedDataWithRootObject:self.bookmarkFolder];
    
    return contents;
}

@end
