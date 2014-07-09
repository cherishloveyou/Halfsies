//
//  HALContact.m
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALContact.h"

@interface HALContact ()

// Redeclare readonly properties
@property (readwrite) NSMutableArray *phoneNumbers;
@property (readwrite) NSString *firstName;

@end

@implementation HALContact

#pragma mark - Accessor Methods

- (NSString *)firstName
{
    // Make sure contact property exists
    if (!self.contactRef) {
        NSLog(@"do nothing");

    }
    
    if (!_firstName) {
        _firstName = [[NSString alloc]init];
    }
        _firstName = (__bridge_transfer NSString
                          *)ABRecordCopyValue(self.contactRef, kABPersonFirstNameProperty);
        //NSLog(@"firstName is %@", self.first)
    
    NSLog(@"firstName getter %@", _firstName);

    return _firstName;
}

- (NSArray *)phoneNumbers {
    
    if (_phoneNumbers) {
        [_phoneNumbers removeAllObjects];
    }

    if (!_phoneNumbers) {
        //Create _phoneNumbers array
        _phoneNumbers = [[NSMutableArray alloc]init];
    }
    
    ABMultiValueRef *phoneNumberRef = ABRecordCopyValue(_contactRef, kABPersonPhoneProperty);
    
    NSString *phoneNumber = [[NSString alloc] init];
    
    // Make sure multi value ref exists
    if (phoneNumberRef) {
        CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumberRef);
        
        for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
            phoneNumber = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumberRef, i);
            CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNumberRef, i);
            if (label) {
                
            [_phoneNumbers addObject:phoneNumber];
                NSLog(@"phoneNumbers count in method: %d", _phoneNumbers.count);
            }
            CFRelease(label);
        }
        CFRelease(phoneNumberRef);
    }
    
    NSLog(@"_phoneNumbers still contains: %@", _phoneNumbers);
    return _phoneNumbers;

}


@end
