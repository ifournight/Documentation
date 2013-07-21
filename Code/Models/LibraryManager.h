#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

UIKIT_EXTERN const NSString *LibraryManagerWillReloadLibrariesNotification;
UIKIT_EXTERN const NSString *LibraryManagerDidReloadLibrariesNottification;

// LibraryManager is a singleton object, use share to get it.
// It is responsible for Manage all the libraries in App's Document directory, reload when necessary.
// And each reload libraries, library manager will load all libraries' Core Data stuff appropriately, 
// for other class that that need to fetch something from Core Data, like SSearchLibrary's search job; Library's root nodes; SNode, SToken fetch information properties.
@interface LibraryManager : NSObject

// Managed libraries.
@property (nonatomic, strong) NSArray *libraries;

// An dictionary which each library object's key is library's corresponding managed object store's ID.
// This property's purpose:
// Because NSManagedObject like token and node, don't have a property or method that can fetch its corresponding NSManagedObjectStore, and Project needs to get object's store to compose object's URL.
// But NSManagedObject can fetch its storeID, so this property can help SToken and SNode to get its mother library.
@property (nonatomic, strong) NSDictionary *librariesByStoreID;

// NSPersistentStoreCoordinator that holds all libraries' store within itself.
// The one and only coordinator throughout the application.
@property (nonatomic, strong) NSPersistentStoreCoordinator *coordinator;

// Use this method to get the singleton manager.
+ (id)share;

// Reload libraries.
- (void)reloadLibraries;

@end

