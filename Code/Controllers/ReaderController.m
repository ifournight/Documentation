//
//  ReaderController.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "ReaderController.h"
#import "Appearance.h"
#import "RevealSideController.h"
#import "OutlineController.h"
#import "Outline.h"
#import "Book.h"
#import "Token.h"
#import "Node.h"
#import "ReaderPopoverBackgroundView.h"
#import "Bookmark.h"
#import "BookmarkManager.h"
#import "BookmarkFolderDocument.h"
#import "BookmarkFolder.h"
#import "PromptView.h"

NSString *const ReaderControllerNeedOpenPageNotification = @"ReaderControllerNeedOpenPageNotification";
NSString *const ReaderControllerNeedOpenPageObjectKey = @"ReaderControllerNeedOpenPageObjectKey";

@interface ReaderController ()

@property (nonatomic, strong) UILabel *readerTitle;
@property (nonatomic, strong) UIButton *side;
@property (nonatomic, strong) UIButton *previous;
@property (nonatomic, strong) UIButton *next;
@property (nonatomic, strong) UIButton *font;
@property (nonatomic, strong) UIButton *bookmark;
@property (nonatomic, strong) UIButton *outline;

@property (nonatomic, strong) NSString *title;

@property (nonatomic,strong) Book *book;

@property (nonatomic, strong) UIPopoverController *outlinePopoverController;
@property (nonatomic, strong) OutlineController *outlineController;
@property (weak, nonatomic) IBOutlet PromptView *bookmarkPromptView;

@end

