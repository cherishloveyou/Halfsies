//
//  ParseConnection.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/11/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface ParseConnection : NSObject

- (NSArray *)performQuery;
- (NSArray *)performQuery2and3;

@end
