//
//  BookmarkManager.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkManager.h"
#import "BookmarkFolderDocument.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"

NSString *const BookmarkManagerDidReloadBookmarkFolderDocumentsNotification = @"BookmarkManagerDidReloadBookmarkFolderDocumentsNotification";

typedef void (^OnFolderReady) (void);

@interface BookmarkManager ()

- (NSString *)bookmarkFolderDocumentsPath;
- (NSURL *)newFolderURL;
- (void)performWithFolder:(BookmarkFolderDocument *)folderDocument
            onFolderReady:(OnFolderReady)onFolderReady;

@end
@implementation BookmarkManager

- (id)init
{
    self = [super init];
    if (self) {
        _bookmarkFolderDocuments = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)share
{
    static BookmarkManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[BookmarkManager alloc] init];
    });
    return share;
}

- (BOOL)uniqueBookmarkFolderName:(NSString *)name
{
    BOOL unique = YES;
    for (BookmarkFolderDocument *document in self.bookmarkFolderDocuments) {
        if ([name isEqualToString:document.bookmarkFolder.name]) {
            unique = NO;
            break;
        }
    }
    return unique;
}

- (void)deleteAllBookmarkFolderDocumentsWithCompletionHandler:(void(^)(void))completionHandler
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Locate Bookmark Folder Path
    NSArray *filePaths = [fileManager contentsOfDirectoryAtPath:[self bookmarkFolderDocumentsPath] error:nil];
    // Compose Full Paths
    NSMutableArray *fullFilePaths = [[NSMutableArray alloc] init];
    for (NSString *filePath in filePaths) {
        NSString *fullFilePath = [[self bookmarkFolderDocumentsPath] stringByAppendingPathComponent:filePath];
        NSLog(@"Full Path: %@", fullFilePath);
        [fullFilePaths addObject:fullFilePath];
    }
    filePaths = fullFilePaths;
    // Find folder fileURLs
    filePaths = [filePaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *path = evaluatedObject;
        if ([path.pathExtension isEqualToString:@"folder"]) {
            return YES;
        }   else {
            return NO;
        }
    }]];
    
    for (NSString *filePath in filePaths) {
        NSError *error = nil;
        [fileManager removeItemAtPath:filePath error:&error];
        if (error) {
            NSLog(@"%@", [error description]);
        }   else {
            NSLog(@"Delete file at URL: %@", filePath);
        }
    }
    completionHandler();
}

