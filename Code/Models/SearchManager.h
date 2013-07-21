#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class TokenSearchOperation, NodeSearchOperation, SearchCompletionOperation,SearchManager;

UIKIT_EXTERN NSString *const SearchResultSectionTypeKey;
UIKIT_EXTERN NSString *const SearchResultContentsKey;
UIKIT_EXTERN NSString *const SearchResultCellHeightsKey;

UIKIT_EXTERN NSString *const SSearchManagerDidBeginPrepareSearchNotification;
UIKIT_EXTERN NSString *const SSearchManagerDidEndPrepareSearchNotification;

@protocol SearchManagerDelegate <NSObject>

- (void)searchManager:(SearchManager *)searchManager didFinishSearchWithSearchResult:(NSArray *)searchResult;

@end

@interface SearchManager : NSObject

// Pre-fetched STokens in memory from Core Data.
@property (nonatomic, strong) NSArray *prefetchedTokens;

// Pre-fetched SNodes in memory from Core Data.
@property (nonatomic, strong) NSArray *prefetchedNodes;

// Boolean value to determine if SSearchManager is in the preparing progress.
@property (nonatomic, assign) BOOL preparing;

// NSOperationQueue.
@property (nonatomic, strong) NSOperationQueue *searchQueue;

// STokenSearchOperation.
@property (nonatomic, strong) TokenSearchOperation *tokenSearchOperation;

// SNodeSearchOperation.
@property (nonatomic, strong) NodeSearchOperation *nodeSearchOperation;

// Completion operation that depend on token and node search operation.
@property (nonatomic, strong) SearchCompletionOperation *searchCompletionOperation;

// Store historical token search operation for following search.
@property (nonatomic, strong) NSMutableArray *tokenSearchHistory;

// Search string.
@property (nonatomic, copy) NSString *searchString;

// Delegate. SSearchController.
@property (nonatomic, weak) id<SearchManagerDelegate> delegate;

// The singleton search manager.
+ (id)share;

// Prefetch all searchable tokens and nodes from Core Data into STokens and SNodes.
- (void)prepareSearch;

// The only single method search manager need to execute a search, the only parameter it needs is searchString.
// Search Manager will take care of everything, like cancel previous search, execute new search, or search operation's dependency and etc.
- (void)searchWithSearchString:(NSString *)searchString delegate:(id<SearchManagerDelegate>)delegate;

@end