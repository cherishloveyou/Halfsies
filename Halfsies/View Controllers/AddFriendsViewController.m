//
//  FindFriendsViewController.m
//  Halfsies
//
//  Created by Mitchell Porter on 5/8/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "AddFriendsViewController.h"
#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import <AddressBook/ABAddressBook.h>
#import <AddressBook/ABPerson.h>
#import <Parse/Parse.h>
#import "HALMediaCaptureVC.h"
#import "MBProgressHUD.h"
#import "SMSWindowViewController.h"

@interface AddFriendsViewController () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) NSMutableArray *potentiaFriendsNotInParseFirstNamesArray;
@property (strong, nonatomic) NSMutableArray *potentiaFriendsPhoneNumberArray;
@property (strong, nonatomic) NSMutableArray *usersToInviteToHalfsies;
@property (strong, nonatomic) NSString *numberValues;

@end

@implementation AddFriendsViewController

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
    
    //Asks for access to Address Book.
    ABAddressBookRef m_addressbook =  ABAddressBookCreateWithOptions(NULL, NULL);
    
    ABAddressBookCopyArrayOfAllPeople(m_addressbook);
    
    NSLog(@"%@", m_addressbook);
    
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
    
    if (accessGranted == 0) {
        
       
        [self performSegueWithIdentifier:@"addFriendsToMediaCaptureSegue" sender:self];
    }
    else if (accessGranted == 1) {
                // Setup and show HUD here
        
        self.HUD = [MBProgressHUD showHUDAddedTo:self.navigationController.view animated:YES];
        self.HUD.mode = MBProgressHUDAnimationFade;
        self.HUD.labelText = @"Finding Friends";
        
        NSArray *allContacts = (__bridge_transfer NSArray
                                *)ABAddressBookCopyArrayOfAllPeople(m_addressbook);
        //Loop through all contacts.
        
        int z = allContacts.count;
        
        for (int i = 0; i < z; i++) {
            //Place current contact in ABRecordRef
            
            ABRecordRef contactPerson = (__bridge ABRecordRef)allContacts[i];
            
            //Create string from current contact's first name property.
            
            NSString *firstName = (__bridge_transfer NSString
                                   *)ABRecordCopyValue(contactPerson, kABPersonFirstNameProperty);
            
            //Create phone number from contact's phone number property.
            
            ABMultiValueRef *phoneNumber = ABRecordCopyValue(contactPerson, kABPersonPhoneProperty);
            NSMutableArray *numbers = [[NSMutableArray alloc] init];
            
            NSString *number = [[NSString alloc] init];
            
            //Loop through all of contact's phone numbers.
            if (phoneNumber) {
                CFIndex numberOfPhoneNumbers = ABMultiValueGetCount(phoneNumber);
                
                for (CFIndex i = 0; i < numberOfPhoneNumbers; i++) {
                    number = (__bridge_transfer NSString *)ABMultiValueCopyValueAtIndex(phoneNumber, i);
                    CFStringRef label = ABMultiValueCopyLabelAtIndex(phoneNumber, i);
                    if (label) {
                        
                        //Add current number to array.
                        if(firstName.length > 0) {
                            
                            [numbers addObject:number];
                            
                        }
                    }
                    CFRelease(label);
                }
                CFRelease(phoneNumber);
            }
            
            int numbersIndex;
            
            //Loop through all of the contact's numbers.
            
            for(numbersIndex = 0; numbersIndex < numbers.count; numbersIndex++) {
                
                //Set string global to current number.
                
                self.numberValues = numbers[numbersIndex];
                
                
                //Add current first name to both arrays. We want them to match for later.
                
                [self.potentiaFriendsNotInParseFirstNamesArray addObject:firstName];
                
                //Add current phone number to array.
                
                [self.potentiaFriendsPhoneNumberArray addObject:self.numberValues];
                
            }
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
    return [self.potentiaFriendsNotInParseFirstNamesArray count];
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
    
    NSString *firstNameForTableView2 = [self.potentiaFriendsNotInParseFirstNamesArray objectAtIndex:indexPath.row];
    
    //Create string from phone number in array.
    
    NSString *userNameForTableView2 = [self.potentiaFriendsPhoneNumberArray objectAtIndex:indexPath.row];
    
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
        SMSWindowViewController *smsVC = segue.destinationViewController;
        
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
