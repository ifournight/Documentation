#import "Token.h"
#import "Library.h"
#import "LibraryManager.h"
#import "Node.h"

@implementation Token

- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID
{
    self = [super init];
    if (self) {
        _name = name;
        _ID = ID;
    }
    return self;
}

- (NSString *)containerForTokenWithObject:(NSManagedObject *)managedObject
{
    NSString *container = [managedObject valueForKeyPath:@"container.containerName"];
    if (container.length == 0) {
        container = [managedObject valueForKeyPath:@"parentNode.kName"];
        container = [container stringByReplacingOccurrencesOfString:@" Class" withString:@""];
        container = [container stringByReplacingOccurrencesOfString:@" Reference" withString:@""];
    }
    if (container.length == 0) {
        container = @"No Container";
    }
    return container;
}

- (NSString *)abstractForTokenWithObject:(NSManagedObject *)managedObject
{
    NSString *abstract = [managedObject valueForKeyPath:@"metainformation.abstract"];
    if (abstract.length == 0) {
        abstract = @"No Description";
    }
    return abstract;
}

- (BOOL)isDeprecatedForTokenWithObject:(NSManagedObject *)managedObject
{
    NSSet *deprecatedInVersions = [managedObject  valueForKeyPath:@"metainformation.deprecatedInVersions"];
    return deprecatedInVersions.count > 0 ? YES : NO;
}

- (NSString *)deprecatedSinceVersionForTokenWithObject:(NSManagedObject *)managedObject
{
    NSSet *deprecatedInVersions = [managedObject  valueForKeyPath:@"metainformation.deprecatedInVersions"];
    NSSortDescriptor *versionStringSortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"versionString" ascending:YES];
    return [[deprecatedInVersions sortedArrayUsingDescriptors:@[versionStringSortDescriptor]][0] valueForKey:@"versionString"];
}

- (NSString *)typeForTokenWithObject:(NSManagedObject *)managedObject
{
    return [managedObject valueForKeyPath:@"tokenType.typeName"];
}

- (NSURL *)URLForTokenWithObject:(NSManagedObject *)managedObject
{
    NSURL *URL = nil;

    // Anchor and file path
    NSString *anchor = [managedObject valueForKeyPath:@"metainformation.anchor"];
    NSString *filePath = [managedObject valueForKeyPath:@"metainformation.file.path"];

    NSString *path = nil;
    if (filePath) {
        NSPersistentStore *store = self.ID.persistentStore;
        Library *library = [[LibraryManager share] librariesByStoreID][store.identifier];
        path = [[library.path stringByAppendingPathComponent:kLibraryDocumentPath] stringByAppendingPathComponent:filePath];
    }   else {

        // Parent node path.
        NSManagedObject *parentNode = [managedObject valueForKey:@"parentNode"];
        NSString *parentNodeName = [parentNode valueForKey:@"kName"];
        NSManagedObjectID *parentNodeID = parentNode.objectID;
        Node *parentSNode = [[Node alloc] initWithName:parentNodeName ID:parentNodeID];
        NSString *parentNodePath = [[parentSNode URLForNodeWithObject:parentNode] path];
        path = parentNodePath;
    }

    URL = [NSURL fileURLWithPath:path];

    if (anchor.length > 0) {
        URL = [NSURL URLWithString:[[URL absoluteString] stringByAppendingFormat:@"#%@", anchor]];
    }

    return URL;
}

- (id)copyWithZone:(NSZone *)zone
{
    Token *copy = [[[self class] allocWithZone:zone] init];
    copy.name = [self.name copyWithZone:zone];
    copy.ID = [self.ID copyWithZone:zone];
    return copy;
}

- (void)fetchInformationPropertiesWithContext:(NSManagedObjectContext *)context
{
    NSManagedObject *managedObject = [context existingObjectWithID:self.ID error:nil];
    if (managedObject) {
        self.container = [self containerForTokenWithObject:managedObject];
        self.abstract = [self abstractForTokenWithObject:managedObject];
        self.deprecated = [self isDeprecatedForTokenWithObject:managedObject];
        if (self.deprecated) {
            self.deprecatedSinceVersion = [self deprecatedSinceVersionForTokenWithObject:managedObject];
        } 
        self.type = [self typeForTokenWithObject:managedObject];
        self.URL = [self URLForTokenWithObject:managedObject];
    }   else {
        NSLog(@"SToken: NSManagedObject == nil when fetching information properties");
    }
}

- (NSString *)description
{
	return [NSString stringWithFormat:@"Token: %@\n container: %@\n abstract: %@\n deprecated: %d\n deprecatedSinceVersion: %@\n type: %@\n URL: %@\n \n", self.name, self.container, self.abstract, self.deprecated, self.deprecatedSinceVersion, self.type, self.URL];
}
@end