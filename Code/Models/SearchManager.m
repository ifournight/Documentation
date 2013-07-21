#import "SearchManager.h"
#import "SearchCompletionOperation.h"
#import "SearchToken.h"
#import "SearchNode.h"
#import "TokenSearchOperation.h"
#import "NodeSearchOperation.h"
#import "LibraryManager.h"
#import "Library.h"

NSString *const SearchResultSectionTypeKey = @"SearchResultSectionTypeKey";
NSString *const SearchResultContentsKey = @"SearchResultContentsKey";
NSString *const SearchResultCellHeightsKey = @"SearchResultCellHeightsKey";

NSString *const SSearchManagerDidBeginPrepareSearchNotification = @"SearchManagerDidBeginPrepareSearch";
NSString *const SSearchManagerDidEndPrepareSearchNotification = @"SearchManagerDidEndPrepareSearch";

@implementation SearchManager

- (id)init
{
    self = [super init];
    if (self) {
        _preparing = NO;

        _searchQueue = [[NSOperationQueue alloc] init];
        _searchQueue.maxConcurrentOperationCount = 5;

        _tokenSearchHistory = [[NSMutableArray alloc] init];
    }
    return self;
}

+ (id)share
{
    static SearchManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[SearchManager alloc] init];
    });
    return share;
}

- (void)prepareSearch
{
    // If already prepareSearch or in progress, return.
    if (self.prefetchedTokens.count != 0) {
        NSLog(@"Search Manager: Already prepared");
        return;
    }
    if (self.preparing) {
        NSLog(@"Search Manager: Prepare in progress");
        return;
    }
    
    [[NSNotificationCenter defaultCenter] postNotificationName:SSearchManagerDidBeginPrepareSearchNotification object:self];
    self.preparing = YES;
    [self.searchQueue addOperationWithBlock:^{
        // NSManagedObjectContext
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        context.persistentStoreCoordinator = [[LibraryManager share] coordinator];

        // ObjectIDDescription
        NSExpressionDescription *objectIDDescription = [[NSExpressionDescription alloc] init];
        objectIDDescription.name = @"Object ID";
        objectIDDescription.expression = [NSExpression expressionForEvaluatedObject];
        objectIDDescription.expressionResultType = NSObjectIDAttributeType;
        
        // Token Fetch Request
        NSFetchRequest *tokenFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Token"];
        // Token Predicate
        NSPredicate *tokenPredicate = [NSPredicate predicateWithFormat:@"parentNode.installDomain == 1 AND tokenType.typeName != 'writerid'"];
        // Token SortDescriptor
        NSSortDescriptor *tokenSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"tokenName" ascending:YES];
        // Token Entity
        NSEntityDescription *tokenEntity = [NSEntityDescription entityForName:@"Token" inManagedObjectContext:context];
        // TokenName attribute
        NSAttributeDescription *tokenNameAttribute = [tokenEntity attributesByName][@"tokenName"];
        // Token Fetch Request Properties
        tokenFetchRequest.predicate = tokenPredicate;
        tokenFetchRequest.sortDescriptors = @[tokenSortDescriptor];
        tokenFetchRequest.resultType = NSDictionaryResultType;
        tokenFetchRequest.propertiesToFetch =  @[objectIDDescription, tokenNameAttribute];
        
        // Node Fetch Request
        NSFetchRequest *nodeFetchRequest = [NSFetchRequest fetchRequestWithEntityName:@"Node"];
        // Node Predicate
        NSPredicate *nodePredicate = [NSPredicate predicateWithFormat:@"installDomain == 1 AND kNodeType == 'folder'"];
        // Node Sort Descriptor
        NSSortDescriptor *nodeSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"kName" ascending:YES];
        // Node Entity
        NSEntityDescription *nodeEntity = [NSEntityDescription entityForName:@"Node" inManagedObjectContext:context];
        // NodeName Attribute
        NSAttributeDescription *nodeNameAttribute = [nodeEntity attributesByName][@"kName"];
        // Node Fetch Request Properties
        nodeFetchRequest.predicate = nodePredicate;
        nodeFetchRequest.sortDescriptors = @[nodeSortDescriptor];
        nodeFetchRequest.resultType = NSDictionaryResultType;
        nodeFetchRequest.propertiesToFetch = @[objectIDDescription, nodeNameAttribute];
        
        // Enum in each library.
        NSMutableArray *tokenFetchResults = [[NSMutableArray alloc] init];
        NSMutableArray *nodeFetchResults = [[NSMutableArray alloc] init];
        for (Library *library in [[LibraryManager share] libraries]) {
            NSPersistentStore *affectedStore = [[[LibraryManager share] coordinator] persistentStoreForURL:library.storeURL];
            tokenFetchRequest.affectedStores = @[affectedStore];
            nodeFetchRequest.affectedStores = @[affectedStore];
            [tokenFetchResults addObjectsFromArray:[context executeFetchRequest:tokenFetchRequest error:nil]];
            [nodeFetchResults addObjectsFromArray:[context executeFetchRequest:nodeFetchRequest error:nil]];
        }

        // Convert fetch results into STokens, SNodes.
        NSMutableArray *tokens = [[NSMutableArray alloc] init];
        NSMutableArray *nodes = [[NSMutableArray alloc] init];
        for (NSDictionary *result in tokenFetchResults) {
            SearchToken *token = [[SearchToken alloc] initWithName:result[@"tokenName"] ID:result[@"Object ID"]];
            [tokens addObject:token];
        }
        for (NSDictionary *result in nodeFetchResults) {
            SearchNode *node = [[SearchNode alloc] initWithName:result[@"kName"] ID:result[@"Object ID"]];
            [nodes addObject:node];
        }
        
        // Main Queue Model Setter
        [[NSOperationQueue mainQueue] addOperationWithBlock:^{
            self.prefetchedTokens = [tokens copy];
            self.prefetchedNodes = [nodes copy];
            [[NSNotificationCenter defaultCenter] postNotificationName:SSearchManagerDidEndPrepareSearchNotification object:self];
            self.preparing = NO;
            NSLog(@"Search Manager: Did end prepare search with token count:%d, node count:%d", self.prefetchedTokens.count, self.prefetchedNodes.count);
        }];
    }];
}

