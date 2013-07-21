//
//  SearchController.h
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchManager.h"

@interface SearchController : UIViewController<UISearchBarDelegate, UITableViewDataSource, UITableViewDelegate, SearchManagerDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchbar;
@property (weak, nonatomic) IBOutlet UIView *searchbarShadow;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end
