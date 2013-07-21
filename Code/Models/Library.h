#import <Foundation/Foundation.h>

// Relative path for library's info.plist.
UIKIT_EXTERN NSString *const kLibraryInfoPlistPath;

// Relative path for library's NSManagedObjectStore.
UIKIT_EXTERN NSString *const kLibraryStorePath;

// Relative path where all library's documents locate.
UIKIT_EXTERN NSString *const kLibraryDocumentPath;

// SLibrary represents one Apple documentation library.
// Each Apple documentation library file locate in App's Document directory.
// And it's LibraryManager's responsibility to locate them and add their's Core Data information.
@interface Library : NSObject

// Absolute path in App's Document directory.
@property (nonatomic, copy) NSString *path;

// Library's name.
@property (nonatomic, copy) NSString *name;

// Copyright.
@property (nonatomic, copy) NSString *copyright;

// ID.
@property (nonatomic, copy) NSString *ID;

// Fallback.
@property (nonatomic, copy) NSString *fallback;

// Library's NSManagedObjectStore's URL that located inside library.
@property (nonatomic, strong) NSURL *storeURL;

// Root SNodes in this library. Will fetched lazily.
@property (nonatomic, strong) NSArray *rootNodes;

// Desiganted Initializer.
- (id)initWithPath:(NSString *)path;

@end

