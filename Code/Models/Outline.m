//
//  Outline.m
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import "Outline.h"
#import "Book.h"

@implementation Outline

- (id)initWithDictionary:(NSDictionary *)dictionary level:(NSInteger)level book:(Book *)book
{
    if (self = [super init]) {
        _title = dictionary[@"title"];
        _level = level;
        _book = book;
        NSString *href = dictionary[@"href"];
        NSString *aref = dictionary[@"aref"];
        _URL = [NSURL URLWithString:href relativeToURL:book.rootURL];
        // NSLog(@"Outline %@ path: %@", _title, path);
//        NSLog(@"Outline %@ URL: %@", _title, _URL);
        _fragment = aref;
        NSMutableArray *children = [[NSMutableArray alloc] init];
        for (NSDictionary *childDictionary in dictionary[@"sections"]) {
            Outline *child = [[Outline alloc] initWithDictionary:childDictionary
                                                           level:level + 1
                                                            book:book];
            [children addObject:child];
        }
        _children = children;
        _expanded = NO;
    }
    return self;
}

- (NSArray *)expandedChildren
{
    NSMutableArray *expandedChildren = [[NSMutableArray alloc] init];
    if (self.expanded) {
        for (Outline *child in self.children) {
            [expandedChildren addObject:child];
            [expandedChildren addObjectsFromArray:[child expandedChildren]];
        }
    }
    return expandedChildren;
}

@end