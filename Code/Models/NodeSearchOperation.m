//
//  SNodeSearchOperation.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "NodeSearchOperation.h"
#import "SearchManager.h"
#import "SearchNode.h"
#import "NodeCell.h"
#import "LibraryManager.h"

const NSInteger kMaximumNodeCount = 10;

@implementation NodeSearchOperation

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
    NSLog(@"NodeSearchOperation. \"%@\":start.", self.searchString);

    // Convert search string into search words
    NSArray *searchWords = [self.searchString componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    searchWords = [searchWords filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"length != 0"]];

    // Enum word match in search manager's nodes
    NSMutableArray *results = [[NSMutableArray alloc] init];

    NSArray *prefetchedNodes = [[SearchManager share] prefetchedNodes];

    if (prefetchedNodes.count ==0) {
        NSLog(@"Error: Node Search Operation: start while search manager hasn't prepare search yet!");
        return;
    }   else {
        for (SearchNode *node in prefetchedNodes) {
            // Cancellation check.
            if ([self isCancelled]) {
                NSLog(@"Node Search Operation.\"%@\": cancelled in search progress.", self.searchString);
                return;
            }

            // Word match.
            BOOL allWordMatch = YES;
            NSMutableArray *matchRanges = [[NSMutableArray alloc] init];
            NSInteger minimumMatchLocation = WINT_MAX;

            for (NSString *searchWord in searchWords) {
                NSRange matchRange = [node.name rangeOfString:searchWord options:NSCaseInsensitiveSearch];
                if (matchRange.location != NSNotFound) {
                    [matchRanges addObject:[NSValue valueWithRange:matchRange]];
                    minimumMatchLocation = MIN(minimumMatchLocation, matchRange.location);
                }   else {
                    allWordMatch = NO;
                    break;
                }
            }

            if (allWordMatch == YES) {
                SearchNode *newNode = [[SearchNode alloc] initWithName:node.name ID:node.ID];
                newNode.matchRanges = matchRanges;
                newNode.minimumMatchLocation = minimumMatchLocation;
                [results addObject:newNode];
            }
        }

        if (self.isCancelled) return;

        // Sort search results.
        NSSortDescriptor *minimumMatchLocationSortDescritptor = [NSSortDescriptor sortDescriptorWithKey:@"minimumMatchLocation" ascending:YES];
        NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
        NSArray *sortedResults = [results sortedArrayUsingDescriptors:@[minimumMatchLocationSortDescritptor, nameSortDescriptor]];

        // Search part complete.
		self.searchResults = sortedResults;
		NSLog(@"Node Search Operation.\"%@\": search part complete with result's count %d", self.searchString, self.searchResults.count);

		NSArray *nodes = nil;
		if (self.searchResults.count > kMaximumNodeCount) {
			nodes = [self.searchResults subarrayWithRange:NSMakeRange(0, kMaximumNodeCount)];
		}	else {
			nodes = self.searchResults;
		}

        // NSManagedObjectContext
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
		context.persistentStoreCoordinator = [[LibraryManager share] coordinator];
        
        // Fetch node information properties
        for (SearchNode *node in nodes) {
            if ([self isCancelled]) return;
			
            [node fetchInformationPropertiesWithContext:context];
        }

        // Fetch information properties part complete.
		self.nodes = nodes;
		NSLog(@"Node Search Operation.\"%@\": fetch part complete with result's count %d", self.searchString, self.nodes.count);

        // Cell Heights
        NodeCell *sampleCell = [[NodeCell alloc] initWithStyle:UITableViewCellStyleDefault
                                               reuseIdentifier:nil];
        
        NSMutableArray *cellHeights = [[NSMutableArray alloc] init];
        
        for (SearchNode *node in nodes) {
            sampleCell.node = node;
            [cellHeights addObject:[NSNumber numberWithFloat:sampleCell.intrinsicContentSize.height]];
        }
        
        self.cellHeights = cellHeights;
        NSLog(@"Node Search Operation.\"%@\": cell heights part complete with result's count %d", self.searchString, self.cellHeights.count);

        return;
    }
}

@end