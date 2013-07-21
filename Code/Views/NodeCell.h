//
//  NodeCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchNode;

@interface NodeCell : UITableViewCell

@property (strong, nonatomic) SearchNode *node;

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *main;

@end
