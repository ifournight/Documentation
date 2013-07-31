//
//  Bookmark.m
//  Documentation
//
//  Created by Song Hui on 13-7-22.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "Bookmark.h"
#import "Node.h"
#import "LibraryManager.h"
#import "Library.h"

#define BookmarkNameKey @"BookmarkNameKey"
#define BookmarkTypeKey @"BookmarkTypeKey"
#define BookmarkLibraryIDKey @"BookmarkLibraryIDKey"
#define BookmarkLibraryNameKey @"BookmarkLibraryNameKey"
#define BookmarkFolderKey @"BookmarkFolderKey"

@implementation Bookmark

- (id)initWithName:(NSString *)name
{
    self = [super init];
    if (self) {
        _name = name;
        NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
        context.persistentStoreCoordinator = [[LibraryManager share] coordinator];
        // Fetch from Core Data
        NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kName == %@", name];
        request.resultType = NSManagedObjectResultType;
        request.predicate = predicate;
        NSManagedObject *managedObject = [context executeFetchRequest:request error:nil][0];
        // _type
        NSLog(@"Create Bookmark with name:%@", [managedObject valueForKey:@"kName"]);
        NSInteger documentType = [[managedObject valueForKey:@"kDocumentType"] intValue];
        if (documentType == 1) {
            _type = BookmarkTypeSampleCode;
        }   else if (documentType == 2) {
            _type = BookmarkTypeReference;
        }   else {
            _type = BookmarkTypeGuide;
        }
        // _libraryName
        // _libraryIdentifier
        NSPersistentStore *store = managedObject.objectID.persistentStore;
        Library *library = [[LibraryManager share] librariesByStoreID][store.identifier];
        _libraryName = library.name;
        _libraryIdentifier = library.ID;
    }
    return self;
}

- (id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super init];
    if (self) {
        _name = [aDecoder decodeObjectForKey:BookmarkNameKey];
        _type = [aDecoder decodeIntegerForKey:BookmarkTypeKey];
        _libraryIdentifier = [aDecoder decodeObjectForKey:BookmarkLibraryIDKey];
        _libraryName = [aDecoder decodeObjectForKey:BookmarkLibraryNameKey];
        _folder = [aDecoder decodeObjectForKey:BookmarkFolderKey];
    }
    return self;
}

- (void)encodeWithCoder:(NSCoder *)aCoder
{
    [aCoder encodeObject:self.name forKey:BookmarkNameKey];
    [aCoder encodeInteger:self.type forKey:BookmarkTypeKey];
    [aCoder encodeObject:self.libraryIdentifier forKey:BookmarkLibraryIDKey];
    [aCoder encodeObject:self.libraryName forKey:BookmarkLibraryNameKey];
    [aCoder encodeObject:self.folder forKey:BookmarkFolderKey];
}

- (NSURL *)URLForBookmark
{
    NSURL *URL = nil;
    NSManagedObjectContext *context = [[NSManagedObjectContext alloc] init];
    context.persistentStoreCoordinator = [[LibraryManager share] coordinator];
    
    // Fetch from Core Data
    NSFetchRequest *request = [[NSFetchRequest alloc] initWithEntityName:@"Node"];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"kName == %@", self.name];
    request.resultType = NSManagedObjectResultType;
    request.predicate = predicate;
    NSManagedObject *managedObject = [context executeFetchRequest:request error:nil][0];
    // URLForNodeWithObject:
    NSPersistentStore *store = managedObject.objectID.persistentStore;
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

@end
