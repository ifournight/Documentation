//
//  BookmarkCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-28.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>

@class Bookmark;

@interface BookmarkCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *type;

@property (weak, nonatomic) IBOutlet UILabel *name;

@property (weak, nonatomic) IBOutlet UIButton *selectControl;

// Model
@property (nonatomic, strong) Bookmark *bookmark;

@end