- (void)reloadBookmarkFolderDocumentsWithcompletionHandler:(void(^)(void))completionHandler
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    // Locate Bookmark Folder Path
    NSArray *filePaths = [fileManager contentsOfDirectoryAtPath:[self bookmarkFolderDocumentsPath] error:nil];
    // Compose Full Paths
    NSMutableArray *fullFilePaths = [[NSMutableArray alloc] init];
    for (NSString *filePath in filePaths) {
        NSString *fullFilePath = [[self bookmarkFolderDocumentsPath] stringByAppendingPathComponent:filePath];
        NSLog(@"Full Path: %@", fullFilePath);
        [fullFilePaths addObject:fullFilePath];
    }
    filePaths = fullFilePaths;
    // Find folder fileURLs
    filePaths = [filePaths filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(id evaluatedObject, NSDictionary *bindings) {
        NSString *path = evaluatedObject;
        if ([path.pathExtension isEqualToString:@"folder"]) {
            return YES;
        }   else {
            return NO;
        }
    }]];
    // If files exsit, load documents, open them
    if (filePaths.count > 0) {
        // First sort fileURLs according to NSFileCreationDate
        filePaths = [filePaths sortedArrayUsingComparator:^NSComparisonResult(NSString *path1, NSString *path2) {
            NSDate *path1Date = [fileManager attributesOfItemAtPath:path1 error:nil][NSFileCreationDate];
            NSDate *path2Date = [fileManager attributesOfItemAtPath:path2 error:nil][NSFileCreationDate];
            // aesendint order
            return [path1Date compare:path2Date];
        }];
        __block NSMutableArray *bookmarkFolderDocuments = [[NSMutableArray alloc] init];
        // When all documents opened
        void (^onAllDocumentsOpened)(void) = ^() {
            // Check if default folder is in index 0, if not, ajust.
            BookmarkFolderDocument *defaultFolder = nil;
            for (BookmarkFolderDocument *folderDocument in bookmarkFolderDocuments) {
                if (folderDocument.bookmarkFolder.type == BookmarkFolderTypeDefault) {
                    defaultFolder = folderDocument;
                }
            }
            if ([bookmarkFolderDocuments indexOfObject:defaultFolder] == 0) {
            }   else {
                NSLog(@"Something is not right, default folder is not in index 0, ajust it, but it is buggy");
                [bookmarkFolderDocuments removeObject:defaultFolder];
                [bookmarkFolderDocuments insertObject:defaultFolder atIndex:0];
            }
            self.bookmarkFolderDocuments = bookmarkFolderDocuments;
            // CompletionHandler
            NSLog(@"%d documents exsits in bookmark Folder", self.bookmarkFolderDocuments.count);
            completionHandler();
        };
        // Create, open all documents
        for (NSString *filePath in filePaths) {
            BookmarkFolderDocument *folderDocument = [[BookmarkFolderDocument alloc] initWithFileURL:[NSURL fileURLWithPath:filePath]];
            [folderDocument openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    [bookmarkFolderDocuments addObject:folderDocument];
                    if (filePaths.count == bookmarkFolderDocuments.count) {
                        onAllDocumentsOpened();
                    }
                }   else {
                    NSLog(@"BookmarkFolderDocument: %@ fail to open.", filePath);
                }
            }];
        }
        // No file, means no foler, create default one
    }   else {
        NSLog(@"No folder document exsits in bookmark folder");
        self.bookmarkFolderDocuments = [[NSMutableArray alloc] init];
        [self createDefaultFolderWithCompletionHandler:^{
            completionHandler();
        }];
    }
}

- (NSString *)bookmarkFolderDocumentsPath
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSString *documentDir = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    
    NSString *bookmarkFolderDocumentsPath = [documentDir stringByAppendingPathComponent:@"Bookmarks"];
    BOOL pathExist = [fileManager fileExistsAtPath:bookmarkFolderDocumentsPath isDirectory:nil];
    if (!pathExist) {
        [fileManager createDirectoryAtPath:bookmarkFolderDocumentsPath withIntermediateDirectories:YES attributes:nil error:nil];
    }
    NSLog(@"BookmarkFolderDocumentsPath: %@", bookmarkFolderDocumentsPath);
    return bookmarkFolderDocumentsPath;
}

- (void)createDefaultFolderWithCompletionHandler:(void(^)(void))completionHandler
{
    NSURL *newFolderURL = [self newFolderURL];
    BookmarkFolderDocument *newFolderDocument = [[BookmarkFolderDocument alloc] initWithFileURL:newFolderURL];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:newFolderURL.path isDirectory:NO]) {
        [newFolderDocument saveToURL:newFolderURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [newFolderDocument openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    newFolderDocument.bookmarkFolder = [BookmarkFolder defaultFolder];
                    [self.bookmarkFolderDocuments addObject:newFolderDocument];
                    [newFolderDocument updateChangeCount:UIDocumentChangeDone];
                    NSLog(@"Create Default Folder");
                    completionHandler();
                }   else {
                    NSLog(@"Create and open default folder document failed.");
                }
                
            }];
        }];
    }
}

- (void)createFolderWithCompletionHandler:(void(^)(void))completionHandler
{
    NSURL *newFolderURL = [self newFolderURL];
    BookmarkFolderDocument *newFolderDocument = [[BookmarkFolderDocument alloc] initWithFileURL:newFolderURL];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:newFolderURL.path isDirectory:NO]) {
        [newFolderDocument saveToURL:newFolderURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [newFolderDocument openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    newFolderDocument.bookmarkFolder = [BookmarkFolder newFolder];
                    [self.bookmarkFolderDocuments addObject:newFolderDocument];
                    [newFolderDocument updateChangeCount:UIDocumentChangeDone];
                    completionHandler();
                }   else {
                    NSLog(@"Create Folder Document Failed");
                }
            }];
        }];
    }
}

