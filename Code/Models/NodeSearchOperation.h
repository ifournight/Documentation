//
//  SNodeSearchOperation.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

// An operation that search all search manager's nodes based on its search string.
@interface NodeSearchOperation : NSOperation

// Search string.
@property (nonatomic, copy) NSString *searchString;

// Search results.
@property (nonatomic, strong) NSArray *searchResults;

// Already fetched information properties nodes, with maximum count. 
// Will be used as SearchController's table view's data source.
@property (nonatomic, strong) NSArray *nodes;

// cell heights corresponding to the self.nodes
// Will be used as SearchController's table view's data source.
@property (nonatomic, strong) NSArray *cellHeights;

// Designated Initializer.
- (id)initWithSearchString:(NSString *)searchString;

@end
