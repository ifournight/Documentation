//
//  BookmarkManager.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

UIKIT_EXTERN NSString *const BookmarkManagerDidReloadBookmarkFolderDocumentsNotification;

@class BookmarkFolderDocument, BookmarkFolder, Bookmark;

// Manage all bookmarkfolders and bookmarks workflow.
@interface BookmarkManager : NSObject

@property (nonatomic, strong) NSMutableArray *bookmarkFolderDocuments;

// Singleton
+ (id)share;

// Decide whether the give folder name is unique.
- (BOOL)uniqueBookmarkFolderName:(NSString *)name;

// For debug purpose.
- (void)deleteAllBookmarkFolderDocumentsWithCompletionHandler:(void(^)(void))completionHandler;

// Reload BookmarkFolderDocuments inside App's Documents Directory.
- (void)reloadBookmarkFolderDocumentsWithcompletionHandler:(void(^)(void))completionHandler;

// Create New default type BookmarkFolderDocuments.
// In completion handler the documents is open and ready to edit.
- (void)createDefaultFolderWithCompletionHandler:(void(^)(void))completionHandler;

// Create normal type BookmarkFolderDocuments with given name and bookmarks
// In completion handler the documents is open and ready to edit.
- (void)createFolderWithName:(NSString *)name
                   bookmarks:(NSArray *)bookmarks
       WithCompletionHandler:(void(^)(void))completionHandler;

// Remove the folder in file system and in-memory.
- (void)deleteFolder:(BookmarkFolderDocument *)folderDocument
WithCompletionHandler:(void(^)(void))completionHandler;

// TODO:The naming is temporary.
// When App enters background, call this method,
// It will make sure all changes saved and other stuff.
- (void)doSomethingBeforeGoingToBackground;

// Rename Folder
- (void)renameFolder:(BookmarkFolderDocument *)folderDocument
              toName:(NSString *)newName
WithCompletionHandler:(void(^)(void))completionHandler;

// Add given bookmarks into given folder.
- (void)addBookmarks:(NSArray *)addedBookmarks
            toFolder:(BookmarkFolderDocument *)folderDocument
WithCompletionHandler:(void(^)(void))completionHandler;

// Delete given bookmarks within give folder.
- (void)deleteBookmarks:(NSArray *)deletedBookmarks
               inFolder:(BookmarkFolderDocument *)folderDocument
  WithCompletionHandler:(void(^)(void))completionHandler;

// Move bookmarks from one folder to another.
- (void)moveBookmarks:(NSArray *)bookmarks
           fromFolder:(BookmarkFolderDocument *)fromFolderDocument
             toFolder:(BookmarkFolderDocument *)toFolderDocument
WithCompletionHandler:(void(^)(void))completionHandler;

@end

