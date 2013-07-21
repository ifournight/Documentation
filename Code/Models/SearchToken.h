#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>
#import "Token.h"

// A Subclass of SToken that has extra properties to assistant STokenSearchOperation.(operation for short)
@interface SearchToken : Token <NSCopying>

// When operation do word match and character match, token's searchRange property determine this token's searchRange.
// Read STokenSearchOperation.m to see the details.
@property (nonatomic, assign) NSRange searchRange;

// A mutable array contain all the match range of search string with this token.
@property (nonatomic, strong) NSMutableArray *matchRanges;

// The minimum location among all ranges in matchRanges, used for sorting.
@property (nonatomic, assign) NSInteger minimumMatchLocation;

// The maximum length among all ranges in matchRanges, used for sorting.
@property (nonatomic, assign) NSInteger maximumMatchLength;

// Call this initializer to create token with specific searchRange and matchRanges.
// If aiming to create a token with default searchRange and matchRange, use super class's initializer - initWithName:ID:.
- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID searchRange:(NSRange)searchRange matchRanges:(NSMutableArray *)matchRanges;

@end