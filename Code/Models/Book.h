//
//  Book.h
//  Documentation
//
//  Created by Song Hui on 13-7-21.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Book : NSObject

@property (strong, nonatomic) NSURL *bookURL;
@property (strong, nonatomic) NSURL *rootURL;
@property (copy, nonatomic) NSString *title;
@property (copy, nonatomic) NSString *type;
@property (strong, nonatomic) NSArray *outlines;
@property (strong, nonatomic) NSArray *expandedOutlines;

- (id)initWithBookDictionary:(NSDictionary *)bookDict
                     bookURL:(NSURL *)bookURL
                     rootURL:(NSURL *)rootURL;

- (void)updateExpandedOutlines;

@end

