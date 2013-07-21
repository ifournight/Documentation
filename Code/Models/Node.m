#import "Node.h"
#import "Library.h"
#import "LibraryManager.h"

@implementation Node

- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID
{
    self = [super init];
    if (self) {
        _name = name;
        _ID = ID;
    }
    return self;
}

- (id)copyWithZone:(NSZone *)zone
{
    Node *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    copy.ID = [self.ID copyWithZone:zone];
    return copy;
}

- (NSString *)nodeTypeForNodeWithObject:(NSManagedObject *)managedObject
{
    return [managedObject valueForKey:@"kNodeType"];
}

- (NSInteger) documentTypeForNodeWithObject:(NSManagedObject *)managedObject
{
    return [[managedObject valueForKey:@"kDocumentType"] intValue];
}

- (BOOL)isExpandableForNodeWithObject:(NSManagedObject *)managedObject
{
    return [[managedObject valueForKey:@"kIsSearchable"] boolValue] ? NO : YES;
}

- (NSArray *)subNodesForNodeWithObject:(NSManagedObject *)managedObject
{
    NSSet *orderedSubNodes = [managedObject valueForKey:@"orderedSubnodes"];
    NSSortDescriptor *orderSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"order" ascending:YES];
    return [[orderedSubNodes sortedArrayUsingDescriptors:@[orderSortDescriptor]] valueForKeyPath:@"node"];
}

- (NSURL *)URLForNodeWithObject:(NSManagedObject *)managedObject
{
    NSURL *URL = nil;
    
    NSPersistentStore *store = self.ID.persistentStore;
    Library *library = [[LibraryManager share] librariesByStoreID][store.identifier];

    NSString *kPath = [managedObject valueForKey:@"kPath"];
    NSString *kAnchor = [managedObject valueForKey:@"kAnchor"];
    
    NSString *path = [[library.path stringByAppendingPathComponent:kLibraryDocumentPath] stringByAppendingPathComponent:kPath];
    
    URL = [NSURL fileURLWithPath:path];

    if (kAnchor) {
        URL = [NSURL URLWithString:[[URL absoluteString] stringByAppendingFormat:@"#%@", kAnchor]];
    }
	return URL;
}

- (void)fetchInformationPropertiesWithContext:(NSManagedObjectContext *)context
{
    NSManagedObject *managedObject = [context existingObjectWithID:self.ID error:nil];
    if (managedObject) {
        self.nodeType = [self nodeTypeForNodeWithObject:managedObject];
        self.documentType = [self documentTypeForNodeWithObject:managedObject];
        self.expandable = [self isExpandableForNodeWithObject:managedObject];
        if (self.expandable) {
            self.subNodes = [self subNodesForNodeWithObject:managedObject];
        }
        self.URL = [self URLForNodeWithObject:managedObject];
    }   else {
        NSLog(@"Node: NSManagedObject == nil when fetching information properties");
    }
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Node: %@\n nodeType: %@\n documentType: %d\n expandable: %d\n subNodesCount:%d\n URL:%@\n \n", self.name, self.nodeType, self.documentType, self.expandable, self.subNodes.count, self.URL];
}


@end