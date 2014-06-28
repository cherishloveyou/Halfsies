//
//  InboxViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/3/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "InboxViewController.h"
#import <Parse/Parse.h>
#import "MediaCaptureVCResponse.h"
#import "FinishedHalfsieVC.h"
#import "MediaCaptureVC.h"
#import "FindFriendsViewController.h"

@interface InboxViewController () <UITableViewDataSource, UITableViewDelegate>

@property (nonatomic, strong) NSArray *messages;
@property (nonatomic, strong) NSArray *messages2and3;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation InboxViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad

{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    NSLog(@"INBOX VIEW HAS LOADED!");
    
    
    [self.navigationController setNavigationBarHidden:NO];
    



    // Hide the back bar button item.
    
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    //Query Parse for inbox data.
    
    //[self parseQueries];


    
}


-(void)viewWillAppear:(BOOL)animated {
  

    
    NSLog(@"INBOX VIEW WILL APPEAR!");
    
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    UIButton *logOutButton = [[UIButton alloc]initWithFrame:frame];
    
    UIImage *logOutButtonImage = [UIImage imageNamed:@"findfriends2"];
    
    [logOutButton setBackgroundImage:logOutButtonImage forState:UIControlStateNormal];
    
    [logOutButton addTarget:self action:@selector(logOut) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *leftBarButton = [[UIBarButtonItem alloc]initWithCustomView:logOutButton];
    
    self.navigationItem.leftBarButtonItem = leftBarButton;
    
    
    
    CGRect cameraButtonFrame = CGRectMake(0, 0, 46.5, 33);
    
    UIImage *cameraButtonImage = [UIImage imageNamed:@"camera3pink"];
    
    
    
    UIButton *cameraButton = [[UIButton alloc]initWithFrame:cameraButtonFrame];
    
    [cameraButton setBackgroundImage:cameraButtonImage forState:UIControlStateNormal];
    //[cameraButton setImage:cameraButtonImage forState:UIControlStateNormal];
    
    [cameraButton addTarget:self action:@selector(openMediaCaptureVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cameraButtonBarItem = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    
    self.navigationItem.rightBarButtonItem = cameraButtonBarItem;
    
    
    
    
    
    
    
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSData *data = [standardDefaults objectForKey:@"parseMessages1"];
    NSArray *retrievedArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    //self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    
    
    
    
    
    
    NSData *data2 = [standardDefaults objectForKey:@"parseMessages2"];
    NSArray *retrievedArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    //self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
    
   

        
        self.messages = retrievedArray1;
        self.messages2and3 = retrievedArray2;
        
        
        
    
    
    
    [self parseQueries];

    
    
}



-(void) viewDidAppear {
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}




- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    
    
    
    
    
    return 2;
    
    
    
}
    




-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    
    
    
    
    
    if(section == 0)
        
        
        return [self.messages count];
    
    if(section == 1)
        
        
        return [self.messages2and3 count];
    
    
        else return 0;
    
    
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    if(section == 0)
        return @"Halfsies You Need To Finish";
    if(section == 1)
        return @"Halfsies You Recently Finished";
    
    else return @"nil";
    
}



-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    
    static NSString *cellIdentifier = @"SettingsCell";

    UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    
    
    if (indexPath.section == 0) {
        
    
    PFObject *message = [self.messages objectAtIndex:indexPath.row];
    
    
    UIImage *selectMessageButtonImage = [UIImage imageNamed:@"right-arrow"];
    
    
    UIImage *selectMessageButtonImageHighlighted = [UIImage imageNamed:@"right-arrow"];
    
    
    
    UIButton *openMessageButton = [[UIButton alloc]init];
    
    openMessageButton.frame = CGRectMake(237, -10, 64, 64);
    
    [openMessageButton setImage:selectMessageButtonImage forState:UIControlStateNormal];
    [openMessageButton setImage:selectMessageButtonImageHighlighted forState:UIControlStateHighlighted];
    [openMessageButton setImage:selectMessageButtonImageHighlighted forState:UIControlStateSelected];
    
    [openMessageButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
    
    
    openMessageButton.tag = indexPath.row;
        
    
        
    
    
    [cell.textLabel setText:[message objectForKey:@"senderName"]];
    
        NSString *fileType = [message objectForKey:@"fileType"];
        
            
        
        if([fileType isEqualToString:@"image"]) {
            
            //cell.imageView.image = [UIImage imageNamed:@"icon_image"];
            
            
            
        } else {
            
            //no image
        }

    
        
    [cell.detailTextLabel setText:@""];
    
    [cell.contentView addSubview:openMessageButton];
    
    
    } else {
        
        
        
        
        PFObject *message2 = [self.messages2and3 objectAtIndex:indexPath.row];
        
        
        UIImage *selectMessageButtonImage2 = [UIImage imageNamed:@"right-arrow"];
        
        
        UIImage *selectMessageButtonImageHighlighted2 = [UIImage imageNamed:@"right-arrow"];
        
        
        
        UIButton *openMessageButton2 = [[UIButton alloc]init];
        
        openMessageButton2.frame = CGRectMake(237, -10, 64, 64);
        
        [openMessageButton2 setImage:selectMessageButtonImage2 forState:UIControlStateNormal];
        [openMessageButton2 setImage:selectMessageButtonImageHighlighted2 forState:UIControlStateHighlighted];
        [openMessageButton2 setImage:selectMessageButtonImageHighlighted2 forState:UIControlStateSelected];
        
        [openMessageButton2 addTarget:self action:@selector(handleTouchUpInside2:) forControlEvents:UIControlEventTouchUpInside];
        
        
        
        openMessageButton2.tag = indexPath.row;
        
        
        
        
        [cell.textLabel setText:[message2 objectForKey:@"senderName"]];
        
            NSString *fileType = [message2 objectForKey:@"fileType"];
        
            if([fileType isEqualToString:@"image"]) {
            
            //cell.imageView.image = [UIImage imageNamed:@"icon_image"];
            
            
            
        } else {
            
            //no image
        }

        
        [cell.detailTextLabel setText:@""];
        
        [cell.contentView addSubview:openMessageButton2];
        
    }
    
    
    
    //[cell.textLabel setText:userName];
    
    return cell;
    
    
    
    
}
    


- (void)handleTouchUpInside:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    
    UIButton *cellButton = (UIButton *)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:1];
    
    
    

    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    

    
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    

    
    self.selectedMessage = [self.messages objectAtIndex:indexPath.row];
    

    
    [self performSegueWithIdentifier:@"segueToMediaCaptureVCResponse" sender:self];
    

    
}
    

    
- (void)handleTouchUpInside2:(UIButton *)sender {
        sender.selected = !sender.selected;
        
        
        UIButton *cellButton = (UIButton *)sender;
        
        NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:1];
    
        NSLog(@"BUTTON FOR SECOND SECTION PRESSED!");

    
    
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
        self.selectedMessage = [self.messages2and3 objectAtIndex:indexPath.row];
       
        [self performSegueWithIdentifier:@"segueToFinishedHalfsieVC" sender:self];
        
    
    }

    

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    
    // This is our actual implmenetation body code which starts with an if statement. This says "If our segue identifier is equal to signupYoVerificationSegue then do this...
    
    if ([segue.identifier isEqualToString:@"segueToMediaCaptureVCResponse"]) {
        
        NSLog(@"prepareForSegue to MediaCaptureVCResponse.");
        
        MediaCaptureVCResponse *topHalf = segue.destinationViewController;
        
        //SMSWindowViewController *smsVC = segue.destinationViewController;
        
        
        //NSString *stringForProperty = [[NSString alloc]init];
        //stringForProperty = @"YES";
        
        topHalf.message = _selectedMessage;
        
        //smsVC.usersToInviteToHalfsies = _usersToInviteToHalfsies;
        
        
    } else if ([segue.identifier isEqualToString:@"segueToFinishedHalfsieVC"]) {
        
        
        NSLog(@"prepareForSegue to FinishedHalfsieVC.");

        
        FinishedHalfsieVC *finished = segue.destinationViewController;
        
        finished.messagePassedFromInbox = _selectedMessage;
        
        
    } else if ([segue.identifier isEqualToString:@"inboxToMediaCaptureVC"]) {
        
        
        NSLog(@"prepareForSegue to MediaCaptureVC.");

        
        
        
        
        
    }
    
    
    
    
}