- (void)searchWithSearchString:(NSString *)searchString delegate:(id<SearchManagerDelegate>)delegate
{
	// Delegate.
	self.delegate = delegate;

	// Search completion opeartion's cancellation should be first.
	if (self.searchCompletionOperation) {
    // NSLog(@"Search Manager: \"%@\" search completion operation cancelled because of new search coming.", self.searchCompletionOperation.searchStrong);
        [self.searchCompletionOperation cancel];
    }
	
    if (self.nodeSearchOperation) {
        NSLog(@"Search Manager: \"%@\" node search operation cancelled because of new search coming.", self.nodeSearchOperation.searchString);
        [self.nodeSearchOperation cancel];
    }

    if (self.tokenSearchOperation) {
        if (!self.tokenSearchOperation.isExecuting && !self.tokenSearchOperation.isFinished) {
			NSLog(@"Search Manager: \"%@\" token search operation cancelled before start, and it will be kicked out of history if needed", self.tokenSearchOperation.searchString);
			[self.tokenSearchHistory removeObject:self.tokenSearchOperation];
            [self.tokenSearchOperation cancel];
        }   else {
            NSLog(@"Search Manager: \"%@\" token search operation cancelled during operation, the search will continue when search results part complete, and operation will not be kick out of history", self.tokenSearchOperation.searchString);
            [self.tokenSearchOperation cancel];
        }
    }

    if (searchString.length < 3) {
        NSLog(@"Search Manager: failed to start a new search because the searchStrong's length is less than 3 characters");
        return;
    }

    self.searchString = searchString;

    self.tokenSearchOperation = [[TokenSearchOperation alloc] initWithSearchString:self.searchString];
    NSLog(@"Search Manager: create new \"%@\" token search operation.", self.searchString);
    self.nodeSearchOperation = [[NodeSearchOperation alloc] initWithSearchString:self.searchString];
    NSLog(@"Search Manager: create new \"%@\" node search operation.", self.searchString);
    self.searchCompletionOperation = [[SearchCompletionOperation alloc] initWithSearchString:self.searchString];
    NSLog(@"Search Manager: create new \"%@\" search completion operation.", self.searchString);

    [self.searchCompletionOperation addDependency:self.tokenSearchOperation];
    [self.searchCompletionOperation addDependency:self.nodeSearchOperation];

    [self.searchQueue addOperations:@[self.tokenSearchOperation, self.nodeSearchOperation, self.searchCompletionOperation] waitUntilFinished:NO];

}

@end