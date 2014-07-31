//
//  AddressBookContacts.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALAddressBook.h"

@implementation HALAddressBook

#pragma mark - Singleton Method
+ (HALAddressBook *)sharedHALAddressBook
{
    static HALAddressBook *sharedHALAddressBook = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedHALAddressBook = [[self alloc]init];
    });
    
    return sharedHALAddressBook;
}


- (BOOL)isAccessGranted
{

    ABAddressBookRef m_addressbook =  ABAddressBookCreateWithOptions(NULL, NULL);

    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                // Write your code here...
                // Fetch data from SQLite DB
            }
        });
        
        
        ABAddressBookRequestAccessWithCompletion(m_addressbook, ^(bool granted, CFErrorRef error)
        {
          accessGranted = granted;
                                                     
          dispatch_semaphore_signal(sema);
                        });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    if (accessGranted) {
        // Access has been granted
       self.contacts = (__bridge NSArray *)(ABAddressBookCopyArrayOfAllPeople(m_addressbook));

        return YES;
        
    } else {
    // Access has not been granted
    return NO;
    }
}



@end
