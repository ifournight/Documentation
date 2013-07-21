#import "LibraryManager.h"
#import "Library.h"

const NSString *LibraryManagerWillReloadLibrariesNotification = @"Library Manager Will Reload Libraries";
const NSString *LibraryManagerDidReloadLibrariesNotification = @"Library Manager Did Reload Libraries";

@interface LibraryManager()

// Use SLibrary's rootNodes property to prefetch all libraries' root nodes.
- (void)prefetchLibrariesRootNodes;

@end

@implementation LibraryManager

- (id)init
{
    self = [super init];
    if (self) {
        // NSManagedObjectModel
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Documentation" withExtension:@"mom"];
        NSManagedObjectModel *model = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];

        // NSPersistentStoreCoordinator.
        _coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:model];
    }
    return self;
}

+ (id)share
{
    static LibraryManager *share = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        share = [[LibraryManager alloc] init];
    });
    return share;
}

- (void)reloadLibraries
{
    // Remove old store in coordinator.
    if (self.coordinator.persistentStores) {
        for (NSPersistentStore *store in self.coordinator.persistentStores) {
            [self.coordinator removePersistentStore:store error:nil];
        }
    }

    // Scan and locate files with docset extension in App's Document directory.
    NSMutableArray *libraries = [[NSMutableArray alloc] init];
    NSMutableDictionary *librariesByStoreID = [[NSMutableDictionary alloc] init];
    
    NSString *documentPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)[0];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    for (NSString *path in [fileManager contentsOfDirectoryAtPath:documentPath error:nil]) {
        if ([path.pathExtension isEqualToString:@"docset"]) {
            NSString *libraryPath = [documentPath stringByAppendingPathComponent:path];
            Library *library = [[Library alloc] initWithPath:libraryPath];
            
            NSError *error = nil;
            
            // Add persistent store into coordinator.
            [self.coordinator addPersistentStoreWithType:NSSQLiteStoreType
                                           configuration:nil
                                                     URL:library.storeURL
                                                 options:@{NSReadOnlyPersistentStoreOption : @YES}
                                                   error:&error];

            if (error) {
                NSLog(@"%@", error);
            }   else {
                // Add skip backup attribute.
                NSURL *libraryURL = [NSURL fileURLWithPath:libraryPath];
                [self addSkipBackupAttributeToItemAtURL:libraryURL];
                
                NSPersistentStore *store = [self.coordinator persistentStoreForURL:library.storeURL];
                
                if (store == nil) {
                    NSLog(@"Library: %@ failed to create persistent store", library.name);
                }
                
                [libraries addObject:library];
                [librariesByStoreID setObject:library forKey:store.identifier];
            }
        }
    }

    self.libraries = libraries;
    self.librariesByStoreID = librariesByStoreID;

    // Every time reload libraries, prefetch libraries' root nodes.
    [self prefetchLibrariesRootNodes];
}

- (void)prefetchLibrariesRootNodes
{

}

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSURL *)URL
{
    assert([[NSFileManager defaultManager] fileExistsAtPath: [URL path]]);

    NSError *error = nil;
    BOOL success = [URL setResourceValue: [NSNumber numberWithBool: YES]
                                  forKey: NSURLIsExcludedFromBackupKey error: &error];
    if(!success){
        NSLog(@"Error excluding %@ from backup %@", [URL lastPathComponent], error);
    }
    return success;
}

@end