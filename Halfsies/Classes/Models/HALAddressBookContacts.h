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


@interface HALAddressBookContacts : NSObject

// Properties
@property (nonatomic, strong, readonly) NSArray *allContacts;
@property (readonly) ABAddressBookRef m_addressbook;


// Instance methods
// Returns YES if access is granted 
- (BOOL)requestAccess;

@end
