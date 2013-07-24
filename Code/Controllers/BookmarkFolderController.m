//
//  BookmarkFolderController.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "BookmarkFolderController.h"
#import "BookmarkFolderDefaultCell.h"
#import "BookmarkManager.h"
#import "BookmarkFolder.h"
#import "BookmarkFolderDocument.h"
#import "Appearance.h"
#import "ToolKitController.h"

NSString *const BookmarkControllerNormalCellIdentifier = @"BookmarkControllerNormalCellIdentifier";
NSString *const BookmarkControllerDefaultCellIdentifier = @"BookmarkControllerDefaultCellIdentifier";

@interface BookmarkFolderController ()

@property (nonatomic, strong) UIBarButtonItem *edit;
@property (nonatomic, strong) UIBarButtonItem *done;
@property (nonatomic, strong) UIBarButtonItem *newFolder;

@end

@implementation BookmarkFolderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // BookmarkManager Notification
        [[NSNotificationCenter defaultCenter] addObserver:self
                                                 selector:@selector(bookmarkManagerDidReloadDocuments)
                                                     name:BookmarkManagerDidReloadBookmarkFolderDocumentsNotification
                                                   object:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Nav Bar Customazition
    [[Appearance share] customNavBar:self.navigationController.navigationBar];
    // Title
    self.title = @"Bookmark Folders";
    // Edit Button
    self.navigationItem.rightBarButtonItem = self.edit;
    // Cell Registeration
    [self.tableView registerNib:[UINib nibWithNibName:@"BookmarkFolderNormalCell" bundle:nil] forCellReuseIdentifier:BookmarkControllerNormalCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"BookmarkFolderDefaultCell" bundle:nil] forCellReuseIdentifier:BookmarkControllerDefaultCellIdentifier];
    // TableView delegate/ datasource
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    // TableView Offset to achieve design effect
    self.tableView.contentOffset = CGPointMake(0, 20.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Button Action.

- (UIBarButtonItem *)edit
{
    if (!_edit) {
        _edit = [[UIBarButtonItem alloc] initWithTitle:@"Edit"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(editButtonPressed:)];
        [[Appearance share] customNavBarButton:_edit];
    }
    return _edit;
}

- (UIBarButtonItem *)done
{
    if (!_done) {
        _done = [[UIBarButtonItem alloc] initWithTitle:@"Done"
                                                 style:UIBarButtonItemStylePlain
                                                target:self
                                                action:@selector(doneButtonPressed:)];
        [[Appearance share] customNavBarButton:_done];
    }
    return _done;
}

- (UIBarButtonItem *)newFolder
{
    if (!_newFolder) {
        _newFolder = [[UIBarButtonItem alloc] initWithTitle:@"New Folder"
                                                      style:UIBarButtonItemStylePlain
                                                     target:self
                                                     action:@selector(newFolderButtonPressed:)];
        [[Appearance share] customNavBarButton:_newFolder];
    }
    return _newFolder;
}

- (void)editButtonPressed:(id)sender
{
    [self setEditing:YES animated:YES];
}

- (void)doneButtonPressed:(id)sender
{
    [self setEditing:NO animated:YES];
}

- (void)newFolderButtonPressed:(id)sender
{
    NewBookmarkFolderController *newBookmark = [[NewBookmarkFolderController alloc] initWithNibName:nil bundle:nil];
    newBookmark.modalPresentationStyle = UIModalPresentationCurrentContext;
    //TODO:ToolKitController instead of navigationController should present it.
    [self.navigationController presentViewController:newBookmark animated:YES completion:^{
        newBookmark.delegate = self;
    }];
//    [self.toolKitController presentViewController:newBookmark animated:YES completion:^{
//        newBookmark.delegate = self;
//    }];
}

#pragma mark - Table View Editing

- (void)setEditing:(BOOL)editing animated:(BOOL)animated
{
    [super setEditing:editing animated:animated];
    if (editing) {
        self.navigationItem.leftBarButtonItem = self.newFolder;
        self.navigationItem.rightBarButtonItem = self.done;
    }   else {
        self.navigationItem.leftBarButtonItem = nil;
        self.navigationItem.rightBarButtonItem = self.edit;
    }
    [self.tableView setEditing:editing animated:animated];
}

#pragma mark - Table View Delegate/ dataSource

- (BOOL)tableView:(UITableView *)tableView shouldIndentWhileEditingRowAtIndexPath:(NSIndexPath *)indexPath
{
    return NO;
}

- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Custom Editing, return UITableViewCellEditingStyleNone.
    return UITableViewCellEditingStyleNone;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [[[BookmarkManager share] bookmarkFolderDocuments] count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44.0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSInteger documentsCount = [[[BookmarkManager share] bookmarkFolderDocuments] count];
    // Deal with TableView indexPath order and BookmarkManager's Docucments order.
    BookmarkFolderDocument *folderDocument = [[BookmarkManager share] bookmarkFolderDocuments][documentsCount - indexPath.row - 1];
    if (folderDocument.bookmarkFolder.type == BookmarkFolderTypeNormal) {
        BookmarkFolderNormalCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BookmarkControllerNormalCellIdentifier forIndexPath:indexPath];
        cell.bookmarkFolder = folderDocument.bookmarkFolder;
        return cell;
    }   else {
        BookmarkFolderDefaultCell *cell = [self.tableView dequeueReusableCellWithIdentifier:BookmarkControllerDefaultCellIdentifier forIndexPath:indexPath];
        cell.bookmarkFolder = folderDocument.bookmarkFolder;
        return cell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - BookmarkManager Notification
- (void)bookmarkManagerDidReloadDocuments
{
    NSLog(@"BookmarkFolderController receive BookmarkManagerDidReloadDocumentsNotification");
    [self.tableView reloadData];
}

#pragma mark - New Bookmark Delegate
- (void)newBookmarkFolderDidCancel
{
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.toolKitController dismissViewControllerAnimated:YES completion:nil];
}

- (void)newBookmarkFolderDidDoneWithName:(NSString *)name
{
    [[BookmarkManager share] createFolderWithName:name bookmarks:nil WithCompletionHandler:^{
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:@[[NSIndexPath indexPathForRow:0 inSection:0]] withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }];
    [self.navigationController dismissViewControllerAnimated:YES completion:nil];
//    [self.toolKitController dismissViewControllerAnimated:YES completion:nil];
}

@end