//
//  AddressBookContacts.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface HALAddressBook : NSObject

// Properties
@property (nonatomic) NSArray *allContacts;

// Instance methods
// Returns YES if access is granted 
- (BOOL)requestAccess;

@end
