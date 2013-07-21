//
//  STokenSearchOperation.m
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "TokenSearchOperation.h"
#import "SearchToken.h"
#import "TokenCell.h"
#import "SearchManager.h"
#import "SearchToken.h"
#import "LibraryManager.h"

const NSInteger kMaximumTokenCount = 20;

@interface TokenSearchOperation()

- (NSArray *)charactersOfString:(NSString *)aString;
- (NSMutableArray *)mergeRanges:(NSMutableArray *)ranges;

@end

@implementation TokenSearchOperation

- (id)initWithSearchString:(NSString *)searchString
{
    self = [super init];
    if (self) {
        _searchString = searchString;

        // Scan previous operations.
        NSMutableArray *deprecatedOperations = [[NSMutableArray alloc] init];

        for (TokenSearchOperation *previousOperation in [[SearchManager share] tokenSearchHistory]) {
            if ([self.searchString isEqualToString:previousOperation.searchString]) {
                _type = STokenSearchOperationTypeOverlay;
                _previousOperation = previousOperation;
                break;
            }   else if ([self.searchString hasPrefix:previousOperation.searchString]) {
                _type = STokenSearchOperationTypeContinue;
                _previousOperation = previousOperation;
                break;
            }   else {
                [deprecatedOperations addObject:previousOperation];
            }
        }

        if (self.previousOperation == nil) {
            _type = STokenSearchOperationTypeNew;
        }
        
        // Remove deprecated operations.
        [[[SearchManager share] tokenSearchHistory] removeObjectsInArray:deprecatedOperations];

        // Add this operation if needed.
        if (_type != STokenSearchOperationTypeOverlay) {
            [[[SearchManager share] tokenSearchHistory] insertObject:self atIndex:0];
        }

        // Scan complete.
        NSLog(@"Token Search History Scan Complete, now contains:\n");
        for (TokenSearchOperation *operation in [[SearchManager share] tokenSearchHistory]) {
            NSLog(@"    %@\n", operation.searchString);
        }

        // Dependency.
        if (_type != STokenSearchOperationTypeNew) {
            [self addDependency:_previousOperation];
        }

    }
    return self;
}

