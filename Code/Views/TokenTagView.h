//
//  TokenTagView.h
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <UIKit/UIKit.h>

UIKIT_EXTERN NSString *const TokenTagViewTextKey;
UIKIT_EXTERN NSString *const TokenTagViewTypeKey;

// Custom View to display token's container and deprecatedSinceVersion in TokenCell
@interface TokenTagView : UIView

@property (strong, nonatomic) NSArray *tagDictionarys;

- (id)initWithTagDictionarys:(NSArray *)tagDictionarys;

@end