- (void)createFolderWithName:(NSString *)name
                   bookmarks:(NSArray *)bookmarks
       WithCompletionHandler:(void(^)(void))completionHandler
{
    NSURL *newFolderURL = [self newFolderURL];
    BookmarkFolderDocument *newFolderDocument = [[BookmarkFolderDocument alloc] initWithFileURL:newFolderURL];
    NSFileManager *defaultManager = [NSFileManager defaultManager];
    if (![defaultManager fileExistsAtPath:newFolderURL.path isDirectory:NO]) {
        [newFolderDocument saveToURL:newFolderURL forSaveOperation:UIDocumentSaveForCreating completionHandler:^(BOOL success) {
            [newFolderDocument openWithCompletionHandler:^(BOOL success) {
                if (success) {
                    newFolderDocument.bookmarkFolder = [BookmarkFolder newFolderWithName:name bookmarks:bookmarks];
                    [self.bookmarkFolderDocuments addObject:newFolderDocument];
                    [newFolderDocument updateChangeCount:UIDocumentChangeDone];
                    NSLog(@"Create Folder Document With Name:%@", name);
                    completionHandler();
                }   else {
                    NSLog(@"Create folder document with name:%@ failed", name);
                }
            }];
        }];
    }   else {
        NSLog(@"BookmarkManager create foler fail because folder file already exsit");
    }
}

- (void)doSomethingBeforeGoingToBackground
{
    for (BookmarkFolderDocument *folderDocument in self.bookmarkFolderDocuments) {
        [folderDocument saveToURL:folderDocument.fileURL
                 forSaveOperation:UIDocumentSaveForOverwriting
                completionHandler:nil];
    }
}

- (NSURL *)newFolderURL
{
    NSURL *newFolderURL = nil;
    
    NSString *bookmarkFolderDocumentsPath = [self bookmarkFolderDocumentsPath];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy_MM_dd_hh-mm-s"];
    NSString *dateString = [dateFormatter stringFromDate:date];
    NSString *fileNamePath = [NSString stringWithFormat:@"XC_%@.%@", dateString, @"folder"];
    NSLog(@"New Folder File Name Path: %@", fileNamePath);
    
    NSString *newFolderPath = [bookmarkFolderDocumentsPath stringByAppendingPathComponent:fileNamePath];
    newFolderURL = [NSURL fileURLWithPath:newFolderPath];
    
    return newFolderURL;
}

- (void)deleteFolder:(BookmarkFolderDocument *)folderDocument WithCompletionHandler:(void(^)(void))completionHandler
{
    void (^onFolderClosed)(BOOL) = ^(BOOL success) {
        NSFileCoordinator *fileCoordinator = [[NSFileCoordinator alloc] initWithFilePresenter:nil];
        [fileCoordinator coordinateWritingItemAtURL:folderDocument.fileURL options:NSFileCoordinatorWritingForDeleting error:nil byAccessor:^(NSURL *newURL) {
            NSFileManager *fileManager = [[NSFileManager alloc] init];
            [fileManager removeItemAtURL:folderDocument.fileURL error:nil];
            completionHandler();
        }];
        [self.bookmarkFolderDocuments removeObject:folderDocument];
    };
    
    if (folderDocument.documentState == UIDocumentStateNormal) {
        [folderDocument closeWithCompletionHandler:onFolderClosed];
    }   else if (folderDocument.documentState == UIDocumentStateClosed) {
        onFolderClosed(YES);
    }
}

- (void)renameFolder:(BookmarkFolderDocument *)folderDocument toName:(NSString *)newName WithCompletionHandler:(void(^)(void))completionHandler
{
    __block BookmarkFolderDocument *blockFolderDocument = folderDocument;
    OnFolderReady onFolderReady = ^() {
        blockFolderDocument.bookmarkFolder.name = newName;
        [blockFolderDocument updateChangeCount:UIDocumentChangeDone];
        completionHandler();
    };
    [self performWithFolder:folderDocument onFolderReady:onFolderReady];
}

