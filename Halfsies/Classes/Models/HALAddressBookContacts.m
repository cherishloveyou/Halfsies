//
//  AddressBookContacts.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALAddressBookContacts.h"

@interface HALAddressBookContacts ()

// Redeclare the readonly properties
@property (readwrite) ABAddressBookRef m_addressbook;
@property (nonatomic, strong, readwrite) NSArray *allContacts;
@property (readwrite) ABMultiValueRef contactPhoneNumber;

@end

@implementation HALAddressBookContacts

#pragma mark - Request Access

- (BOOL)requestAccess
{
    //Asks for access to Address Book.
    self.m_addressbook =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAddressBookCopyArrayOfAllPeople(self.m_addressbook);
    
    NSLog(@"%@", self.m_addressbook);
    
    __block BOOL accessGranted = NO;
    if (ABAddressBookRequestAccessWithCompletion != NULL) {
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            @autoreleasepool {
                // Write your code here...
                // Fetch data from SQLite DB
            }
        });
        
        ABAddressBookRequestAccessWithCompletion(self.m_addressbook, ^(bool granted, CFErrorRef error)
            
                                                 {
                                                     accessGranted = granted;
                                                     
                                                     dispatch_semaphore_signal(sema);
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
    }
    
    if (accessGranted) {
        // Access has been granted
        return YES;
    }
    // Access has not been granted
    return NO;
}

#pragma mark Accessor Methods

-(NSArray *)allContacts
{
    if (!self.allContacts) {
        self.allContacts = [[NSArray alloc]init];
    }
    
    self.allContacts = (__bridge_transfer NSArray*)ABAddressBookCopyArrayOfAllPeople(self.m_addressbook);
    
    return self.allContacts;
}



@end
