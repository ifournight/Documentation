//
//  Outline.h
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Book;

@interface Outline : NSObject

@property (copy, nonatomic) NSString *title;
@property (assign, nonatomic) NSInteger level;
@property (assign, nonatomic) BOOL expanded;
@property (strong, nonatomic) NSURL *URL;
@property (copy, nonatomic) NSString *fragment;
@property (weak, nonatomic) Book *book;
@property (strong, nonatomic) NSArray *children;

- (id)initWithDictionary:(NSDictionary *)dictionary level:(NSInteger)level book:(Book *)book;

- (NSArray *)expandedChildren;

@end