@implementation ReaderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom WebView
    [[Appearance share] customWebView:self.webview];
    // Custom Readerbar
    [[Appearance share] customReaderBar:self.readerbar];
    // Buttons
    self.side = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Side"];
    self.previous = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Previous"];
    self.next = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Next"];
    self.font = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Font"];
    self.bookmark = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Bookmark"];
    self.outline = [[Appearance share] readerBarButtonWithImageName:@"ReaderBar-Outline"];
    // Labels
    self.readerTitle = [[UILabel alloc] init];
    self.readerTitle.backgroundColor = [UIColor clearColor];
    [[Appearance share] addTextShadowForLabel:self.readerTitle
                                    withColor:[UIColor whiteColor]
                                       offset:CGSizeMake(0, 1)];
    // Add to subviews
    NSArray *subviews = @[self.side, self.previous, self.next, self.readerTitle, self.font, self.bookmark, self.outline];
    for (UIView *subview in subviews) {
        [self.readerbar addSubview:subview];
        [subview setTranslatesAutoresizingMaskIntoConstraints:NO];
    }
    [self setupBarConstraints];
    // Bookmark Prompt View
    self.bookmarkPromptView.promptLabel.text = @"Bookmarked";
    [self.bookmarkPromptView setNeedsLayout];
    // Open Page Notification
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(respondsToOpenPageNotificiation:)
                                                 name:ReaderControllerNeedOpenPageNotification
                                               object:nil];
    // Button Targets
    [self.side addTarget:self action:@selector(sideButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.outline addTarget:self action:@selector(outlineButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    [self.bookmark addTarget:self action:@selector(bookmarkButtonTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Targets

- (void)sideButtonTouchUpInside:(UIButton *)sideButton
{
    [[NSNotificationCenter defaultCenter] postNotificationName:RevealSideControllerNeedRevealSideNotification
                                                        object:self];
}

- (void)outlineButtonTouchUpInside:(UIButton *)outlineButton
{
    if (self.outlinePopoverController.popoverVisible) {
        [self.outlinePopoverController dismissPopoverAnimated:YES];
    }   else {
        CGRect outlineButtonFrame = outlineButton.frame;
        if (![self.outlineController.title isEqualToString:self.book.title]) {
            self.outlineController.book = self.book;
            [self.outlineController.tableView reloadData];
        }
        [self.outlinePopoverController presentPopoverFromRect:outlineButtonFrame
                                                       inView:self.readerbar
                                     permittedArrowDirections:UIPopoverArrowDirectionUp
                                                     animated:YES];
    }
}

- (void)bookmarkButtonTouchUpInside:(UIButton *)bookmarkButton
{
    dispatch_queue_t bookmarkCreationQueue = dispatch_queue_create("Bookmark Creation Queue", 0);
    dispatch_async(bookmarkCreationQueue, ^{
        Bookmark *newBookmark = [[Bookmark alloc] initWithName:self.title];
        BookmarkManager *bookmarkManager = [BookmarkManager share];
        BookmarkFolderDocument *defaultFolderDocument = bookmarkManager.bookmarkFolderDocuments[0];
        [bookmarkManager addBookmarks:@[newBookmark] toFolder:defaultFolderDocument WithCompletionHandler:^{
            // PromptView
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.bookmarkPromptView promptWithDuration:0.5];
            });
            // Update BookmarkFolderController and InsideBookmarkFolderController if necessary.
        }];
    });
}

#pragma mark - Popover Delegate, Management

- (UIPopoverController *)outlinePopoverController
{
    if (_outlinePopoverController == nil) {
        _outlinePopoverController = [[UIPopoverController alloc] initWithContentViewController:self.outlineController];
        _outlinePopoverController.popoverLayoutMargins = UIEdgeInsetsMake(44.0, 10.0, 44.0, 10.0);
        _outlinePopoverController.delegate = self;
        _outlinePopoverController.popoverBackgroundViewClass = [ReaderPopoverBackgroundView class];
    }
    return _outlinePopoverController;
}

- (OutlineController *)outlineController
{
    if (_outlineController == nil) {
        _outlineController = [[OutlineController alloc] initWithNibName:nil bundle:nil];
    }
    return  _outlineController;
}

#pragma mark - Auto Layout

- (void)setupBarConstraints
{
    NSDictionary *viewsDictionary = @{@"Side": self.side,
                                      @"Previous" : self.previous,
                                      @"Next" : self.next,
                                      @"Title" : self.readerTitle,
                                      @"Font" : self.font,
                                      @"Bookmark" : self.bookmark,
                                      @"Outline" : self.outline};
    [self.readerbar addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[Side(==44)]-20-[Previous(==44)]-20-[Next(==44)]-[Title]-[Font(==44)]-20-[Bookmark(==44)]-20-[Outline(==44)]-10-|"
                                                                           options:NSLayoutFormatAlignAllCenterY
                                                                           metrics:nil
                                                                             views:viewsDictionary]];
    [self.readerbar addConstraint:[NSLayoutConstraint constraintWithItem:self.readerTitle
                                                               attribute:NSLayoutAttributeCenterY
                                                               relatedBy:NSLayoutRelationEqual
                                                                  toItem:self.readerbar
                                                               attribute:NSLayoutAttributeCenterY
                                                              multiplier:1
                                                                constant:0]];
}

#pragma mark - Open Page

- (void)respondsToOpenPageNotificiation:(NSNotification *)notification
{
    NSDictionary *userInfo = notification.userInfo;
    id needToOpen = userInfo[ReaderControllerNeedOpenPageObjectKey];
    if (needToOpen == nil) return;
    if ([needToOpen isKindOfClass:[Token class]]) {
        [self openToken:needToOpen];
    }   else if ([needToOpen isKindOfClass:[Node class]]) {
        [self openNode:needToOpen];
    }   else if ([needToOpen isKindOfClass:[Outline class]]) {
        [self openOutline:needToOpen];
    }
}

- (void)openToken:(Token *)token
{
    NSLog(@"Reader Controller will load token \"%@\" with URL: %@.", token.name, token.URL);
    [self.webview loadRequest:[NSURLRequest requestWithURL:token.URL]];
}

- (void)openNode:(Node *)node
{
    NSLog(@"Reader Controller will load node \"%@\" with URL: %@", node.name, node.URL);
    [self.webview loadRequest:[NSURLRequest requestWithURL:node.URL]];
}

- (void)openOutline:(Outline *)outline
{
    NSLog(@"Reader Controller will load outline \"%@\" with URL: %@", outline.title, outline.URL);
    [self.webview loadRequest:[NSURLRequest requestWithURL:outline.URL]];
}

#pragma mark - Web view delegate AND URL Manipulation

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType
{
    NSURL *requestedURL = request.URL;
    NSLog(@"Reader Controller request load URL: %@", requestedURL);
    if ([requestedURL.scheme isEqualToString:@"file"]) {
        BOOL isXCURL = [requestedURL.path rangeOfString:@"__XC__"].location != NSNotFound ? YES : NO;
        if (isXCURL) {
            return YES;
        }
        // File URL.
        NSString *fragment = requestedURL.fragment;
        NSURL *HTMLURL = nil;
        NSLog(@"URL fragment: %@", fragment);
        if (fragment.length > 0) {
            HTMLURL = [NSURL fileURLWithPath:requestedURL.path];
        }   else {
            HTMLURL = requestedURL;
        }
        NSString *file = HTMLURL.lastPathComponent;
        NSLog(@"File: %@", file);
        
        NSString *XCFile = [file stringByReplacingOccurrencesOfString:@".html"
                                                           withString:@"__XC__.html"];
        NSLog(@"XC File: %@", XCFile);
        NSURL *XCURL = [[HTMLURL URLByDeletingLastPathComponent] URLByAppendingPathComponent:XCFile];
        NSLog(@"XCURL :%@", XCURL);
        BOOL XCFileExist = [[NSFileManager defaultManager] fileExistsAtPath:XCURL.path];
        if (XCFileExist) {
            if (fragment.length > 0) {
                XCURL = [NSURL URLWithString:[XCURL.absoluteString stringByAppendingFormat:@"#%@",fragment]];
            }
            NSLog(@"XCURL: %@", XCURL);
            [self.webview loadRequest:[NSURLRequest requestWithURL:XCURL]];
            return NO;
        }   else {
            NSString *HTML = [NSString stringWithContentsOfURL:HTMLURL
                                                      encoding:NSUTF8StringEncoding
                                                         error:nil];
            // Delete Apple iPad UI Javascript
            NSRange JSRange;
            NSScanner *JSScanner = [NSScanner scannerWithString:HTML];
            if ([JSScanner scanUpToString:@"<script>String.prototype.cleanUpURL" intoString:NULL]) {
                JSRange.location = JSScanner.scanLocation;
                [JSScanner scanString:@"<script>String.prototype.cleanUpURL" intoString:NULL];
                [JSScanner scanUpToString:@"</script>" intoString:NULL];
                [JSScanner scanString:@"</script>" intoString:NULL];
                JSRange.length = JSScanner.scanLocation - JSRange.location;
            }
            if (JSRange.length > 0) {
                HTML = [HTML stringByReplacingCharactersInRange:JSRange withString:@""];
            }
            // Add Exteral CSS
            NSString *externalCSS = [self externalCSS];
            HTML = [HTML stringByReplacingOccurrencesOfString:@"</head>" withString:externalCSS];
            [HTML writeToURL:XCURL atomically:YES encoding:NSUTF8StringEncoding error:nil];
            if (fragment.length > 0) {
                XCURL = [NSURL URLWithString:[XCURL.absoluteString stringByAppendingFormat:@"#%@",fragment]];
            }
            NSLog(@"XCURL: %@", XCURL);
            [self.webview loadRequest:[NSURLRequest requestWithURL:XCURL]];
            return NO;
        }
    }   else if ([requestedURL.scheme isEqualToString:@"http"] || [requestedURL.scheme isEqualToString:@"https"]) {
        return NO;
    }
    return YES;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if ([self reloadTitle]) {
        [self reloadBook];
    }
}

#pragma mark - Reload Page Information

- (BOOL)reloadTitle
{
    NSString *pageTitle = [self pageTitle];
    BOOL needReloadTitle = [pageTitle isEqualToString:self.title] ? NO : YES;
    if (needReloadTitle) {
        self.title = pageTitle;
        if (self.title.length > 0) {
            self.readerTitle.attributedText = [[NSAttributedString alloc] initWithString:self.title
                                                                              attributes:[[Appearance share] textAttributesForReaderBarTitle]];
        }   else {
            self.readerTitle.attributedText = nil;
        }
        [self.readerbar layoutIfNeeded];
        return YES;
    }   else {
        return NO;
    }
}

- (void)reloadBook
{
    NSURL *bookURL = [self bookURL];
    NSURL *bookRootURL = [self bookRootURL];
    dispatch_queue_t reloadBookQueue = dispatch_queue_create("reloadBookQueue", NULL);
    dispatch_async(reloadBookQueue, ^{
        NSData *bookData = [NSData dataWithContentsOfURL:bookURL];
        NSDictionary *bookDictionary = [NSJSONSerialization JSONObjectWithData:bookData options:0 error:nil];
        Book *book = [[Book alloc] initWithBookDictionary:bookDictionary bookURL:bookURL rootURL:bookRootURL];
        dispatch_async(dispatch_get_main_queue(), ^{
            self.book = book;
            if (self.outlinePopoverController.isPopoverVisible) {
                self.outlineController.book = self.book;
                [self.outlineController.tableView reloadData];
            }
        });
    });
}

#pragma mark - Fetch Information From Webview

- (NSURL *)pageURL
{
    return [NSURL URLWithString:[self.webview stringByEvaluatingJavaScriptFromString:@"window.location.href"]];
}

- (NSURL *)bookURL
{
    NSURL *pageURL = [self pageURL];
    NSString *bookRelativePath = [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('book-json').getAttribute('content')"];
    return [NSURL URLWithString:bookRelativePath relativeToURL:pageURL];
}

- (NSURL *)bookRootURL
{
    NSURL *pageURL = [self pageURL];
    NSString *rootRelativePath = [self.webview stringByEvaluatingJavaScriptFromString:@"document.getElementById('book-root').getAttribute('content')"];
    NSURL *bookRootURL = [NSURL URLWithString:rootRelativePath relativeToURL:pageURL];
    NSLog(@"Book Root URL: %@", bookRootURL);
    return bookRootURL;
}

- (NSString *)pageTitle
{
    NSString *queryPageString = @"document.querySelector('meta[name = book-title]').getAttribute('content')";
    NSString *pageTitle = [self.webview stringByEvaluatingJavaScriptFromString:queryPageString];
    NSLog(@"Page Title: %@", pageTitle);
    return pageTitle;
}

#pragma mark - HTML File

- (NSString *)externalCSSPath
{
    NSString *externalCSSPath = [[NSBundle mainBundle] pathForResource:@"Documentation" ofType:@"css"];
    return externalCSSPath;
}

- (NSString *)externalCSS
{
    NSString *externalCSSPath = [self externalCSSPath];
    NSString *externalCSS = [NSString stringWithFormat:@"<link rel=\"stylesheet\" type=\"text/css\" href=\"%@\" charset=\"utf-8\"></head>", externalCSSPath];
    return externalCSS;
}

@end
