//
//  ParseConnection.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/11/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Parse/Parse.h>

@interface HALParseConnection : NSObject

#pragma mark - Instance Methods
+ (void)performHalfImageQuery;
+ (void)performFullImageQuery;
+ (void)signupNewUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email;
+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password;

@end
