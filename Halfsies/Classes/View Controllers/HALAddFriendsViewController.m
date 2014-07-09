//
//  FindFriendsViewController.m
//  Halfsies
//
//  Created by Mitchell Porter on 5/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALAddFriendsViewController.h"
#import "HALAddressBook.h"
#import <Parse/Parse.h>
#import "HALMediaCaptureVC.h"
#import "HALSMSWindowViewController.h"
#import "HALContact.h"

@interface HALAddFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *friendsToInvite;
@property HALAddressBook *addressBook;
@property HALContact *currentContact;
@property NSMutableArray *friends;
@property (nonatomic, strong) PFUser *currentUser;

#pragma mark - Instance Methods
- (IBAction)finishedAddingFriends;

@end

@implementation HALAddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.currentUser = [PFUser currentUser];
    
    // Call navigation setup method
    [self navigationSetup];
}

- (void)viewDidAppear:(BOOL)animated
{
    
    [super viewDidAppear:NO];
    
    // Create an instance of HALAddressBook
    HALAddressBook *addressBook = [[HALAddressBook alloc]init];
    
    // Ask for access to the user's address book
    BOOL result = [addressBook isAccessGranted];
    
    if (!result) {
        [self performSegueWithIdentifier:@"addFriendsToMediaCaptureSegue" sender:self];
    }
    
    // Access has been granted
    // Create array of all address book contacts
    NSArray *contacts = [addressBook contacts];
    
    
    // Initialize our friends array
    self.friends = [[NSMutableArray alloc]init];
    
    
    // Loop through all of the contacts.
    // Create an instance of HALContact
    // Set the instance's contactRef, firstName and phoneNumbers properties
    
    
    for (id currentContact in contacts) {
        // Create an instance of HALContact,
        // set its contactRef property,
        // set its firstName property,
        HALContact *contact = [[HALContact alloc]init];
        contact.contactRef = (__bridge ABRecordRef)(currentContact);
        contact.firstName = (__bridge_transfer NSString
                             *)ABRecordCopyValue(contact.contactRef, kABPersonFirstNameProperty);
        
        // If firstName is nil, continue
        if (!contact.firstName) continue;
        
       // Grab all of the phone number values for this contact
       NSArray *phoneNumberValues =  (__bridge NSArray *)(ABRecordCopyValue(contact.contactRef, kABPersonPhoneProperty));
        
        // Place a copy of all phone numbers into contact's
        // phoneNumber property
        contact.phoneNumbers = (__bridge NSArray *)(ABMultiValueCopyArrayOfAllValues((__bridge ABMultiValueRef)(phoneNumberValues)));
        
        
        // Check if the contact has multiple phone numbers
        BOOL result = [contact hasMultiplePhoneNumbers];
        
        // If contact only has one phone number, then add the
        // number from the phoneNumbers property into the
        // contact's mainPhoneNumber property
        if (!result) {
            contact.mainPhoneNumber = contact.phoneNumbers[0];
            // Add contact to friends array
            [self.friends addObject:contact];
            continue;
        }
            // Loop through the contacts phone numbers
            // and for every phone number, create a copy of the contact
            // and place the current phone number at index in
            // the copy's mainPhoneNumber property.
        
            // So if "Steve" has 2 phone numbers, he'll be added to our
            // friends array twice, once for each phone number.
            
            for (int index = 0; index < contact.phoneNumbers.count; index++) {
                HALContact *copyOfContact = [[HALContact alloc]init];
                copyOfContact.mainPhoneNumber = contact.phoneNumbers[index];
                copyOfContact.firstName = contact.firstName;
                
                // Add copyOfContact to the friends array
                [self.friends addObject:copyOfContact];
            }
    }

    // Set table view's datasource and delegate
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    
    // Reload table view data
    [self.tableView reloadData];
}


