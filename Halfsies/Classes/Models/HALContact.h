//
//  HALContact.h
//  Halfsies
//
//  Created by Mitchell Porter on 7/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "HALAddressBook.h"

@interface HALContact : NSObject

// Properties
@property  (readonly) NSString *firstName;
@property (readonly) NSMutableArray *phoneNumbers;
@property ABRecordRef contactRef;
@property (readonly) ABMultiValueRef contactPhoneNumber;

@end