-(void)parseQueries {
    
    
    self.messages = [[NSArray alloc]init];
    
    self.messages2and3 = [[NSArray alloc]init];
    
    
    
    
    NSLog(@"The current user's objectId is: %@", [[PFUser currentUser]objectId]);
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query whereKey:@"halfOrFull" equalTo:@"half"];
    [query whereKey:@"didRespond" notEqualTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"5");
        
        
        if(error) {
            
            
            NSLog(@"Errors have happened: %@ %@", error, [error userInfo]);
            
        } else {
            
            
            //We found messages
            
            self.messages = objects;
            
            NSLog(@"query1 objects count: %lu", (unsigned long)objects.count);
            NSLog(@"query1 objects : %@", objects);


            //NSLog(@"Received %d messages.", [self.messages count]);
            
      
    
    
            NSLog(@"2nd query starting..");
            
            
            
            //I THINK THIS QUERY WAS SPECIFICALLY FOR THE PERSON WHO JUST FINISHED THE FULL IMAGE
            
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Messages"];
            
            [query2 whereKey:@"senderId" equalTo:[[PFUser currentUser]objectId]];
            [query2 whereKey:@"halfOrFull" equalTo:@"full"];
            //[query2 orderByDescending:@"createdAt"];
            
            
            
            PFQuery *query3 = [PFQuery queryWithClassName:@"Messages"];
            
            [query3 whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
            [query3 whereKey:@"halfOrFull" equalTo:@"full"];
            //[query3 orderByDescending:@"createdAt"];
            
            
            
            
            PFQuery *query2and3 = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query2,query3,nil]];
            [query2and3 orderByDescending:@"createdAt"];
            
            [query2and3 findObjectsInBackgroundWithBlock:^(NSArray *objects2and3, NSError *error) {
                
                if(error) {
                    
                    NSLog(@"There was an error: %@", error);
                    
                    
                } else {
                    
                    
                    NSLog(@"Everything was successful.");
                    
                    
                    NSLog(@"query2and3 objects count: %lu", (unsigned long)objects2and3.count);
                    NSLog(@"query2and3 objects: %@", objects2and3);

                    
                    self.messages2and3 = objects2and3;
                    
                    
                
                
                
                
                
                NSLog(@"self.messages.count: %lu", (unsigned long)self.messages.count);
                NSLog(@"self.messages2and3.count: %lu", (unsigned long)self.messages2and3.count);
                

            
            
        
                    
                            
                            [self.tableView reloadData];
                            
                    
                            
                            //Start adding the NSUserDefaults code here
                            
                            
                            
                            //Create an instance of NSUserDefaults
                            
                            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                            
                            
                            //Add our NSArray object called messages to the user defaults for key "parseMessages1"
                            
                            if (self.messages.count != 0) {
                                
                                
                                
                                [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.messages] forKey:@"parseMessages1"];
                                
                                
                                
                            }
                            
                            //Add our NSArray object called messages2 to the user defaults for key "parseMessages2"
                            
                            
                            if (self.messages2and3.count != 0) {
                                
                                
                                
                                [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.messages2and3] forKey:@"parseMessages2"];
                                
                            }
                            
                            
                            //Save the changes you just made to the user defaults.
                            
                            [standardDefaults synchronize];
                            
                            
                            
                            
                            
                            
                            NSData *data = [standardDefaults objectForKey:@"parseMessages1"];
                            NSArray *retrievedArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                            //self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
                            
                            
                            NSLog(@"The retreivedArray1: %@", retrievedArray1);
                            
                            NSLog(@"Count of the retreivedArray1: %d", retrievedArray1.count);
                            
                            
                            NSData *data2 = [standardDefaults objectForKey:@"parseMessages2"];
                            NSArray *retrievedArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
                            //self.myDictionary = [[NSDictionary alloc] initWithDictionary:retrievedDictionary];
                            
                            
                            NSLog(@"The retreivedArray2: %@", retrievedArray2);
                            
                            NSLog(@"Count of the retreivedArray2: %d", retrievedArray2.count);
                    
                }
            }];

    

        }
        
        
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.cell = [[UITableViewCell alloc]init];
    
}

