//
//  HALContact.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALAddressBook.h"

@interface HALContact : NSObject

#pragma mark - Properties
@property NSArray *phoneNumbers;
@property NSString *mainPhoneNumber;
@property NSString *firstName;
@property ABRecordRef contactRef;

#pragma mark - Instance Variables
- (BOOL)hasMultiplePhoneNumbers;

@end
