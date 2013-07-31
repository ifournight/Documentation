//
//  BookmarkCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-28.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Bookmark, BookmarkCell;

@protocol BookmarkCellDelegate <NSObject>

- (void)bookmarkCell:(BookmarkCell *)bookmarkCell selectControlDidPressed:(UIButton *)selectControl;

@end

@interface BookmarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *type;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *selectControl;

@property (weak, nonatomic) id<BookmarkCellDelegate>delegate;

// Model
@property (nonatomic, strong) Bookmark *bookmark;

@end
