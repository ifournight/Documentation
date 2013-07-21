//
//  SSearchCompletionOperation.h
//  Xcode Reader
//
//  Created by Song Hui on 13-5-13.
//  Copyright (c) 2013年 Song Hui. All rights reserved.
//

#import <Foundation/Foundation.h>

// Search manager's search completion operation.
// Which depend on token and node search operations.
@interface SearchCompletionOperation : NSOperation

// Search string.
@property (nonatomic, copy) NSString *searchString;

// Designated Initializer
- (id)initWithSearchString:(NSString *)searchString;

@end
