//
//  Appearance.m
//  Documentation
//
//  Created by Song Hui on 13-7-19.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "Appearance.h"
#import "SSegmentedControl.h"

@implementation Appearance

+ (id)share
{
    static Appearance *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[Appearance alloc] init];
    });
    return share;
}

#pragma mark - Fonts

- (UIFont *)helveticaNeveWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue" size:fontSize];
}

- (UIFont *)helveticaNeveBoldWithSize:(CGFloat)fontSize
{
    return [UIFont fontWithName:@"HelveticaNeue-Bold" size:fontSize];
}

#pragma mark - Images

- (UIImage *)imageForTagBorderWithType:(TokenTagViewType)type
{
    UIImage *image = nil;
    NSString *imageName = nil;
    UIEdgeInsets edgeInsets = UIEdgeInsetsMake(2.0, 2.0, 2.0, 2.0);
    if (type == TokenTagViewTypeContainer) {
        imageName = @"TokenTagBorderContainer";
    }   else {
        imageName = @"TokenTagBorderDeprecated";
    }
    image = [[UIImage imageNamed:imageName] resizableImageWithCapInsets:edgeInsets
                                                           resizingMode:UIImageResizingModeStretch];
    return image;
}

- (UIImage *)imageForTokenCellBackground
{
    UIImage *image = [[UIImage imageNamed:@"CellBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)
                                                                            resizingMode:UIImageResizingModeStretch];
    return image;
}

- (UIImage *)imageForSideViewShadow
{
    UIImage *image = [[UIImage imageNamed:@"SideView-Shadow"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    return image;
}

- (UIImage *)imageForTokenType:(NSString *)type
{
    UIImage *image = [UIImage imageNamed:type];
    
    return image;
}

- (UIImage *)imageForNodeType:(NSString *)nodeType documentType:(NSInteger)documentType
{
    UIImage *image = nil;
    
    if ([nodeType isEqualToString:@"file"]) {
        image = [UIImage imageNamed:@"Book"];
    }   else {
        if (documentType == 0) {
            image = [UIImage imageNamed:@"Book"];
        }   else if (documentType == 1) {
            image = [UIImage imageNamed:@"SampleCode"];
        }   else if (documentType == 2) {
            image = [UIImage imageNamed:@"Reference"];
        }   else {
            image = [UIImage imageNamed:@"Book"];
        }
    }
    return image;
}

- (UIImage *)imageForSearchHeaderBackground
{
    return [UIImage imageNamed:@"SearchHeaderBackground"];
}

- (UIImage *)imageForSearchBarBackground
{
    UIImage *image = [[UIImage imageNamed:@"SearchBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
    
    return image;
}

- (UIImage *)imageForSearchBarShadow
{
    UIImage *image = [[UIImage imageNamed:@"SearchBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)imageForSearchBarField
{
    UIImage *image = [[UIImage imageNamed:@"SearchBarField"] resizableImageWithCapInsets:UIEdgeInsetsMake(4.0, 15.0, 5.0, 15.0)
                                                                            resizingMode:UIImageResizingModeStretch];
    return image;
}

- (UIImage *)imageForSearchBarIconCancel
{
    return [UIImage imageNamed:@"SearchBarCancel"];
}

- (UIImage *)imageForSearchBarIconSearch
{
    return [UIImage imageNamed:@"SearchBarSearch"];
}

- (UIImage *)imageForReaderBarBackground
{
    UIImage *image = [[UIImage imageNamed:@"ReaderBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    
    return image;
}

- (UIImage *)imageForReaderBarShadow
{
    return [[UIImage imageNamed:@"ReaderBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsZero];
}

- (UIImage *)imageForReaderPopoverBorder
{
    UIImage *image = [[UIImage imageNamed:@"ReaderPopoverBorder"] resizableImageWithCapInsets:UIEdgeInsetsMake(10.0, 10.0, 10.0, 10.0)];
    return image;
    
}

- (UIImage *)imageForReaderPopoverArrow
{
    return [UIImage imageNamed:@"ReaderPopoverArrow"];
}

- (UIImage *)imageForNavBarBackground
{
    UIImage *image = [[UIImage imageNamed:@"SearchBarBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(1.0, 0.0, 1.0, 0.0)];
    return image;
}

- (UIImage *)imageForNavBarShadow
{
    UIImage *image = [[UIImage imageNamed:@"SearchBarShadow"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    return image;
}

- (UIImage *)imageForRenameTextFieldBackground
{
    UIImage *image = [[UIImage imageNamed:@"FolderRenameTextFieldBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(6.0, 6.0, 6.0, 6.0)];
    return image;
}

- (UIImage *)imageForBookmarkType:(BookmarkType)bookmarkType
{
    NSString *imageName = @"Book";
    if (bookmarkType == BookmarkTypeGuide) {
        imageName = @"Book";
    }   else if (bookmarkType == BookmarkTypeReference) {
        imageName = @"Reference";
    }   else if (bookmarkType == BookmarkTypeSampleCode) {
        imageName = @"SampleCode";
    }
    UIImage *image = [UIImage imageNamed:imageName];
    return image;
}

- (UIImage *)imageForBookmarkCellBackground
{
    return [self imageForTokenCellBackground];
}

#pragma mark - Text Attributes;

- (NSDictionary *)textAttributesForTagWithType:(TokenTagViewType)type
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = nil;
    
    if (type == TokenTagViewTypeContainer) {
        textColor = [UIColor colorWithRed:0.47 green:0.47 blue:0.47 alpha:1.0];
    }   else {
        textColor = [UIColor whiteColor];
    }
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:10.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
}

- (NSDictionary *)textAttributesForTokenMain
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.minimumLineHeight = 21.0;
    paragraphStyle.maximumLineHeight = 21.0;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:14.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
}

- (NSDictionary *)textAttributesForTokenMainHighlight
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    UIColor *highlightColor = [UIColor colorWithRed:0.76 green:0.87 blue:1.00 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.minimumLineHeight = 21.0;
    paragraphStyle.maximumLineHeight = 21.0;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:14.0],
                       NSParagraphStyleAttributeName : paragraphStyle,
                       NSBackgroundColorAttributeName : highlightColor};
    
    return textAttributes;
}

- (NSDictionary *)textAttributesForTokenDescription
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.minimumLineHeight = 16.0;
    paragraphStyle.maximumLineHeight = 16.0;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:10.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
    
}

- (NSDictionary *)textAttributesForNodeMain
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    paragraphStyle.minimumLineHeight = 21.0;
    paragraphStyle.maximumLineHeight = 21.0;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:14.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
    
}

- (NSDictionary *)textAttributesForSearchHeader
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.25 green:0.25 blue:0.25 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentNatural;
    paragraphStyle.lineBreakMode = NSLineBreakByWordWrapping;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveBoldWithSize:14.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
}

- (NSDictionary *)textAttributesForReaderBarTitle
{
    NSDictionary *textAttributes = nil;
    
    UIColor *textColor = [UIColor colorWithRed:0.29 green:0.29 blue:0.29 alpha:1.0];
    
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.alignment = NSTextAlignmentCenter;
    paragraphStyle.lineBreakMode = NSLineBreakByTruncatingTail;
    
    textAttributes = @{NSForegroundColorAttributeName: textColor,
                       NSFontAttributeName : [self helveticaNeveWithSize:14.0],
                       NSParagraphStyleAttributeName : paragraphStyle};
    
    return textAttributes;
}

- (NSDictionary *)textAttributesForOutlineMain
{
    return [self textAttributesForNodeMain];
}

- (NSDictionary *)titleTextAttributesForNavBar
{
    NSDictionary *titleTextAttributes = nil;
    // Font
    // TextColor
    // TextShadowColor
    // TextShadowOffset
    titleTextAttributes = @{UITextAttributeFont : [[Appearance share] helveticaNeveBoldWithSize:18.0],
                            UITextAttributeTextColor : [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0],
                            UITextAttributeTextShadowColor : [UIColor whiteColor],
                            UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1.0)]};
    return titleTextAttributes;
    return titleTextAttributes;
}

- (NSDictionary *)titleTextAttributesForNavBarButton
{
    NSDictionary *titleTextAttributes = nil;
    // Font
    // TextColor
    // TextShadowColor
    // TextShadowOffset
    titleTextAttributes = @{UITextAttributeFont : [[Appearance share] helveticaNeveWithSize:14.0],
                            UITextAttributeTextColor : [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0],
                            UITextAttributeTextShadowColor : [UIColor whiteColor],
                            UITextAttributeTextShadowOffset : [NSValue valueWithCGSize:CGSizeMake(0, 1.0)]};
    return titleTextAttributes;
}

- (NSDictionary *)textAttributesForBookmarkName
{
    return  [self textAttributesForNodeMain];
}

#pragma mark - Buttons

- (UIButton *)readerBarButtonWithImageName:(NSString *)imageName
{
    UIButton *button = [[UIButton alloc] init];
    
    [button setImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-Highlighted", imageName]] forState:UIControlStateHighlighted];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-Selected", imageName]] forState:UIControlStateSelected];
    [button setImage:[UIImage imageNamed:[NSString stringWithFormat:@"%@-Disabled", imageName]] forState:UIControlStateDisabled];
    
    return button;
}

- (UIButton *)outlineButton
{
    UIButton *button = [[UIButton alloc] init];
    [button setImage:[UIImage imageNamed:@"OutlineButton"] forState:UIControlStateNormal];
    [button setImage:[UIImage imageNamed:@"OutlineButton-Selected"] forState:UIControlStateSelected];
    return button;
}

- (SSegmentedControl *)segmentedControl
{
    UIImage *search = [UIImage imageNamed:@"Segmented-Search"];
    UIImage *explore = [UIImage imageNamed:@"Segmented-Explore"];
    UIImage *bookmark = [UIImage imageNamed:@"Segmented-Bookmark"];
    NSArray *images = @[search, explore, bookmark];
    
    UIImage *searchSelected = [UIImage imageNamed:@"Segmented-Search-Selected"];
    UIImage *exploreSelected = [UIImage imageNamed:@"Segmented-Explore-Selected"];
    UIImage *bookmarkSelected = [UIImage imageNamed:@"Segmented-Bookmark-Selected"];
    NSArray *selectedImages = @[searchSelected, exploreSelected, bookmarkSelected];
    
    SSegmentedControl *segmentedControl = [[SSegmentedControl alloc] initWithImages:images selectedImages:selectedImages segmentWidth:60.0];
    return segmentedControl;
}

#pragma mark - Text Shadow
- (void)addTextShadowForLabel:(UILabel *)label
                    withColor:(UIColor *)color
                       offset:(CGSize)offset
{
    label.shadowColor = color;
    label.shadowOffset = offset;
}

#pragma mark - Custom Search Bar
- (void)customSearchBar:(UISearchBar *)searchbar shadow:(UIView *)searchbarShadow
{
    searchbar.showsCancelButton = NO;
    searchbar.autocorrectionType = UITextAutocorrectionTypeNo;
    [searchbar setBackgroundImage:[self imageForSearchBarBackground]];
    UIImage *shadowImage = [self imageForSearchBarShadow];
    searchbarShadow.layer.contents = (__bridge id)[shadowImage CGImage];
    [searchbar setSearchFieldBackgroundImage:[self imageForSearchBarField]
                                    forState:UIControlStateNormal];
    [searchbar setImage:[self imageForSearchBarIconSearch]
       forSearchBarIcon:UISearchBarIconSearch
                  state:UIControlStateNormal];
    [searchbar setImage:[self imageForSearchBarIconCancel]
       forSearchBarIcon:UISearchBarIconClear
                  state:UIControlStateNormal];
    
    for (UIView *subView in searchbar.subviews) {
        if ([subView isKindOfClass:[UITextField class]]) {
            UITextField *textField = (UITextField *)subView;
            textField.textColor = [UIColor colorWithRed:0.59 green:0.59 blue:0.59 alpha:1.0];
            textField.font = [self helveticaNeveWithSize:14.0];
            textField.textAlignment = NSTextAlignmentCenter;
        }
    }
}

- (void)customReaderBar:(UIToolbar *)readerBar
{
    [readerBar setBackgroundImage:[[Appearance share] imageForReaderBarBackground]
               forToolbarPosition:UIToolbarPositionAny
                       barMetrics:UIBarMetricsDefault];
    [readerBar setShadowImage:[[Appearance share] imageForReaderBarShadow]
           forToolbarPosition:UIToolbarPositionTop];
}

- (void)customWebView:(UIWebView *)webView
{
    for (UIView* shadowView in [webView.scrollView subviews])
    {
        if ([shadowView isKindOfClass:[UIImageView class]]) {
            [shadowView setHidden:YES];
        }
    }
}

- (void)customReaderPopoverBorderShadow:(UIImageView *)border
{
    border.layer.shadowColor = [[UIColor blackColor] CGColor];
    border.layer.shadowOpacity = 0.3;
    border.layer.shadowRadius = 8.0;
    border.layer.shadowOffset = CGSizeMake(0.0, 4.0);
}

- (void)customNavBar:(UINavigationBar *)navBar
{
    // BarBackground
    [navBar setBackgroundImage:[[Appearance share] imageForNavBarBackground] forBarMetrics:UIBarMetricsDefault];
    // BarShadow
    [navBar setShadowImage:[[Appearance share] imageForNavBarShadow]];
    // BarTitleAttributes
    [navBar setTitleTextAttributes:[[Appearance share] titleTextAttributesForNavBar]];
}

- (void)customToolBar:(UIToolbar *)toolBar
{
    // Background
    [toolBar setBackgroundImage:[[Appearance share] imageForNavBarBackground] forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    // BarShadow
    [toolBar setShadowImage:[[Appearance share] imageForNavBarShadow] forToolbarPosition:UIToolbarPositionTop];
}

- (void)customNavBarButton:(UIBarButtonItem *)barButtonItem
{
    // BackButton Background Normal/ Selected
    [barButtonItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonBackground-Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonBackground-Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
      [barButtonItem setBackButtonBackgroundImage:[[UIImage imageNamed:@"NavBarBackButtonBackground-Disabled"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    // Background Normal/ Selected
    [barButtonItem setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonBackground"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonBackground-Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonBackground-Selected"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateSelected barMetrics:UIBarMetricsDefault];
    [barButtonItem setBackgroundImage:[[UIImage imageNamed:@"NavBarButtonBackground-Disabled"] resizableImageWithCapInsets:UIEdgeInsetsMake(7.0, 15.0, 9.0, 16.0)] forState:UIControlStateDisabled barMetrics:UIBarMetricsDefault];
    // TitleTextAttributes
    [barButtonItem setTitleTextAttributes:[[Appearance share] titleTextAttributesForNavBarButton] forState:UIControlStateNormal];
    [barButtonItem setTitleTextAttributes:[[Appearance share] titleTextAttributesForNavBarButton] forState:UIControlStateHighlighted];
}

- (void)customToolBarButton:(UIBarButtonItem *)barButtonItem
{
    [self customNavBarButton:barButtonItem];
}

- (void)customToolKitBar:(UIToolbar *)toolKitBar
{
    UIImage *background = [[UIImage imageNamed:@"ToolKit-Background"] resizableImageWithCapInsets:UIEdgeInsetsMake(0.0, 3.0, 0.0, 3.0)];
    UIImage *shaodow = [[UIImage imageNamed:@"ToolKit-Shadow"] resizableImageWithCapInsets:UIEdgeInsetsZero];
    [toolKitBar setBackgroundImage:background forToolbarPosition:UIToolbarPositionAny barMetrics:UIBarMetricsDefault];
    [toolKitBar setShadowImage:shaodow forToolbarPosition:UIToolbarPositionBottom];
}

@end
