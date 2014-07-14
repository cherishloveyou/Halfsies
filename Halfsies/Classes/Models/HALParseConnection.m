//
//  ParseConnection.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/11/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALParseConnection.h"
#import "HALUserDefaults.h"

@interface HALParseConnection ()

@end

@implementation HALParseConnection

#pragma mark - Query Methods
- (void)performQuery
{
    // Setup and execute the query
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query whereKey:@"halfOrFull" equalTo:@"half"];
    [query whereKey:@"didRespond" notEqualTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
 
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"There was an error: %@", error);
        } else {
            
            // Store the returned objects and post notification
            HALUserDefaults *userDefaults = [[HALUserDefaults alloc]init];
            [userDefaults storeHalfImageMessages:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHasFinished"
                                                                object:self
                                                              userInfo:nil];
        }

    }];
}

- (void)performQuery2and3
{
    // Setup and execute the query
    PFQuery *query2 = [PFQuery queryWithClassName:@"Messages"];
    [query2 whereKey:@"senderId" equalTo:[[PFUser currentUser]objectId]];
    [query2 whereKey:@"halfOrFull" equalTo:@"full"];
    
    PFQuery *query3 = [PFQuery queryWithClassName:@"Messages"];
    [query3 whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query3 whereKey:@"halfOrFull" equalTo:@"full"];
    
    PFQuery *query2and3 = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query2,query3,nil]];
    [query2and3 orderByDescending:@"createdAt"];

    [query2and3 findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (error) {
            NSLog(@"There was an error: %@", error);
        } else {
            
            // Store the returned objects and post notification
            HALUserDefaults *userDefaults = [[HALUserDefaults alloc]init];
            [userDefaults storeFullImageMessages:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"query2and3HasFinished"
                                                                object:self
                                                              userInfo:nil];
        }
    }];
}

#pragma mark - Signup Methods
- (void)signupNewUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email
{
    // Create new parse user
    PFUser *newUser = [PFUser user];
    newUser.username = username;
    newUser.password = password;
    newUser.email = email;
    
    // Signup new parse user
    [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        
    if (error) {
            
        NSLog(@"There was an error when trying to signup the new user: %@", error);
        
        // Post notification for unsuccessful signup
        [[NSNotificationCenter defaultCenter] postNotificationName:@"unsuccessfulUserSignup"
                                                            object:self
                                                          userInfo:nil];
        
        } else {
            
            // Persist user's username
            HALUserDefaults *userDefaults = [[HALUserDefaults alloc]init];
            
            [userDefaults storeUsername:username];
            
            // Post notification for signup completion
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulUserSignup"
                                                                object:self
                                                              userInfo:nil];
        }
    }];
}

#pragma mark - Login Methods
- (void)loginUserWithUsername:(NSString *)username password:(NSString *)password
{
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        if (error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unsuccessfulUserLogin"
                                                                object:self
                                                              userInfo:nil];
        }
        
        if (user) {
            
            // Persist username
            HALUserDefaults *userDefaults = [[HALUserDefaults alloc]init];
            [userDefaults storeUsername:user.username];
            
            // Post notification for signup completion
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulUserLogin"
                                                                object:self
                                                              userInfo:nil];
        }
    }];

}

@end
