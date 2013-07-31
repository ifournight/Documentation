//
//  BookmarksController.m
//  Documentation
//
//  Created by Song Hui on 13-7-29.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarksController.h"
#import "Appearance.h"
#import "Bookmark.h"
#import "BookmarkFolder.h"
#import "BookmarkFolderDocument.h"
#import "ToolKitController.h"
#import "ReaderController.h"

NSString *const BookmarkCellIdentifier = @"BookmarkCellIdentifier";

@interface BookmarksController ()

// UIToolbar that disappear when in editing mode.
@property (weak, nonatomic) IBOutlet UIToolbar *editBar;

// DeleteButtoneItem on editBar.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *deleteButton;

// MoveToFolderButtonItem on editBar.
@property (weak, nonatomic) IBOutlet UIBarButtonItem *moveToFolderButton;

// EditButtonItem on NavigationBar.
@property (strong, nonatomic) UIBarButtonItem *edit;

// CancelButtonItem on NavigationBar.
@property (strong, nonatomic) UIBarButtonItem *cancel;

// Sample Cell for dynamic height.
@property (strong,  nonatomic) BookmarkCell *sampleCell;

// Implement custom multiple cell selection.
@property (strong, nonatomic) NSMutableSet *selectedIndexPaths;

// Show Edit Bar from Bottom.
- (void)showEditBarWithCompletionHandler:(void(^)(void))completionHandler;

// Hide Edit Bar.
- (void)hideEditBarWithCompletionHandler:(void(^)(void))completionHandler;

// Below methods are for self.selectedIndexPaths property's KVO compliance.
- (NSInteger)countOfSelectedIndexPaths;
- (void)addSelectedIndexPathsObject:(NSIndexPath *)indexPath;
- (void)removeSelectedIndexPathsObject:(NSIndexPath *)indexPath;

@end

@implementation BookmarksController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _selectedIndexPaths = [[NSMutableSet alloc] init];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Navigationbar Customazition.
    self.title = self.bookmarkFolderDocument.bookmarkFolder.name;
    [[Appearance share] customNavBar:self.navigationController.navigationBar];
    self.navigationItem.rightBarButtonItem = self.edit;
    // ToolBar Customazition.
    [[Appearance share] customToolBar:self.editBar];
    [[Appearance share] customToolBarButton:self.deleteButton];
    [[Appearance share] customToolBarButton:self.moveToFolderButton];
    // TableView and Self View Properties
    self.view.backgroundColor = [UIColor clearColor];
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    self.tableView.separatorColor = UITableViewCellSeparatorStyleNone;
    self.tableView.allowsSelectionDuringEditing = YES;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // Cell Registeration.
    [self.tableView registerNib:[UINib nibWithNibName:@"BookmarkCell" bundle:nil] forCellReuseIdentifier:BookmarkCellIdentifier];
    // Selected indexPaths KVO
//    [self.tableView addObserver:self forKeyPath:@"indexPathsForSelectedRows" options:NSKeyValueObservingOptionNew context:NULL];
    [self addObserver:self forKeyPath:@"selectedIndexPaths" options:NSKeyValueObservingOptionNew context:NULL];
    // Sample Cell
    _sampleCell = [self.tableView dequeueReusableCellWithIdentifier:BookmarkCellIdentifier];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [self setEditing:NO animated:YES];
}

- (void)setBookmarkFolderDocument:(BookmarkFolderDocument *)bookmarkFolderDocument
{
    if (!_bookmarkFolderDocument) {
        [_bookmarkFolderDocument removeObserver:self forKeyPath:@"bookmarkFolder.bookmarks"];
    }
    _bookmarkFolderDocument = bookmarkFolderDocument;
    if (_bookmarkFolderDocument) {
        [_bookmarkFolderDocument addObserver:self forKeyPath:@"bookmarkFolder.bookmarks" options:NSKeyValueObservingOptionNew context:NULL];
    }
}

- (void)dealloc
{
    [_bookmarkFolderDocument removeObserver:self forKeyPath:@"bookmarkFolder.bookmarks"];
    [self removeObserver:self forKeyPath:@"selectedIndexPaths"];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - TableView delegate, dataSource

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.bookmarkFolderDocument.bookmarkFolder.bookmarks.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Bookmark *bookmark = self.bookmarkFolderDocument.bookmarkFolder.bookmarks[indexPath.row];
    self.sampleCell.bookmark = bookmark;
    return self.sampleCell.intrinsicContentSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BookmarkCellIdentifier forIndexPath:indexPath];
    Bookmark *bookmark = self.bookmarkFolderDocument.bookmarkFolder.bookmarks[indexPath.row];
    cell.bookmark = bookmark;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    BookmarkCell *cell = (BookmarkCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    // Editing Mode
    if (cell.editing) {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        [self multipleSelectionWithIndexPath:indexPath];
    // Not Editing
    }   else {
        [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
        Bookmark *bookmark = self.bookmarkFolderDocument.bookmarkFolder.bookmarks[indexPath.row];
        [[NSNotificationCenter defaultCenter] postNotificationName:ReaderControllerNeedOpenPageNotification object:self userInfo:@{ReaderControllerNeedOpenPageObjectKey: bookmark}];
    }
}

#pragma mark - Bookmark Cell Delegate and custom multiple selection implementation.
- (void)bookmarkCell:(BookmarkCell *)bookmarkCell selectControlDidPressed:(UIButton *)selectControl
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:bookmarkCell];
    [self multipleSelectionWithIndexPath:indexPath];
}