-(IBAction)logOut {
    
   //[PFUser logOut];
   
    //NSLog(@"User has been logged out from Parse.");
    
    //[self.navigationController popToRootViewControllerAnimated:NO];
    
    
    
    [self.settingsBackground setHidden:NO];
    [self.findFriendsButton setHidden:NO];
    [self.inviteFriendsButton setHidden:NO];
    [self.backButton setHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    
    //[self.settingsBackground setAlpha:0.7];
    
    
   /* FindFriendsViewController *findFriendsVC = [self.storyboard instantiateViewControllerWithIdentifier:@"FindFriendsViewController"];
    
    [self.navigationController pushViewController:findFriendsVC animated:YES]; */
    
}

-(IBAction)openMediaCaptureVC {
    
    NSLog(@"User has pressed the camera button");
    
    //MediaCaptureVC *mvc = [[MediaCaptureVC alloc]init];
    
    [self performSegueWithIdentifier:@"inboxToMediaCaptureVC" sender:self];
    
    //[self.navigationController pushViewController:mvc animated:YES];
    //[self.navigationController presentViewController:mvc animated:YES completion:nil];
    
}

- (IBAction)hideSettings {
    
    
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];
    
    [self.navigationController setNavigationBarHidden:NO];

    
}


- (IBAction)findFriends {
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];

    
    [self performSegueWithIdentifier:@"segueFromInboxToSearch" sender:self];
    
    
}

- (IBAction)inviteFriends {
    
    
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
                                                     
                                                     NSLog(@"Has access been granted?: %hhd", accessGranted);
                                                     
                                                     
                                                     NSLog(@"Has there been an error? %@", error);
                                                     
                                                     
                                                     dispatch_semaphore_signal(sema);
                                                     
                                                 });
        
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        
        
        
        
    }
    
    
    if(accessGranted == 0) {
        
        
        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Can't Access Contacts" message:@"Your current settings don't allow Halfsies to access your contacts. Please go to Settings > Privacy > Contacts and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [alertView show];
        
    }
    
    

    if(accessGranted == 1) {
    
    [self.navigationController setNavigationBarHidden:NO];
    
    [self.settingsBackground setHidden:YES];
    [self.findFriendsButton setHidden:YES];
    [self.inviteFriendsButton setHidden:YES];
    [self.backButton setHidden:YES];
    
    
    [self performSegueWithIdentifier:@"segueFromInboxToFindFriends" sender:self];
    

    }
    
}



@end
