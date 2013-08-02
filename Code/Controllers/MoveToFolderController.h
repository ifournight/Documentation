//
//  MoveToFolderController.h
//  Documentation
//
//  Created by Song Hui on 13-8-2.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkFolderDocument;
@protocol MoveToFolderControllerProtocol;

@interface MoveToFolderController : UIViewController<UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *bookmarksNeedToMove; // An array of Bookmarks that demanded to move to another folder.
@property (nonatomic, strong) BookmarkFolderDocument *currentFolderDocument; // The BookmarkFolderDocument that there bookmarks current reside in.
@property (nonatomic, strong) id<MoveToFolderControllerProtocol> delegate; // The delegate receives delegate method to fullfil the moveToFolder request.

@end

@protocol MoveToFolderControllerProtocol <NSObject>

- (void)moveToFolderController:(MoveToFolderController *)moveToFolderController
             needMoveBookmarks:(NSArray *)bookmarks
                    fromFolder:(BookmarkFolderDocument *)fromFolderDocument
                      toFolder:(BookmarkFolderDocument *)toFolderDocument;

- (void)moveToFolderControllerDemandDismiss;

@end