- (void)multipleSelectionWithIndexPath:(NSIndexPath *)indexPath
{
    BookmarkCell *cell = (BookmarkCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    if ([self.selectedIndexPaths containsObject:indexPath]) {
        [self removeSelectedIndexPathsObject:indexPath];
        cell.selectControl.selected = NO;
    }   else {
        [self addSelectedIndexPathsObject:indexPath];
        cell.selectControl.selected = YES;
    }
}

- (NSInteger)countOfSelectedIndexPaths
{
    return [self.selectedIndexPaths count];
}

- (void)removeSelectedIndexPathsObject:(NSIndexPath *)indexPath
{
    [self.selectedIndexPaths removeObject:indexPath];
}

- (void)addSelectedIndexPathsObject:(NSIndexPath *)indexPath
{
    [self.selectedIndexPaths addObject:indexPath];
}

#pragma mark - Navigation Bar, Editing

- (UIBarButtonItem *)edit
{
    if (!_edit) {
        _edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit" style:UIBarButtonItemStyleBordered target:self action:@selector(editButtonPressed:)];
        [[Appearance share] customNavBarButton:_edit];
    }
    return _edit;
}

- (UIBarButtonItem *)cancel
{
    if (!_cancel) {
        _cancel = [[UIBarButtonItem alloc] initWithTitle:@"Cancel" style:UIBarButtonItemStyleBordered target:self action:@selector(cancelButtonPressed:)];
        [[Appearance share] customNavBarButton:_cancel];
    }
    return _cancel;
}

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    [self.tableView setEditing:editing animated:YES];
    // Reset selectedIndexPaths.
    self.selectedIndexPaths = [[NSMutableSet alloc] init];
    if (editing) {
        self.navigationItem.rightBarButtonItem = self.cancel;
        [self.toolKitController hideToolbarWithCompletionHandler:^{
            [self showEditBarWithCompletionHandler:nil];
        }];
    }   else {
        self.navigationItem.rightBarButtonItem = self.edit;
        [self hideEditBarWithCompletionHandler:^{
            [self.toolKitController showToolbarWithCompletionHandler:nil];
        }];
    }
}

- (void)editButtonPressed:(UIBarButtonItem *)edit
{
    [self setEditing:YES animated:YES];
}

- (void)cancelButtonPressed:(UIBarButtonItem *)cancel
{
    [self setEditing:NO animated:YES];
}

- (void)showEditBarWithCompletionHandler:(void(^)(void))completionHandler
{
    CGSize fullSize = self.view.frame.size;
    CGRect tableViewFrame = CGRectMake(0, 0, fullSize.width, fullSize.height - 44);
    CGRect editBarFrame = CGRectMake(0, fullSize.height - 44, fullSize.width, 44);
    self.editBar.hidden = NO;
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tableView.frame = tableViewFrame;
        self.editBar.frame = editBarFrame;
    } completion:^(BOOL finished) {
        if (completionHandler) {
            completionHandler();
        }
    }];
}

- (void)hideEditBarWithCompletionHandler:(void(^)(void))completionHandler
{
    CGSize fullSize = self.view.frame.size;
    CGRect tableViewFrame = CGRectMake(0, 0, fullSize.width, fullSize.height);
    CGRect editBarFrame = CGRectMake(0, fullSize.height, fullSize.width, 44);
    [UIView animateWithDuration:0.25 delay:0.0 options:UIViewAnimationOptionCurveLinear animations:^{
        self.tableView.frame = tableViewFrame;
        self.editBar.frame = editBarFrame;
    } completion:^(BOOL finished) {
        self.editBar.hidden = YES;
        if (completionHandler) {
            completionHandler();
        }
    }];
}

#pragma mark - Edit Bar

- (IBAction)deleteButtonPressed:(id)sender {
    
}


- (IBAction)moveToFolderButtonPressed:(id)sender {
}

#pragma mark - KVO
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context
{
    // When bookmarks change.
    if ([keyPath isEqualToString:@"bookmarkFolder.bookmarks"]) {
        if (object == self.bookmarkFolderDocument) {
            // TODO:If self.view, use tableViewUpdateAnimation.
            [self.tableView reloadData];
        }
    // When selected rows change.
    }   else if ([keyPath isEqualToString:@"selectedIndexPaths"]) {
        if (object == self) {
//            NSInteger selectedRowsCount = self.tableView.indexPathsForSelectedRows.count;
//            self.deleteButton.title = [NSString stringWithFormat:@"Delete(%d)", selectedRowsCount];
//            self.moveToFolderButton.title = [NSString stringWithFormat:@"Move To Folder(%d)", selectedRowsCount];
            NSInteger selectedIndexPathsCount = [self countOfSelectedIndexPaths];
            if (selectedIndexPathsCount == 0) {
                self.deleteButton.title = @"Delete";
                self.moveToFolderButton.title = @"Move To Folder";
            }   else {
                self.deleteButton.title = [NSString stringWithFormat:@"Delete(%d)", selectedIndexPathsCount];
                self.moveToFolderButton.title = [NSString stringWithFormat:@"Move To Folder(%d)", selectedIndexPathsCount];
            }
        }
    }
}

@end
