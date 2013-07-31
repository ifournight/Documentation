//
//  BookmarksController.h
//  Documentation
//
//  Created by Song Hui on 13-7-29.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkCell.h"

@class BookmarkFolderDocument;

// Responsible for display bookmarks inside specified BookmarkFolderDocument.
@interface BookmarksController : UIViewController<UITableViewDataSource, UITableViewDelegate, BookmarkCellDelegate>

// One BookmarkFolderDocument for one bookmarksController
@property (nonatomic, strong) BookmarkFolderDocument *bookmarkFolderDocument;

// TableView
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