- (void)main
{
    NSLog(@"Token Search Operation.\"%@\": Begin.", self.searchString);
    NSArray *previousResults = nil;
    NSString *remainString = nil;
    NSMutableArray *wordMatchResults = [[NSMutableArray alloc] init];
    NSMutableArray *characterMatchCandidates = [[NSMutableArray alloc] init];
    NSMutableArray *characterMatchResults = [[NSMutableArray alloc] init];
    NSMutableArray *results = [[NSMutableArray alloc] init];

    if (self.type == STokenSearchOperationTypeNew) {
        remainString = self.searchString;
        previousResults = [[SearchManager share] prefetchedTokens];
        NSLog(@"Token Search Operation.\"%@\".Type.\"New\": Begin.", self.searchString);
    }   else if (self.type == STokenSearchOperationTypeContinue) {
        remainString = [self.searchString substringFromIndex:NSMaxRange([self.searchString rangeOfString:self.previousOperation.searchString])];
        previousResults = self.previousOperation.searchResults;
        NSLog(@"Token Search Operation.\"%@\".Type.\"Continue\": Begin.", self.searchString);
    }   else if (self.type == STokenSearchOperationTypeOverlay) {
        self.searchResults = self.previousOperation.searchResults;
        NSLog(@"Token Search Operation.\"%@\".Type.\"Overlay\": Begin and search part complete.", self.searchString);
//        return;
    }

	// Search part.
	if (self.type == STokenSearchOperationTypeNew || self.type == STokenSearchOperationTypeContinue) {

		// If need character match
		BOOL characterMatch = (self.type == STokenSearchOperationTypeNew) || remainString.length > 0;

		// Word Match
		for (SearchToken *token in previousResults) {
			NSRange matchRange = [token.name rangeOfString:remainString options:NSCaseInsensitiveSearch range:token.searchRange];
			if (matchRange.location != NSNotFound) {
				SearchToken* tokenCopy = [token copy];
				tokenCopy.searchRange = NSMakeRange(NSMaxRange(matchRange), token.name.length - NSMaxRange(matchRange));
				[tokenCopy.matchRanges addObject:[NSValue valueWithRange:matchRange]];
				[wordMatchResults addObject:tokenCopy];
			}   else {
				// If token failed word match, add it to characterMatchCandidates if characterMatch is needed
				if (characterMatch == YES) {
					SearchToken *tokenCopy = [token copy];
					[characterMatchCandidates addObject:tokenCopy];
				}
			}
		}

		// Character Match
		if (characterMatch == YES) {
			NSArray *remainCharacters = [self charactersOfString:remainString];
			for (NSString *searchCharacter in remainCharacters) {
				NSMutableArray *newCharacterMatchCandidates = [[NSMutableArray alloc] init];
				for (SearchToken *token in characterMatchCandidates) {
					NSRange matchRange = [token.name rangeOfString:searchCharacter options:NSCaseInsensitiveSearch range:token.searchRange];
					if (matchRange.location != NSNotFound) {
						token.searchRange = NSMakeRange(NSMaxRange(matchRange), token.name.length - NSMaxRange(matchRange));
						[token.matchRanges addObject:[NSValue valueWithRange:matchRange]];
						[newCharacterMatchCandidates addObject:token];
					}
				}
				characterMatchCandidates = newCharacterMatchCandidates;
			}
		}
		characterMatchResults = characterMatchCandidates;
 
		[results addObjectsFromArray:wordMatchResults];
		[results addObjectsFromArray:characterMatchResults];
        
        // Merge match ranges, calculate minimumMatchLocation, maximumMatchLength.
        for (SearchToken *token in results) {
            token.matchRanges = [self mergeRanges:token.matchRanges];
        }

		for (SearchToken *token in results) {
			token.minimumMatchLocation = [token.matchRanges[0] rangeValue].location;
			for (NSValue *matchRangeValue in token.matchRanges) {
				NSRange matchRange = [matchRangeValue rangeValue];
				token.maximumMatchLength = MAX(token.maximumMatchLength, matchRange.length);
			}
		}

		// Sort results.
		NSSortDescriptor *maximumMatchLengthSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"maximumMatchLength" ascending:NO];
		NSSortDescriptor *minimumMatchLocationSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"minimumMatchLocation" ascending:YES];
		NSSortDescriptor *nameSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"name" ascending:YES];
		NSArray *sortedResults = [results sortedArrayUsingDescriptors:@[maximumMatchLengthSortDescriptor, minimumMatchLocationSortDescriptor, nameSortDescriptor]];

		// Search part complete
		self.searchResults = sortedResults;
		NSLog(@"Token Search Operation:\"%@\": search part complete with result's count %d", self.searchString, self.searchResults.count);
	}

    // Filter maximum count tokens, and fetch their information properties in batch.
	NSArray *tokens = nil;
	if (self.searchResults.count > kMaximumTokenCount) {
		tokens = [self.searchResults subarrayWithRange:NSMakeRange(0, kMaximumTokenCount - 1)];
	}	else {
		tokens = self.searchResults;
	}
    
    // NSManagedObjectContext.
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
	context.persistentStoreCoordinator = [[LibraryManager share] coordinator];

    for (SearchToken *token in tokens) {
        if ([self isCancelled]) return;
        [token fetchInformationPropertiesWithContext:context];
    }

    // Fetch information properties part complete.
	self.tokens = tokens;
	NSLog(@"Token Search Operation:\"%@\": fetch part complete with result's count %d", self.searchString, self.tokens.count);
	
    // Cell height composition.
    TokenCell *sampleCell = [[TokenCell alloc] initWithStyle:UITableViewCellStyleDefault
                                             reuseIdentifier:nil];
    
    NSMutableArray *cellHeights = [[NSMutableArray alloc] init];
    for (SearchToken *token in tokens) {
        sampleCell.token = token;
        [cellHeights addObject:[NSNumber numberWithFloat:sampleCell.intrinsicContentSize.height]];
    }
    
    self.cellHeights = cellHeights;
    NSLog(@"Token Search Operation:\"%@\": cell height part complete with result's count %d", self.searchString, self.cellHeights.count);

    return;
}

- (NSArray *)charactersOfString:(NSString *)aString {
	NSMutableArray *characters = [[NSMutableArray alloc] init];

	for (int i = 0; i < aString.length; i++) {
		char character = [aString characterAtIndex:i];
		[characters addObject:[NSString stringWithFormat:@"%c", character]];
	}

	return [characters copy];
}

- (NSMutableArray *)mergeRanges:(NSMutableArray *)ranges {
    NSMutableArray *mergedRanges = [[NSMutableArray alloc] init];

	BOOL start = YES;
	NSRange lastRange;

	for (NSValue *rangeValue in ranges) {
		NSRange range = [rangeValue rangeValue];

		// Start
		if (start) {
			lastRange = range;
			start = NO;
			continue;
		}

		// If be neighbourhood, then merge.
		if (range.location == NSMaxRange(lastRange)) {
			lastRange = NSMakeRange(lastRange.location, lastRange.length + range.length);
		}	else {
			[mergedRanges addObject:[NSValue valueWithRange:lastRange]];
			lastRange = range;
		}
	}

	// Don't miss the last range.
	[mergedRanges addObject:[NSValue valueWithRange:lastRange]];
	
    return mergedRanges;
}
@end