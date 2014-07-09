//
//  FindFriendsViewController.h
//  Halfsies
//
//  Created by Mitchell Porter on 5/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import "MBProgressHUD.h"


@interface HALFindFriendsViewController : UIViewController <MBProgressHUDDelegate, UISearchBarDelegate, UISearchDisplayDelegate>

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;

#pragma mark - Instance Methods
- (void)handleBack;
- (void)finishedAddingFriends;

@end
