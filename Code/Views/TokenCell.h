//
//  TokenCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class SearchToken, TokenTagView;

@interface TokenCell : UITableViewCell

@property (strong, nonatomic) SearchToken *token;

@property (strong, nonatomic) UIImageView *icon;

@property (strong, nonatomic) UILabel *main;

@property (strong, nonatomic) TokenTagView *tagView;

@property (strong, nonatomic) UILabel *description;

@end
