//
//  STokenSearchOperation.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSUInteger, STokenSearchOperationType) {
    STokenSearchOperationTypeNew,
    STokenSearchOperationTypeContinue,
    STokenSearchOperationTypeOverlay
};

// An Operation with a specific search string searches all search manager's tokens.
@interface TokenSearchOperation : NSOperation

// Search string.
@property (nonatomic, copy) NSString *searchString;

// Search results.
@property (nonatomic, strong) NSArray *searchResults;

// Already fetched information properties tokens, with maximum count.
// Will be used in searchController's table view data source.
@property (nonatomic, strong) NSArray *tokens;

// Cell Heights corresponding to self.tokens.
// Will be used in searchController's table view data source.
@property (nonatomic, strong) NSArray *cellHeights;

// When a token search operation inits, first it will scan previous operations stored in search manager's tokenSearchHistory.
// When it finds not previous operation's search string equal or being the prefix of its own search string, this operation is typed New.
// When it finds a previous operation's search string equal to its own string, this operation is typed overlay, and will use previous operation's results as its own result, and return immediately.
// When it finds a previous operation's search string being the prefix of its own search string, this operation is typed continue, and will continue search based on previous operation's results.
@property (nonatomic, assign) STokenSearchOperationType type;

// If operation's type is new, its previous operation is nil;
// Otherwise it has a non-nil previous operation scanned from search manager's tokenSearchHistory.
@property (nonatomic, strong) TokenSearchOperation *previousOperation;

// Designated Initializer
- (id)initWithSearchString:(NSString *)searchString;

@end