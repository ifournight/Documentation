//
//  Appearance.h
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <QuartzCore/QuartzCore.h>
#import "Bookmark.h"

@class SSegmentedControl;

typedef NS_ENUM(NSInteger, TokenTagViewType) {
    TokenTagViewTypeContainer,
    TokenTagViewTypeDeprecated
};

// Back up the entire app's appearance customazition.
@interface Appearance : NSObject

+ (id)share;

// Fonts

- (UIFont *)helveticaNeveWithSize:(CGFloat)fontSize;

- (UIFont *)helveticaNeveBoldWithSize:(CGFloat)fontSize;

// Text Attributes

- (NSDictionary *)textAttributesForTagWithType:(TokenTagViewType)type;

- (NSDictionary *)textAttributesForTokenMain;

- (NSDictionary *)textAttributesForTokenMainHighlight;

- (NSDictionary *)textAttributesForTokenDescription;

- (NSDictionary *)textAttributesForNodeMain;

- (NSDictionary *)textAttributesForSearchHeader;

- (NSDictionary *)textAttributesForReaderBarTitle;

- (NSDictionary *)textAttributesForOutlineMain;

- (NSDictionary *)titleTextAttributesForNavBar;

- (NSDictionary *)titleTextAttributesForNavBarButton;

- (NSDictionary *)textAttributesForBookmarkName;

// Images

- (UIImage *)imageForTagBorderWithType:(TokenTagViewType)type;

- (UIImage *)imageForTokenCellBackground;

- (UIImage *)imageForSideViewShadow;

- (UIImage *)imageForTokenType:(NSString *)type;

- (UIImage *)imageForNodeType:(NSString *)nodeType documentType:(NSInteger)documentType;

- (UIImage *)imageForSearchHeaderBackground;

- (UIImage *)imageForSearchBarBackground;

- (UIImage *)imageForSearchBarField;

- (UIImage *)imageForSearchBarIconSearch;

- (UIImage *)imageForSearchBarIconCancel;

- (UIImage *)imageForReaderBarBackground;

- (UIImage *)imageForReaderBarShadow;

- (UIImage *)imageForReaderPopoverBorder;

- (UIImage *)imageForReaderPopoverArrow;

- (UIImage *)imageForNavBarBackground;

- (UIImage *)imageForNavBarShadow;

- (UIImage *)imageForRenameTextFieldBackground;

- (UIImage *)imageForBookmarkType:(BookmarkType)bookmarkType;

- (UIImage *)imageForBookmarkCellBackground;

// Buttons

- (UIButton *)readerBarButtonWithImageName:(NSString *)imageName;

- (UIButton *)outlineButton;

- (SSegmentedControl *)segmentedControl;

// Text Shadow

- (void)addTextShadowForLabel:(UILabel *)label
                    withColor:(UIColor *)color
                       offset:(CGSize)offset;

// Custom Bars
- (void)customSearchBar:(UISearchBar *)searchbar shadow:(UIView *)searchbarShadow;

- (void)customReaderBar:(UIToolbar *)readerBar;

- (void)customWebView:(UIWebView *)webView;

- (void)customReaderPopoverBorderShadow:(UIImageView *)border;

- (void)customNavBar:(UINavigationBar *)navBar;

- (void)customNavBarButton:(UIBarButtonItem *)barButtonItem;

- (void)customToolKitBar:(UIToolbar *)toolKitBar;

- (void)customToolBar:(UIToolbar *)toolBar;

- (void)customToolBarButton:(UIBarButtonItem *)barButtonItem;

@end
