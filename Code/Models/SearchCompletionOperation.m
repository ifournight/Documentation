//
//  SSearchCompletionOperation.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "SearchCompletionOperation.h"
#import "SearchManager.h"
#import "NodeSearchOperation.h"
#import "TokenSearchOperation.h"


@implementation SearchCompletionOperation

- (id)initWithSearchString:(NSString *)searchString
{
	self = [super init];
	if (self) {
		_searchString = searchString;
	}
	return self;
}

- (void)main
{
	NSLog(@"SearchCompletionOperation. \"%@\":start.", self.searchString);

	if ([self isCancelled]) return;

    NSMutableArray *searchResults = [[NSMutableArray alloc] init];
    
    // Check search strings, if search strings are not equal, completion should return.
	if ([self.searchString isEqualToString:[[SearchManager share] searchString]]) {
		// Obtain nodes, cell datas.
		if ([self.searchString isEqualToString:[[[SearchManager share] nodeSearchOperation] searchString]]) {
            if ([[[[SearchManager share] nodeSearchOperation] nodes] count] > 0 ) {
                NSDictionary *nodeResult = @{SearchResultSectionTypeKey: @"Guide",
                                             SearchResultContentsKey : [[[SearchManager share] nodeSearchOperation] nodes],
                                             SearchResultCellHeightsKey : [[[SearchManager share] nodeSearchOperation] cellHeights]};
                [searchResults addObject:nodeResult];
            }
		}	else {
			return;
		}
		// Obtain tokens, cell datas.
		if ([self.searchString isEqualToString:[[[SearchManager share] tokenSearchOperation] searchString]]) {
            if ([[[[SearchManager share] tokenSearchOperation] tokens] count] > 0) {
                NSDictionary *tokenResult = @{SearchResultSectionTypeKey: @"Reference",
                                              SearchResultContentsKey : [[[SearchManager share] tokenSearchOperation] tokens],
                                              SearchResultCellHeightsKey : [[[SearchManager share] tokenSearchOperation] cellHeights]};
                [searchResults addObject:tokenResult];

            }
        }	else {
			return;
		}
	}	else {
		return;
	}
    
    if ([self isCancelled]) return;
    
	[[NSOperationQueue mainQueue] addOperationWithBlock:^{
		NSLog(@"Search Completion Operation \"%@\" complete and call delegate method.", self.searchString);
		[[[SearchManager share] delegate] searchManager:[SearchManager share]
                        didFinishSearchWithSearchResult:searchResults];
	}];
    
}

@end
