//
//  InboxViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/3/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALInboxViewController.h"
#import <Parse/Parse.h>
#import "HALMediaCaptureVCResponse.h"
#import "HALFinishedHalfsieVC.h"
#import "HALMediaCaptureVC.h"
#import "HALFindFriendsViewController.h"
#import "HALAddressBook.h"
#import "HALParseConnection.h"
#import "HALUserDefaults.h"

@interface HALInboxViewController () <UITableViewDataSource, UITableViewDelegate>

#pragma mark - Properties
@property (nonatomic, strong) UITableViewCell *cell;
@property (nonatomic, strong) PFObject *selectedMessage;
@property (nonatomic, strong) NSArray *halfImageMessages;
@property (nonatomic, strong) NSArray *fullImageMessages;

#pragma mark - IBOutlets
@property (strong, nonatomic) IBOutlet UIImageView *settingsBackground;
@property (strong, nonatomic) IBOutlet UIButton *findFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *inviteFriendsButton;
@property (strong, nonatomic) IBOutlet UIButton *backButton;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

#pragma mark - IBActions
- (IBAction)hideSettings;
- (IBAction)findFriends;
- (IBAction)inviteFriends;

@end

@implementation HALInboxViewController

#pragma mark - View Methods
- (void)viewDidLoad

{
    [super viewDidLoad];
    
    // Setup navigation
    [self navigationSetup];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self retreiveStoredMessages];
    
    [self parseQueries];
}

#pragma mark - Stored Data Methods
- (void)retreiveStoredMessages
{
    self.halfImageMessages = [[NSArray alloc]init];
    self.fullImageMessages = [[NSArray alloc]init];
    
    // Retreive any stored messages
    self.halfImageMessages = [HALUserDefaults retrieveHalfImageMessages];
    self.fullImageMessages = [HALUserDefaults retrieveFullImageMessages];
    
    // Reload table view
    [self.tableView reloadData];
}


#pragma mark - Parse Query Methods
- (void)parseQueries
{
    // Execute Parse queries
    [HALParseConnection performHalfImageQuery];
    [HALParseConnection performFullImageQuery];
    
    // Register for notifications that are posted in HALParseConnection class
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(parseQueryFinished)
                                                 name:@"queryHasFinished"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(parseQuery2and3Finished)
                                                 name:@"query2and3HasFinished"
                                               object:nil];
}

- (void)parseQueryFinished
{
    // Retreive newly updated halfImageMessages
    self.halfImageMessages = [HALUserDefaults retrieveHalfImageMessages];
    
    [self.tableView reloadData];
}

- (void)parseQuery2and3Finished
{
    // Retreive newly updated fullImageMessages
    self.fullImageMessages = [HALUserDefaults retrieveFullImageMessages];
        [self.tableView reloadData];
}

#pragma mark - TableView Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section == 0)
    return [self.halfImageMessages count];
    
    if(section == 1)
    return [self.fullImageMessages count];
    
    else return 0;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    if(section == 0)
        return @"Halfsies You Need To Finish";
    if(section == 1)
        return @"Halfsies You Recently Finished";
    
    else return @"nil";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Set the cell identifier
    static NSString *cellIdentifier = @"SettingsCell";
    
    UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    // Code for the first section in table view
    if (indexPath.section == 0) {
        
    PFObject *message = [self.halfImageMessages objectAtIndex:indexPath.row];
    
    // Create the button images
    UIImage *selectMessageButtonImage = [UIImage imageNamed:@"right-arrow"];
    UIImage *selectMessageButtonImageHighlighted = [UIImage imageNamed:@"right-arrow"];
    
    // Create and setup the open message button
    UIButton *openMessageButton = [[UIButton alloc]init];
    openMessageButton.frame = CGRectMake(237, -10, 64, 64);
    [openMessageButton setImage:selectMessageButtonImage forState:UIControlStateNormal];
    [openMessageButton setImage:selectMessageButtonImageHighlighted forState:UIControlStateHighlighted];
    [openMessageButton setImage:selectMessageButtonImageHighlighted forState:UIControlStateSelected];
    
    [openMessageButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    openMessageButton.tag = indexPath.row;
    
    // Set the cell's properties
    [cell.textLabel setText:[message objectForKey:@"senderName"]];
    [cell.detailTextLabel setText:@""];
    [cell.contentView addSubview:openMessageButton];
    
    } else {
    
    // Code for the second section in table view
    PFObject *message2 = [self.fullImageMessages objectAtIndex:indexPath.row];
    
    // Create the button images
    UIImage *selectMessageButtonImage2 = [UIImage imageNamed:@"right-arrow"];
    UIImage *selectMessageButtonImageHighlighted2 = [UIImage imageNamed:@"right-arrow"];
    
    // Create and setup the open message button
    UIButton *openMessageButton2 = [[UIButton alloc]init];
    openMessageButton2.frame = CGRectMake(237, -10, 64, 64);
    [openMessageButton2 setImage:selectMessageButtonImage2 forState:UIControlStateNormal];
    [openMessageButton2 setImage:selectMessageButtonImageHighlighted2 forState:UIControlStateHighlighted];
    [openMessageButton2 setImage:selectMessageButtonImageHighlighted2 forState:UIControlStateSelected];
        
    [openMessageButton2 addTarget:self action:@selector(handleTouchUpInside2:) forControlEvents:UIControlEventTouchUpInside];
        
    openMessageButton2.tag = indexPath.row;
    
    // set the cell's properties
    [cell.textLabel setText:[message2 objectForKey:@"senderName"]];
    [cell.detailTextLabel setText:@""];
    [cell.contentView addSubview:openMessageButton2];

    }
        return cell;
  
}

