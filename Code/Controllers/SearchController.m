//
//  SearchController.m
//  Documentation
//
//  Created by Song Hui on 13-7-20.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SearchController.h"
#import "Appearance.h"
#import "SearchHeader.h"
#import "TokenCell.h"
#import "NodeCell.h"
#import "SearchToken.h"
#import "SearchNode.h"
#import "ReaderController.h"

NSString *const SearchControllerSearchHeaderIdentifier = @"SearchControllerSearchHeaderIdentifier";
NSString *const SearchControllerTokenCellIdentifier = @"SearchControllerTokenCellIdentifier";
NSString *const SearchControllerNodeCellIdentifier = @"SearchControllerNodeCellIdentifier";

@interface SearchController ()

@property (strong, nonatomic) NSArray *searchResults;

@end

@implementation SearchController

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
    // Searchbar Customazition
    [[Appearance share] customSearchBar:self.searchbar
                                 shadow:self.searchbarShadow];
    // Cell and Header Registeration.
    [self.tableView registerClass:[SearchHeader class] forHeaderFooterViewReuseIdentifier:SearchControllerSearchHeaderIdentifier];
    [self.tableView registerClass:[TokenCell class] forCellReuseIdentifier:SearchControllerTokenCellIdentifier];
    [self.tableView registerClass:[NodeCell class] forCellReuseIdentifier:SearchControllerNodeCellIdentifier];
    // Delegation
    self.searchbar.delegate = self;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Search

- (void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    [[SearchManager share] prepareSearch];
}

- (void)searchBarTextDidEndEditing:(UISearchBar *)searchBar
{
    [self.searchbar resignFirstResponder];
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    [[SearchManager share] searchWithSearchString:self.searchbar.text
                                         delegate:self];
}

- (void)searchManager:(SearchManager *)searchManager didFinishSearchWithSearchResult:(NSArray *)searchResult
{
    self.searchResults = searchResult;
    [self.tableView reloadData];
}

#pragma mark - Table View Delegate/ Data Source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return self.searchResults.count;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section
{
    NSArray *resultContents = (NSArray *)self.searchResults[section][SearchResultContentsKey];
    return resultContents.count;
}

- (CGFloat)tableView:(UITableView *)tableView
heightForHeaderInSection:(NSInteger)section
{
    return 36.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSArray *cellHeights = (NSArray *)self.searchResults[indexPath.section][SearchResultCellHeightsKey];
    CGFloat cellHeight = [cellHeights[indexPath.row] floatValue];
    return cellHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    SearchHeader *searchHeader = [self.tableView dequeueReusableHeaderFooterViewWithIdentifier:SearchControllerSearchHeaderIdentifier];
    NSString *header = self.searchResults[section][SearchResultSectionTypeKey];
    searchHeader.header = header;
    return searchHeader;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSString *header = self.searchResults[indexPath.section][SearchResultSectionTypeKey];
    NSArray *resultContents = (NSArray *)self.searchResults[indexPath.section][SearchResultContentsKey];
    
    if ([header isEqualToString:@"Guide"]) {
        NodeCell *nodeCell = [self.tableView dequeueReusableCellWithIdentifier:SearchControllerNodeCellIdentifier
                                                                  forIndexPath:indexPath];
        SearchNode *node = resultContents[indexPath.row];
        nodeCell.node = node;
        return nodeCell;
    }   else {
        TokenCell *tokenCell = [self.tableView dequeueReusableCellWithIdentifier:SearchControllerTokenCellIdentifier
                                                                    forIndexPath:indexPath];
        SearchToken *token = resultContents[indexPath.row];
        tokenCell.token = token;
        return tokenCell;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSArray *resultContents = (NSArray *)self.searchResults[indexPath.section][SearchResultContentsKey];
    id content = resultContents[indexPath.row];
    [[NSNotificationCenter defaultCenter] postNotificationName:ReaderControllerNeedOpenPageNotification
                                                        object:self
                                                      userInfo:@{ReaderControllerNeedOpenPageObjectKey: content}];
}

@end
