//
//  HALContact.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALContact.h"

@interface HALContact ()

@end

@implementation HALContact

- (BOOL)hasMultiplePhoneNumbers
{
    if (self.phoneNumbers.count > 1) {
        return YES;
    } else {
        return NO;
    }
}

@end
