//
//  HALUserDefaults.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/11/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALUserDefaults.h"

@interface HALUserDefaults ()

@end

@implementation HALUserDefaults


- (NSArray *)retrieveHalfImageMessages
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [standardDefaults objectForKey:@"halfImageMessages"];
    NSArray *retrievedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return retrievedArray;
}

- (NSArray *)retrieveFullImageMessages
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    NSData *data = [standardDefaults objectForKey:@"fullImageMessages"];
    NSArray *retreivedArray = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    return retreivedArray;
}

- (void)storeHalfImageMessages:(id)halfImageMessages
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:halfImageMessages] forKey:@"halfImageMessages"];
    [standardDefaults synchronize];
}

- (void)storeFullImageMessages:(id)fullImageMessages
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:fullImageMessages] forKey:@"fullImageMessages"];
    [standardDefaults synchronize];
}

- (void)storeUsername:(NSString *)username
{
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    [standardDefaults setObject:username forKey:@"username"];
    [standardDefaults synchronize];
}

@end