#pragma mark - Touch Event Methods
- (void)handleTouchUpInside:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    UIButton *cellButton = (UIButton *)sender;
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:1];
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    self.selectedMessage = [self.halfImageMessages objectAtIndex:indexPath.row];
    
    [self performSegueWithIdentifier:@"segueToMediaCaptureVCResponse" sender:self];
}

- (void)handleTouchUpInside2:(UIButton *)sender
{
    sender.selected = !sender.selected;
  
        UIButton *cellButton = (UIButton *)sender;
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:1];
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
        self.selectedMessage = [self.fullImageMessages objectAtIndex:indexPath.row];
       
        [self performSegueWithIdentifier:@"segueToFinishedHalfsieVC" sender:self];
}

#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self
{
    
    if ([segue.identifier isEqualToString:@"segueToMediaCaptureVCResponse"]) {
  
        HALMediaCaptureVCResponse *topHalf = segue.destinationViewController;
        topHalf.message = _selectedMessage;
        
    } else if ([segue.identifier isEqualToString:@"segueToFinishedHalfsieVC"]) {
   
        HALFinishedHalfsieVC *finished = segue.destinationViewController;
        finished.messagePassedFromInbox = _selectedMessage;
        
    } else if ([segue.identifier isEqualToString:@"inboxToMediaCaptureVC"]) {
 
        
    }
}

- (void)launchFindFriendsView
{
    // Unhide elements
    [self.settingsBackground setHidden:NO];
    [self.findFriendsButton setHidden:NO];
    [self.inviteFriendsButton setHidden:NO];
    [self.backButton setHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - IBActions
- (IBAction)openMediaCaptureVC
{
    [self performSegueWithIdentifier:@"inboxToMediaCaptureVC" sender:self];
}

- (IBAction)hideSettings
{
    // Hide elements
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
}


- (IBAction)findFriends
{
    [self.navigationController setNavigationBarHidden:NO];
    
    // Hide elements
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];

    // Segue
    [self performSegueWithIdentifier:@"segueFromInboxToSearch" sender:self];
}

- (IBAction)inviteFriends
{
    // Create an instance of HALAddressBook
    // and ask if address book access is granted
    HALAddressBook *addressBook = [[HALAddressBook alloc]init];
    BOOL result = [addressBook isAccessGranted];
    
    // Access has not been granted
    if(!result) {

        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't Access Contacts" message:@"Your current settings don't allow Halfsies to access your contacts. Please go to Settings > Privacy > Contacts and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    } else {
    
    // Access has been granted
    [self.navigationController setNavigationBarHidden:NO];
    
    // Hide elements
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];
    
    // Segue
    [self performSegueWithIdentifier:@"segueFromInboxToFindFriends" sender:self];
    }
}

#pragma mark - Navigation Methods
- (void)navigationSetup
{
    // Setup navigation bar
    [self.navigationController setNavigationBarHidden:NO];
    [self.navigationItem setHidesBackButton:YES];
    [self.navigationController setNavigationBarHidden:NO];
    
    
    // Create the find friends button
    CGRect frame = CGRectMake(0, 0, 70, 30);
    UIButton *findFriendsButton = [[UIButton alloc]initWithFrame:frame];
    UIImage *findFriendsButtonImage = [UIImage imageNamed:@"findfriends2"];
    
    [findFriendsButton setBackgroundImage:findFriendsButtonImage forState:UIControlStateNormal];
    [findFriendsButton addTarget:self action:@selector(launchFindFriendsView) forControlEvents:UIControlEventTouchUpInside];
    
    // Add find friends button to navigation bar
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:findFriendsButton];
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    // Create the camera button
    CGRect cameraButtonFrame = CGRectMake(0, 0, 46.5, 33);
    UIImage *cameraButtonImage = [UIImage imageNamed:@"camera3pink"];
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:cameraButtonFrame];
    
    [cameraButton setBackgroundImage:cameraButtonImage forState:UIControlStateNormal];
    [cameraButton addTarget:self action:@selector(openMediaCaptureVC) forControlEvents:UIControlEventTouchUpInside];
    
    // Add camera button to navigation bar
    UIBarButtonItem * cameraButtonBarItem = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    self.navigationItem.rightBarButtonItem = cameraButtonBarItem;
}

#pragma mark - Dealloc Override
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
