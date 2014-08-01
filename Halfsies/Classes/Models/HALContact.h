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
@property (nonatomic) NSArray *phoneNumbers;
@property (nonatomic) NSString *mainPhoneNumber;
@property (nonatomic) NSString *firstName;
@property (nonatomic) ABRecordRef contactRef;

#pragma mark - Instance Methods
- (BOOL)hasMultiplePhoneNumbers;

@end
