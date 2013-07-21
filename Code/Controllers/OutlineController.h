//
//  OutlineController.h
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <QuartzCore/QuartzCore.h>
#import "OutlineCell.h"

@class Book;

@interface OutlineController : UIViewController<UITabBarControllerDelegate, UITableViewDataSource, UITableViewDelegate, OutlineCellDelegate>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) Book *book;

- (void)reloadContentsSizeInPopoverView;

@end
