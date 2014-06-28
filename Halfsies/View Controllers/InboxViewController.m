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
    
    
    
    [self.navigationController setNavigationBarHidden:NO];
    



    // Hide the back bar button item.
    
    
    [self.navigationItem setHidesBackButton:YES];
    
   

    
}


-(void)viewWillAppear:(BOOL)animated {
  

    
    
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
    
    [cameraButton addTarget:self action:@selector(openMediaCaptureVC) forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem * cameraButtonBarItem = [[UIBarButtonItem alloc]initWithCustomView:cameraButton];
    
    self.navigationItem.rightBarButtonItem = cameraButtonBarItem;
        NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    
    
    NSData *data = [standardDefaults objectForKey:@"parseMessages1"];
    NSArray *retrievedArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    
    
    
    
    
    
    NSData *data2 = [standardDefaults objectForKey:@"parseMessages2"];
    NSArray *retrievedArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
    
   

        
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
            
            
            
            
        } else {
            
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
            
            
            
            
        } else {
            
        }

        
        [cell.detailTextLabel setText:@""];
        
        [cell.contentView addSubview:openMessageButton2];
        
    }
    
    
    
    
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
    

    
    
        UITableViewCell *cell = [[UITableViewCell alloc]init];
        
        cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
        self.selectedMessage = [self.messages2and3 objectAtIndex:indexPath.row];
       
        [self performSegueWithIdentifier:@"segueToFinishedHalfsieVC" sender:self];
        
    
    }

    

- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    
    // This is our actual implmenetation body code which starts with an if statement. This says "If our segue identifier is equal to signupYoVerificationSegue then do this...
    
    if ([segue.identifier isEqualToString:@"segueToMediaCaptureVCResponse"]) {
        
        
        MediaCaptureVCResponse *topHalf = segue.destinationViewController;
        
        
        topHalf.message = _selectedMessage;
        
        
        
    } else if ([segue.identifier isEqualToString:@"segueToFinishedHalfsieVC"]) {
        
        

        
        FinishedHalfsieVC *finished = segue.destinationViewController;
        
        finished.messagePassedFromInbox = _selectedMessage;
        
        
    } else if ([segue.identifier isEqualToString:@"inboxToMediaCaptureVC"]) {
        
        

        
        
        
        
        
    }
    
    
    
    
}






-(void)parseQueries {
    
    
    self.messages = [[NSArray alloc]init];
    
    self.messages2and3 = [[NSArray alloc]init];
    
    
    
    
    
    
    
    PFQuery *query = [PFQuery queryWithClassName:@"Messages"];
    
    
    [query whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
    [query whereKey:@"halfOrFull" equalTo:@"half"];
    [query whereKey:@"didRespond" notEqualTo:[[PFUser currentUser]objectId]];
    [query orderByDescending:@"createdAt"];
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        NSLog(@"5");
        
        
        if(error) {
            
            
            
        } else {
            
            
            //We found messages
            
            self.messages = objects;
            
        
            
            PFQuery *query2 = [PFQuery queryWithClassName:@"Messages"];
            
            [query2 whereKey:@"senderId" equalTo:[[PFUser currentUser]objectId]];
            [query2 whereKey:@"halfOrFull" equalTo:@"full"];
            
            
            
            PFQuery *query3 = [PFQuery queryWithClassName:@"Messages"];
            
            [query3 whereKey:@"recipientIds" equalTo:[[PFUser currentUser]objectId]];
            [query3 whereKey:@"halfOrFull" equalTo:@"full"];
            
            
            
            
            PFQuery *query2and3 = [PFQuery orQueryWithSubqueries:[NSArray arrayWithObjects:query2,query3,nil]];
            [query2and3 orderByDescending:@"createdAt"];
            
            [query2and3 findObjectsInBackgroundWithBlock:^(NSArray *objects2and3, NSError *error) {
                
                if(error) {
                    
                    
                    
                } else {
                    
                    
                    
                    self.messages2and3 = objects2and3;
                    
                            [self.tableView reloadData];
                            
                    
                            
                    
                            
                            
                            //Create an instance of NSUserDefaults
                            
                            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                            
                    
                            
                            if (self.messages.count != 0) {
                                
                                
                                
                                [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.messages] forKey:@"parseMessages1"];
                                
                                
                                
                            }
                    
                            
                            
                            if (self.messages2and3.count != 0) {
                                
                                
                                
                                [standardDefaults setObject:[NSKeyedArchiver archivedDataWithRootObject:self.messages2and3] forKey:@"parseMessages2"];
                                
                            }
                            
                            
                            //Save the changes you just made to the user defaults.
                            
                            [standardDefaults synchronize];
                            
                            
                            
                            
                            
                            
                            NSData *data = [standardDefaults objectForKey:@"parseMessages1"];
                            NSArray *retrievedArray1 = [NSKeyedUnarchiver unarchiveObjectWithData:data];
                    
                            NSData *data2 = [standardDefaults objectForKey:@"parseMessages2"];
                            NSArray *retrievedArray2 = [NSKeyedUnarchiver unarchiveObjectWithData:data2];
                    
                    
                }
            }];

    

        }
        
        
    }];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.cell = [[UITableViewCell alloc]init];
    
}

-(IBAction)logOut {
    
    
    [self.settingsBackground setHidden:NO];
    [self.findFriendsButton setHidden:NO];
    [self.inviteFriendsButton setHidden:NO];
    [self.backButton setHidden:NO];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
 }

-(IBAction)openMediaCaptureVC {
    
    
    
    [self performSegueWithIdentifier:@"inboxToMediaCaptureVC" sender:self];
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
