//
//  OutlineCell.h
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Outline;

@protocol OutlineCellDelegate;

@interface OutlineCell : UITableViewCell

@property (nonatomic, strong) UIButton *outlineButton;
@property (nonatomic, strong) UILabel *main;
@property (nonatomic, strong) Outline *outline;
@property (nonatomic, weak) id<OutlineCellDelegate>delegate;

@end

@protocol OutlineCellDelegate <NSObject>

-(void)outlineCellDidTapButton:(OutlineCell *)cell;

@end
