//
//  HALUserDefaults.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/11/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//


@interface HALUserDefaults : NSObject

#pragma mark - Class Methods
+ (HALUserDefaults *)sharedHALUserDefaults;

#pragma mark - Instance Methods
- (NSArray *)retrieveHalfImageMessages;
- (NSArray *)retrieveFullImageMessages;
- (void)storeHalfImageMessages:(id)halfImageMessages;
- (void)storeFullImageMessages:(id)fullImageMessages;
- (void)storeUsername:(NSString *)username;

@end
