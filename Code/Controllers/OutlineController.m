//
//  OutlineController.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "OutlineController.h"
#import "ReaderController.h"
#import "Outline.h"
#import "Book.h"

#define OutlineCellIdentifier @"OutlineCellIdentifier"

@interface OutlineController ()

@property (nonatomic, strong) OutlineCell *sampleCell;
@end

@implementation OutlineController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
        _sampleCell = [[OutlineCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.tableView registerClass:[OutlineCell class] forCellReuseIdentifier:OutlineCellIdentifier];
    
    self.view.layer.cornerRadius = 6.0;
    self.view.layer.masksToBounds = YES;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self reloadContentsSizeInPopoverView];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.contentSizeForViewInPopover = CGSizeMake(320.0, 1100.0);
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table View Delegate/ Data Source

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.book.expandedOutlines.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    Outline *outline = self.book.expandedOutlines[indexPath.row];
    self.sampleCell.outline = outline;
    return self.sampleCell.intrinsicContentSize.height;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    OutlineCell *cell = [self.tableView dequeueReusableCellWithIdentifier:OutlineCellIdentifier
                                                             forIndexPath:indexPath];
    Outline *outline = self.book.expandedOutlines[indexPath.row];
    cell.outline = outline;
    cell.delegate = self;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    Outline *outline = self.book.expandedOutlines[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReaderControllerNeedOpenPageNotification
                                                        object:self
                                                      userInfo:@{ReaderControllerNeedOpenPageObjectKey : outline}];
}

#pragma mark - Outline Cell Delegate

- (void)outlineCellDidTapButton:(OutlineCell *)cell
{
    NSIndexPath *indexPath = [self.tableView indexPathForCell:cell];
    NSInteger section = indexPath.section;
    Outline *outline = self.book.expandedOutlines[indexPath.row];
    // Collapse
    if (outline.expanded) {
        outline.expanded = outline.expanded ? NO : YES;
        NSInteger previousCounts = self.book.expandedOutlines.count;
        [self.book updateExpandedOutlines];
        NSInteger currentCounts = self.book.expandedOutlines.count;
        NSInteger updatedCounts = abs(currentCounts - previousCounts);
        
        NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] init];
        
        for (int row = indexPath.row + 1; row <= indexPath.row + updatedCounts; row ++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row
                                                        inSection:section];
            [updatedIndexPaths addObject:indexPath];
        }
        
        [self.tableView beginUpdates];
        [self.tableView deleteRowsAtIndexPaths:updatedIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }   else {
        outline.expanded = outline.expanded ? NO : YES;
        NSInteger previousCounts = self.book.expandedOutlines.count;
        [self.book updateExpandedOutlines];
        NSInteger currentCounts = self.book.expandedOutlines.count;
        NSInteger updatedCounts = abs(currentCounts - previousCounts);
        
        NSMutableArray *updatedIndexPaths = [[NSMutableArray alloc] init];
        
        for (int row = indexPath.row + 1; row <= indexPath.row + updatedCounts; row++) {
            NSIndexPath *indexPath = [NSIndexPath indexPathForRow:row inSection:section];
            [updatedIndexPaths addObject:indexPath];
        }
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:updatedIndexPaths
                              withRowAnimation:UITableViewRowAnimationAutomatic];
        [self.tableView endUpdates];
    }
    [self reloadContentsSizeInPopoverView];
}

- (void)reloadContentsSizeInPopoverView
{
    CGFloat width = 320.0;
    CGRect lastSectionRect = [self.tableView rectForSection:[self.tableView numberOfSections] - 1];
    CGFloat height = CGRectGetMaxY(lastSectionRect);
    self.contentSizeForViewInPopover = CGSizeMake(width, height);
    [self.view setNeedsLayout];
}

@end