//
//  MoveToFolderController.m
//  Documentation
//
//  Created by Song Hui on 13-8-2.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "MoveToFolderController.h"
#import "BookmarkManager.h"
#import "BookmarkFolderDocument.h"
#import "BookmarkFolder.h"
#import "Bookmark.h"
#import "Appearance.h"

@interface MoveToFolderController ()

@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (weak, nonatomic) IBOutlet UIBarButtonItem *cancelButton;

@end

@implementation MoveToFolderController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

#define MoveToFolderCellIdentifier @"MoveToFolderCellIdentifier"

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Custom Nav Bar
    [[Appearance share] customNavBar:self.navBar];
    [[Appearance share] customNavBarButton:self.cancelButton];
    // Table View
    self.tableView.backgroundColor = [UIColor colorWithRed:0.97 green:0.97 blue:0.97 alpha:1.0];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.rowHeight = 44;
    // Table View Cell Registeration.
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:MoveToFolderCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonPressed:(id)sender {
    [self.delegate moveToFolderControllerDemandDismiss];
}

#pragma mark - Table View DataSource / Delegate.

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    }   else {
        return [[[BookmarkManager share] bookmarkFolderDocuments] count];
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:MoveToFolderCellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];

    cell.textLabel.font = [[Appearance share] helveticaNeveWithSize:14.0];
    cell.textLabel.textColor = [UIColor colorWithRed:0.39 green:0.39 blue:0.39 alpha:1.0];
    
    UIImageView *MoveToFolderIndicator = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"MoveToFolderIndicator"]];
    
    if (indexPath.section == 0) {
        cell.textLabel.text = self.currentFolderDocument.bookmarkFolder.name;
        cell.accessoryView = MoveToFolderIndicator;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }   else {
        BookmarkManager *bookmarkManager = [BookmarkManager share];
        BookmarkFolderDocument *folderDocument = bookmarkManager.bookmarkFolderDocuments[bookmarkManager.bookmarkFolderDocuments.count - indexPath.row -1];
        cell.textLabel.text = folderDocument.bookmarkFolder.name;
        
        if ([folderDocument.bookmarkFolder.name isEqualToString:self.currentFolderDocument.bookmarkFolder.name]) {
            cell.accessoryView = MoveToFolderIndicator;
        }   else {
            cell.accessoryView = nil;
        }
        cell.selectionStyle = UITableViewCellSelectionStyleBlue;
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return;
    }
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    BookmarkManager *bookmarkManager = [BookmarkManager share];
    BookmarkFolderDocument *folderDocument = bookmarkManager.bookmarkFolderDocuments[bookmarkManager.bookmarkFolderDocuments.count - indexPath.row - 1];
    if ([folderDocument.bookmarkFolder.name isEqualToString:self.currentFolderDocument.bookmarkFolder.name]) {
        return;
    }
    [self.delegate moveToFolderController:self
                        needMoveBookmarks:self.bookmarksNeedToMove
                               fromFolder:self.currentFolderDocument
                                 toFolder:folderDocument];
}

@end