- (void)addBookmarks:(NSArray *)addedBookmarks toFolder:(BookmarkFolderDocument *)folderDocument WithCompletionHandler:(void(^)(void))completionHandler
{
    __block NSArray *blockBookmarks = addedBookmarks;
    __block BookmarkFolderDocument *blockFolderDocument = folderDocument;
    OnFolderReady onFolderReady = ^() {
        // KVO compliance
        NSIndexSet *indexs = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, addedBookmarks.count)];
        [blockFolderDocument.bookmarkFolder insertBookmarks:addedBookmarks atIndexes:indexs];
        // Bookmarks folder change.
        for (Bookmark *bookmark in blockBookmarks) {
            bookmark.folder = blockFolderDocument.bookmarkFolder;
        }
        [blockFolderDocument updateChangeCount:UIDocumentChangeDone];
        completionHandler();
    };
    [self performWithFolder:folderDocument onFolderReady:onFolderReady];
}

- (void)deleteBookmarks:(NSArray *)deletedBookmarks inFolder:(BookmarkFolderDocument *)folderDocument WithCompletionHandler:(void(^)(void))completionHandler
{
    __block BookmarkFolderDocument *blockFolderDocument = folderDocument;
    OnFolderReady onFolderReady = ^() {
        NSMutableArray *bookmarks = blockFolderDocument.bookmarkFolder.bookmarks;
        NSIndexSet *indexs = [bookmarks indexesOfObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, bookmarks.count)] options:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [bookmarks containsObject:obj];
        }];
        [blockFolderDocument.bookmarkFolder removeBookmarksAtIndexes:indexs];
        [blockFolderDocument updateChangeCount:UIDocumentChangeDone];
        completionHandler();
    };
    [self performWithFolder:folderDocument onFolderReady:onFolderReady];
}

- (void)moveBookmarks:(NSArray *)bookmarks fromFolder:(BookmarkFolderDocument *)fromFolderDocument toFolder:(BookmarkFolderDocument *)toFolderDocument WithCompletionHandler:(void(^)(void))completionHandler
{
    __block BookmarkFolderDocument *blockFromFolderDocument = fromFolderDocument;
    __block BookmarkFolderDocument *blockToFolderDocument = toFolderDocument;
    __block NSArray *blockBookmarks = bookmarks;
    OnFolderReady onToFolderReady = ^() {
        NSIndexSet *indexes = [NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, bookmarks.count)];
        [blockToFolderDocument.bookmarkFolder insertBookmarks:bookmarks atIndexes:indexes];
        // Bookmarks folder change.
        [blockToFolderDocument updateChangeCount:UIDocumentChangeDone];
        for (Bookmark *bookmark in blockBookmarks) {
            bookmark.folder = blockToFolderDocument.bookmarkFolder;
        }
    };
    
    OnFolderReady onFromFolderReady = ^() {
        NSMutableArray *bookmarks = blockFromFolderDocument.bookmarkFolder.bookmarks;
        NSIndexSet *indexs = [bookmarks indexesOfObjectsAtIndexes:[NSIndexSet indexSetWithIndexesInRange:NSMakeRange(0, bookmarks.count)] options:NSEnumerationConcurrent passingTest:^BOOL(id obj, NSUInteger idx, BOOL *stop) {
            return [bookmarks containsObject:obj];
        }];
        [blockFromFolderDocument.bookmarkFolder removeBookmarksAtIndexes:indexs];
        [blockFromFolderDocument updateChangeCount:UIDocumentChangeDone];
        completionHandler();
    };
    [self performWithFolder:toFolderDocument onFolderReady:onToFolderReady];
    [self performWithFolder:fromFolderDocument onFolderReady:onFromFolderReady];
}


- (void)performWithFolder:(BookmarkFolderDocument *)folderDocument onFolderReady:(OnFolderReady)onFolderReady
{
    void (^onFolderDidLoaded)(BOOL);
    onFolderDidLoaded = ^(BOOL success) {
        if (success) {
            onFolderReady();
        }   else {
            NSLog(@"PerformWithFolder open document failed");
        }
    };
    if (folderDocument.documentState == UIDocumentStateClosed) {
        [folderDocument openWithCompletionHandler:onFolderDidLoaded];
    }   else if (folderDocument.documentState == UIDocumentStateNormal) {
        onFolderDidLoaded(YES);
    }
}

@end
