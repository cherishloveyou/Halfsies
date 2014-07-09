//
//  AddressBookContacts.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface HALAddressBook : NSObject

#pragma mark - Properties
@property NSArray *contacts;

#pragma mark - Instance Methods

- (BOOL)isAccessGranted;

@end
