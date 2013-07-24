//
//  BookmarkFolderNormalCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class BookmarkFolder;

@protocol BookmarkFolderNormalCellDelegate;

@interface BookmarkFolderNormalCell : UITableViewCell

@property (nonatomic, strong) BookmarkFolder *bookmarkFolder;

@property (nonatomic, weak) id<BookmarkFolderNormalCellDelegate> delegate;

@end

@protocol BookmarkFolderNormalCellDelegate <NSObject>

@optional

- (void)bookmarkFolderCell:(BookmarkFolderNormalCell *)bookmarkFolderCell didTapDelelteButton:(UIButton *)deleteButton;

- (void)bookmarkFolderCell:(BookmarkFolderNormalCell *)bookmarkFolderCell didTapEditButton:(UIButton *)editButton;

@end