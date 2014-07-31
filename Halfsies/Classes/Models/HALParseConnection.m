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
+ (void)performHalfImageQuery
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
            [HALUserDefaults storeHalfImageMessages:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"queryHasFinished"
                                                                object:self
                                                              userInfo:nil];
        }

    }];
}

+ (void)performFullImageQuery
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
            [HALUserDefaults storeFullImageMessages:objects];
            [[NSNotificationCenter defaultCenter] postNotificationName:@"query2and3HasFinished"
                                                                object:self
                                                              userInfo:nil];
        }
    }];
}

+ (void)performFriendsRelationForCurrentUserQuery
{
    PFRelation *friendsRelation = [[PFUser currentUser]objectForKey:@"friendsRelation"];
    PFQuery *query = [friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(error) {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"performFriendsRelationForCurrentUserQueryFailed" object:self userInfo:@{@"error" : error}];
            
        } else {
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"performFriendsRelationForCurrentUserQuerySucceeded" object:self userInfo:@{@"succeeded" : objects}];
        }
        
    }];

}

#pragma mark - Signup Methods
+ (void)signupNewUserWithUsername:(NSString *)username password:(NSString *)password email:(NSString *)email
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
            [HALUserDefaults storeUsername:username];
            
            // Post notification for signup completion
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulUserSignup"
                                                                object:self
                                                              userInfo:nil];
        }
    }];
}

+ (void)isUsernameAvailable:(NSString *)lowercaseUsername
{
    PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    [query whereKey:@"lowercaseUsername" equalTo:lowercaseUsername];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if (error) {
            NSLog(@"There was an error when querying Parse for the lowercaseUsername key");
        } else if (objects.count == 0) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"usernameIsAvailable" object:self];
        } else if (objects.count == 1) {
            [[NSNotificationCenter defaultCenter]postNotificationName:@"usernameIsNotAvailable" object:self];
        }
    }];
}

#pragma mark - Login Methods
+ (void)loginUserWithUsername:(NSString *)username password:(NSString *)password
{
    
    [PFUser logInWithUsernameInBackground:username password:password block:^(PFUser *user, NSError *error) {
        
        if (error) {
            
            [[NSNotificationCenter defaultCenter] postNotificationName:@"unsuccessfulUserLogin"
                                                                object:self
                                                              userInfo:nil];
        }
        
        if (user) {
            
            // Persist username
            [HALUserDefaults storeUsername:user.username];
            
            // Post notification for signup completion
            [[NSNotificationCenter defaultCenter] postNotificationName:@"successfulUserLogin"
                                                                object:self
                                                              userInfo:nil];
        }
    }];

}

@end
