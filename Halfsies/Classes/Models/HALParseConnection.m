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

@end
