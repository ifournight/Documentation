//
//  BookmarkFolderController.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "BookmarkFolderNormalCell.h"
#import "NewBookmarkFolderController.h"

@interface BookmarkFolderController : UIViewController<BookmarkFolderNormalCellDelegate, NewBookmarkFolderDelegate, UITableViewDataSource, UITableViewDelegate>

//@interface BookmarkFolderController : UIViewController<BookmarkFolderNormalCellDelegate, UITableViewDataSource, UITableViewDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