#pragma mark - TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.friends count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return @"Friends to Invite";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    // Set cell identifier name. Should match identifier set in IB
    static NSString *cellIdentifier = @"SettingsCell";
    
    // Create cell
    UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    // Create string for friend's first name
    // and string for friend's phone number
    NSString *firstNameForTableView = [[self.friends objectAtIndex:indexPath.row]firstName];
    NSString *phoneNumber = [[self.friends objectAtIndex:indexPath.row]mainPhoneNumber];

    // Create images for the buttom
    UIImage *inviteFriendButtonImage = [UIImage imageNamed:@"invitefriend1"];
    UIImage *inviteFriendButtonImageHighlighted = [UIImage imageNamed:@"inviteselected1"];
    
    // Create and setup the button
    UIButton *inviteFriendButton = [[UIButton alloc]init];
    inviteFriendButton.frame = CGRectMake(237, 7, 70, 30);
    [inviteFriendButton setImage:inviteFriendButtonImage forState:UIControlStateNormal];
    [inviteFriendButton setImage:inviteFriendButtonImageHighlighted forState:UIControlStateHighlighted];
    [inviteFriendButton setImage:inviteFriendButtonImageHighlighted forState:UIControlStateSelected];
    
    // Set button's selector
    [inviteFriendButton addTarget:self action:@selector(handleTouchUpInsideForNonUsers:) forControlEvents:UIControlEventTouchUpInside];
    
    // Set button's tag property
    inviteFriendButton.tag = indexPath.row;
    
    // Set cell's title, subtitle,
    // and add button to cell's subview
    [cell.textLabel setText:firstNameForTableView];
    [cell.detailTextLabel setText:phoneNumber];
    [cell.contentView addSubview:inviteFriendButton];
    
    return cell;
}

#pragma mark - Touch Events
- (void)handleTouchUpInsideForNonUsers:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    // Create array
    self.friendsToInvite = [[NSMutableArray alloc]init];

    // Set cell button, index path, and cell
    UIButton *cellButton = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:0];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if(sender.state == 5) {
        // Add the username to the array.
        [self.friendsToInvite addObject:cell.detailTextLabel.text];
        
    } else {
        // Remove the username from the array.
        [self.friendsToInvite removeObject:cell.detailTextLabel.text];
        
    }
}

- (IBAction)finishedAddingFriends
{
    // Segue based on friends to invite
    if(![self.friendsToInvite count]) {
        // No friends to invite
        [self performSegueWithIdentifier:@"addFriendsToMediaCaptureSegue" sender:self];

    } else {
        // There are friends to invite
        [self performSegueWithIdentifier:@"addFriendsToSMSWindowSegue" sender:self];
        [self.navigationController setNavigationBarHidden:YES];
    }
}

#pragma mark - Segue Method

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self
{
    if ([segue.identifier isEqualToString:@"addFriendsToSMSWindowSegue"]) {
        
        // Create view controller and set as
        // destination controller
        HALSMSWindowViewController *smsVC = segue.destinationViewController;
        smsVC.usersToInviteToHalfsies = _friendsToInvite;
        
        NSString *stringForProperty = @"YES";
        
        // Create the custom text message that will be loaded in the next view controller
        NSString *inviteText = [[NSString alloc]initWithFormat:@"Hey, come join this cool new app called Halfsies, and we can go halfsies on creating photos together! My username is %@ and you can download the iPhone app here in the App Store: https://itunes.apple.com/app/id869085222", _currentUser.username];
        
        // Set view controller's property as our invite text
        smsVC.textMessageInviteText = inviteText;
    }
}

#pragma mark - Navigation Methods

- (void)handleBack
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)navigationSetup
{
    [self.navigationController setNavigationBarHidden:NO];
    
    // Hide the back bar button item
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
    // Create right bar button
    UIImage* firstButtonImage = [UIImage imageNamed:@"nextbutton3"];
    CGRect frame = CGRectMake(0, 0, 70, 30);
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(finishedAddingFriends)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    self.navigationItem.rightBarButtonItem = rightBarButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
    
    // Create left bar button
    
    CGRect frame2 = CGRectMake(0, 0, 25, 25);
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"backarrow2"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frame2];
    [leftButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = backButton;
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];

}

@end
