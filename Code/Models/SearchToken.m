#import "SearchToken.h"

@implementation SearchToken

- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID
{
    self = [super initWithName:name ID:ID];
    if (self) {
        _searchRange = NSMakeRange(0, name.length);
        _matchRanges = [[NSMutableArray alloc] init];
    }
    return self;
}

- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID searchRange:(NSRange)searchRange matchRanges:(NSMutableArray *)matchRanges
{
    self = [self initWithName:name ID:ID];
    if (self) {
        _searchRange = NSMakeRange(searchRange.location, searchRange.length);
        _matchRanges = [matchRanges mutableCopy];
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    SearchToken *copy = [super copyWithZone:zone];
    if (copy) {
        copy.searchRange = NSMakeRange(self.searchRange.location, self.searchRange.length);
        copy.matchRanges = [[NSMutableArray alloc] initWithArray:self.matchRanges copyItems:YES];
    }
    return copy;
}

@end
