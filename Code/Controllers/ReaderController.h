//
//  ReaderController.h
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Node, Token;

UIKIT_EXTERN NSString *const ReaderControllerNeedOpenPageNotification;
UIKIT_EXTERN NSString *const ReaderControllerNeedOpenPageObjectKey;

@interface ReaderController : UIViewController <UIWebViewDelegate, UIPopoverControllerDelegate, UINavigationControllerDelegate>

@property (weak, nonatomic) IBOutlet UIToolbar *readerbar;
@property (weak, nonatomic) IBOutlet UIWebView *webview;

- (void)openToken:(Token *)token;
- (void)openNode:(Node *)node;

@end
