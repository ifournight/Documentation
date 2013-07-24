//
//  NewBookmarkFolderController.h
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol NewBookmarkFolderDelegate;

@interface NewBookmarkFolderController : UIViewController<UIAlertViewDelegate>
@property (weak, nonatomic) id<NewBookmarkFolderDelegate> delegate;
@end

@protocol NewBookmarkFolderDelegate <NSObject>

- (void)newBookmarkFolderDidDoneWithName:(NSString *)name;

- (void)newBookmarkFolderDidCancel;

@end

