#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// Node class is one of the two most important objects throughout the entire Xcode Reader Project.
// Because all documents in every Apple's documentation library, are categorized into two category: Token and Node, and stored in Core Data.
// Token represents reference/ API: OBC C++ Class, Protocol, Method, Enum, Struct, Constant, Function, Macro, Notification...
// Node represents guide/ sample code and all the articles.
// They all have many properties and a graphic stored in Core Data's NSManagedObjectModel.
// Throughout Xcode Reader's workflow, tokens and node will be prefetched into memory from Core Data.
// And Their properties may be used in different context.
// So SToken and Node are classes that wrap all the needed information and helper methods of token and node.
// So they can respectively hold and represent token or node in memory and other view controllers can conveniently fetch information from them.
@interface Node: NSObject <NSCopying>

// Name and ID are the identifier's properties.

// Name.
@property (nonatomic, copy) NSString *name;

// NSManagedObjectID of in Core Data.
@property (nonatomic, strong) NSManagedObjectID *ID;

// Type, expandable, subNodes, URL are information properties.
// They would be fetched from core data in batch when needed, using method fetchInformationPropertiesWithContext:.
// The copy: method would not copy information properties

// Node Type.
@property (nonatomic, copy) NSString *nodeType;

// Document Type
@property (nonatomic, assign) NSInteger documentType;

// When node has subNodes, it is expandable.
@property (nonatomic, assign) BOOL expandable;

// Node's subNodes. 
@property (nonatomic, strong) NSArray *subNodes;

// URL.
@property (nonatomic, strong) NSURL *URL;

// Designated initializer.
- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID;

// Fetch all information properties.
- (void)fetchInformationPropertiesWithContext:(NSManagedObjectContext *)context;

// Compose node's URL.
- (NSURL *)URLForNodeWithObject:(NSManagedObject *)managedObject;

@end