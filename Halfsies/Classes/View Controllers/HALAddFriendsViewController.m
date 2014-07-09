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
#import "MBProgressHUD.h"
#import "HALSMSWindowViewController.h"
#import "HALContact.h"

@interface HALAddFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *potentiaFriendsNotInParseFirstNamesArray;
@property (strong, nonatomic) NSMutableArray *potentiaFriendsPhoneNumberArray;
@property (strong, nonatomic) NSMutableArray *usersToInviteToHalfsies;
@property (strong, nonatomic) NSString *numberValues;
@property HALAddressBook *addressBook;
@property HALContact *currentContact;

@property NSMutableArray *friends;

@end

@implementation HALAddFriendsViewController

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.currentUser = [PFUser currentUser];

    [self.navigationController setNavigationBarHidden:NO];

    // Hide the back bar button item.
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
    //Create right bar button.
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

    //Create left bar button.
    
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




-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
}


-(void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:NO];
    
    self.potentiaFriendsNotInParseFirstNamesArray = [[NSMutableArray alloc]init];
    self.potentiaFriendsPhoneNumberArray = [[NSMutableArray alloc]init];
    
    self.usersToInviteToHalfsies = [[NSMutableArray alloc]init];
    
    self.addFriendButton = [[UIButton alloc]init];
    
    self.cell = [[UITableViewCell alloc]init];
    
    self.numberValues = [[NSString alloc]init];
    
    
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
        
            //So if "Steve" has 2 phone numbers, he'll be added to our
            // friends array twice, once for each phone number.
            
            for (int index = 0; index < contact.phoneNumbers.count; index++) {
                HALContact *copyOfContact = [[HALContact alloc]init];
                copyOfContact.mainPhoneNumber = contact.phoneNumbers[index];
                copyOfContact.firstName = contact.firstName;
                
                // Add copyOfContact to the friends array
                [self.friends addObject:copyOfContact];
            }
      
    }
    

    
    //Set table view's datasource and delegate.
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    //Hide the MBProgress HUD.
    
    [self.HUD hide:YES];
    
    //Reload table view data.
    
    [self.tableView reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)hudWasHidden:(MBProgressHUD *)hud {
    // Remove HUD from screen when the HUD hides
    [self.HUD removeFromSuperview];
    self.HUD = nil;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [self.friends count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Friends to Invite";
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    //Set cell identifier name. Should match identifier set in IB.
    
    static NSString *cellIdentifier = @"SettingsCell";
    
    //Create cell instance.
    
    UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    //Create string from first name in array.
    
    NSString *firstNameForTableView2 = [[self.friends objectAtIndex:indexPath.row]firstName];
    
    //Create string from phone number in array.
    
    NSString *userNameForTableView2 = [[self.friends objectAtIndex:indexPath.row]mainPhoneNumber];
    //Create cell button
    
    UIImage *addFriendButtonImage = [UIImage imageNamed:@"invitefriend1"];
    UIImage *addFriendButtonImageHighlighted = [UIImage imageNamed:@"inviteselected1"];
    
    UIButton *addFriendButton = [[UIButton alloc]init];
    
    addFriendButton.frame = CGRectMake(237, 7, 70, 30);
    
    [addFriendButton setImage:addFriendButtonImage forState:UIControlStateNormal];
    [addFriendButton setImage:addFriendButtonImageHighlighted forState:UIControlStateHighlighted];
    [addFriendButton setImage:addFriendButtonImageHighlighted forState:UIControlStateSelected];
    
    [addFriendButton addTarget:self action:@selector(handleTouchUpInsideForNonUsers:) forControlEvents:UIControlEventTouchUpInside];
    
    //Set cell button's tag property.
    
    addFriendButton.tag = indexPath.row;
    
    //Set cell's title.
    
    [cell.textLabel setText:firstNameForTableView2];
    
    //Set cell's subtitle.
    
    [cell.detailTextLabel setText:userNameForTableView2];
    
    //Add cell button to cell's content view.
    
    [cell.contentView addSubview:addFriendButton];
    
    return cell;
}

- (void)handleTouchUpInsideForNonUsers:(UIButton *)sender {
    sender.selected = !sender.selected;

    UIButton *cellButton = (UIButton *)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:0];

    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];

    if(sender.state == 5) {
        
        //This add's the username to the array.
        
        
        [self.usersToInviteToHalfsies addObject:cell.detailTextLabel.text];
        
    } else {
        //This removes the username from the array.
        
        [self.usersToInviteToHalfsies removeObject:cell.detailTextLabel.text];
        
    }
}

-(IBAction)finishedAddingFriends {
    
    //This will segue to the next VC which is the Media Capture VC.
    if(![self.usersToInviteToHalfsies count]) {

        [self performSegueWithIdentifier:@"addFriendsToMediaCaptureSegue" sender:self];

    } else {
        [self performSegueWithIdentifier:@"addFriendsToSMSWindowSegue" sender:self];
        
        [self.navigationController setNavigationBarHidden:YES];
    }
}

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    if ([segue.identifier isEqualToString:@"addFriendsToSMSWindowSegue"]) {
        HALSMSWindowViewController *smsVC = segue.destinationViewController;
        
        NSString *stringForProperty = [[NSString alloc] init];
        stringForProperty = @"YES";
        
                smsVC.usersToInviteToHalfsies = _usersToInviteToHalfsies;
        
        //inviteText creates the custom text message that will be loaded in the next VC. It even includes the current user's username.
        NSString *inviteText = [[NSString alloc]initWithFormat:@"Hey, come join this cool new app called Halfsies, and we can go halfsies on creating photos together! My username is %@ and you can download the iPhone app here in the App Store: https://itunes.apple.com/app/id869085222", _currentUser.username];
        
        //This sets the Media Capture VC's textMessageInviteText property to the custom text object we just created.
        smsVC.textMessageInviteText = inviteText;
    }
}

-(void)handleBack {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
