//
//  Book.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "Book.h"
#import "Outline.h"

@implementation Book

- (id)initWithBookDictionary:(NSDictionary *)bookDict bookURL:(NSURL *)bookURL rootURL:(NSURL *)rootURL
{
    if (self = [super init]) {
        _bookURL = bookURL;
        _rootURL = rootURL;
        _title = bookDict[@"title"];
        _type = bookDict[@"type"];
        NSMutableArray *outlines = [[NSMutableArray alloc] init];
        for (NSDictionary *outlineDictionary in bookDict[@"sections"]) {
            Outline *outline = [[Outline alloc] initWithDictionary:outlineDictionary level:0 book:self];
            [outlines addObject:outline];
        }
        _outlines = outlines;
        [self updateExpandedOutlines];
    }
    return self;
}

- (void)updateExpandedOutlines
{
    NSMutableArray *expandedOutlines = [[NSMutableArray alloc] init];
    for (Outline *outline in self.outlines) {
        [expandedOutlines addObject:outline];
        [expandedOutlines addObjectsFromArray:[outline expandedChildren]];
    }
    self.expandedOutlines = expandedOutlines;
}

@end
