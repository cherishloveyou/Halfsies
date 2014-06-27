//
//  InboxViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/3/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>

@interface InboxViewController : UIViewController <UITableViewDataSource>

@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (strong, nonatomic) IBOutlet UIImageView *settingsBackground;
@property (strong, nonatomic) IBOutlet UIButton *findFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;

-(IBAction)logOut;
-(IBAction)openMediaCaptureVC;
-(IBAction)hideSettings;
-(IBAction)findFriends;
-(IBAction)inviteFriends;


@end


