#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

// SToken class is one of the two most important objects throughout the entire Xcode Reader Project.
// Because all documents in every Apple's documentation library, are categorized into two category: Token and Node, and stored in Core Data.
// Token represents reference/ API: OBC C++ Class, Protocol, Method, Enum, Struct, Constant, Function, Macro, Notification...
// Node represents guide/ sample code and all the articles.
// They all have many properties and a graphic stored in Core Data's NSManagedObjectModel.
// Throughout Xcode Reader's workflow, tokens and node will be prefetched into memory from Core Data.
// And Their properties may be used in different context.
// So SToken and SNode are classes that wrap all the needed information and helper methods of token and node.
// So they can respectively hold and represent token or node in memory and other view controllers can conveniently fetch information from them.
// The class conforms NSCopying protocal.
 
@interface Token : NSObject <NSCopying>

// Name and ID are the identifier's properties.

// Name.
@property (nonatomic, copy) NSString *name;

// NSManagedObjectID of in Core Data.
@property (nonatomic, strong) NSManagedObjectID *ID;

// All properties below are the information properties
// They would be fetched from Core Data in batch when needed, using method: fetchInformationPropertiesWithContext:.
// The copy method will not copy these properties.

@property (nonatomic, copy) NSString *container;

@property (nonatomic, copy) NSString *abstract;

@property (nonatomic, assign) BOOL deprecated;

@property (nonatomic, copy) NSString *deprecatedSinceVersion;

@property (nonatomic, copy) NSString *type;

// URL, so webView can open it.
@property (nonatomic, strong) NSURL *URL;

// Designated Initializer.
- (id)initWithName:(NSString *)name ID:(NSManagedObjectID *)ID;

// Fetch all information properties.
- (void)fetchInformationPropertiesWithContext:(NSManagedObjectContext *)context;

@end