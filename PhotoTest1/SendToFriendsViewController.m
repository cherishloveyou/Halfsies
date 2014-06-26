//
//  SendToFriendsViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/28/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "SendToFriendsViewController.h"
#import <Parse/Parse.h>
#include <stdlib.h>
#include "MediaCaptureVC.h"


@interface SendToFriendsViewController ()

//You still need to connect this outlet to the table view on the storyboard.

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (strong, nonatomic) NSArray *finalParseStrings;

-(void)uploadPhoto;


@end

@implementation SendToFriendsViewController

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
    
    [self.navigationItem setHidesBackButton:YES];
    
    
    
    
    UIImage* firstButtonImage = [UIImage imageNamed:@"sendbutton"];
    
    NSLog(@"size of image: %@", NSStringFromCGSize(firstButtonImage.size));
    
    
    
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    //I think 30 is a good height. Now just increase the width.
    //70x370 seems to be the perfect size right now.
    
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(finishedChoosingUsersToGoHalfsiesWith)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navigationItem.rightBarButtonItem = rightBarButton;

    
    
    
    
    
    CGRect frame2 = CGRectMake(0, 0, 25, 25);

    
    UIImage *leftButtonImage = [UIImage imageNamed:@"backarrow2"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frame2];
    
    [leftButton addTarget:self action:@selector(handleBack) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];

    
    
    
    
    
    
    //- Hide the navigation controllers back bar button item.
    //- Add the “back arrow” image as the left bar button item for the send to friend vc’s navigation bar.
        //- Add a “send” button as the navigation controller’s right bar button item.
        //A. Design the “Send” button in photoshop. (Just use the “next” button template).

    
    
    //Check to see if the captured photo is being passed from the previous VC correctly.
    
    self.friendsRelation = [[PFUser currentUser]objectForKey:@"friendsRelation"];
    PFQuery *query = [self.friendsRelation query];
    [query orderByAscending:@"username"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        
        if(error) {
            
            NSLog(@"%@ %@", error, [error userInfo]);
        
        } else {
            
            self.friends = objects;
            
            [self.tableView reloadData];
        }
        
    }];
    
    
    NSLog(@"Was the halfsies photo received? %@", _halfsiesPhotoToSend);
    
    //[_halfsiesPhotoToSend]
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    self.cell = [[UITableViewCell alloc]init];
    
    self.sendToUserButton = [[UIButton alloc]init];
    
    self.finalUsersToGoHalfsiesWith = [[NSMutableArray alloc]init];
    
    self.recipients = [[NSMutableArray alloc]init];

    
    self.finalParseStrings = [[NSArray alloc]init];

    
    PFUser *currentUser = [PFUser currentUser];
    
    NSString *string = [NSString stringWithFormat:@"%@", currentUser];
    
    NSString *cURL=[self stringBetweenString:@"username = " andString:@";" withstring:string];
    
    
    //Creates a PFquery object called "query" and query's with a class name of @"_User" which basically represents the master class for our entire Parse DB.
    
    //PFQuery *query = [PFQuery queryWithClassName:@"_User"];
    
    //We then tell Parse, "Hey, now that we're accessing everything in the _User class, lets narrow it down to the username key(keys are columns in the Parse DB), and we only want to use the username key substring that is equal to whatever value is contained in our cURL object.
    
    //We basically tell it to look in the username column, but only pull data for one single specific username.
    
    //[qyery sel]
    
    //[query whereKey:@"username" equalTo:cURL];
    
    
    
    //We then further narrow our results. We create an array object called pfarray and initialize with our "object" key/column we want to pull data from which is "friends"
    
    //NSArray *pfarray = [[NSArray alloc]initWithObjects:@"friends", nil];
    
    //[query selectKeys:pfarray];
    
    
    //NSLog(@"YOUR NEW CUSTOM PFQUERY RESULTS: %@",[query getObjectWithId:@"friends"]);
    
    
    
    //NSArray *pfarray = [[NSArray alloc]initWithObjects:@"friends", nil];
    
    //[query selectKeys:pfarray];
   /* [query findObjectsInBackgroundWithBlock:^(NSArray *objects, NSError *error) {
        if (!error) {
    
    //Now that we have performed all of our queries, the data is basically floating around for us to use in the background.
            
            //NSArray *pfobjects = [[NSArray alloc]init];
    
            NSLog(@"Here are the objects that are being returned: %@", objects.description);
            
            NSLog(@"%@", objects);
            
            NSLog(@"Here are the objects that are being returned: %d", objects.count);

            
           
            //We create an NSString object called parseString with the "objects" data from Parse.
           
            NSString *parseString = [[NSString alloc]initWithFormat:@"%@", objects];
            
            NSLog(@"INIT WITH FORMAT WORK?: %@", parseString);
            
            //We create a new string object cURL with parseString and get rid of some junk.
            
            NSString *cURL=[self stringBetweenString:@"=" andString:@")" withstring:parseString];
            
            NSLog(@"new string : %@", cURL);
            
            //We run 3 statements for various string replacements.
            
            NSString *newString = [cURL stringByReplacingOccurrencesOfString:@" " withString:@""];
            
            NSString *newString2 = [newString stringByReplacingOccurrencesOfString:@"(" withString:@""];
            
            NSString *newString3 = [newString2 stringByReplacingOccurrencesOfString:@"\\n" withString:@""];

            
            NSLog(@"FINAL STRING LOOKS LIKE: %@", newString3);
            
            
            
            //We create an array finalParseStrings and finally separate our strings using the comma.
            
            self.finalParseStrings = [newString3 componentsSeparatedByString:@","];
            
            
            NSLog(@"ARRAY LOOKS LIKE: %@", self.finalParseStrings);
            NSLog(@"ARRAY COUNT: %d", self.finalParseStrings.count);

            //Now we create a for loop that will pull the individual strings/usernames out of our finalParseStrings array.
            
            int index;
            
            for(index = 0; index < _finalParseStrings.count; index++) {
                
                NSString *string = [[NSString alloc]init];
                
                //The individual strings pulled out of the array are placed in "string".
                
                string = _finalParseStrings[index];
                
                NSLog(@"all good string count1: %d", _finalParseStrings.count);

            }

            NSLog(@"all good string count2: %d", _finalParseStrings.count);

            [self.tableView reloadData];
        } }
     
    
    
    
    
    
    
     ];}

    */
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
    NSLog(@"all good string count3: %d", self.friends.count);

}


- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1 ;
    

    NSLog(@"all good string count4: %d", self.friends.count);

}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"self.friends count: %d", [self.friends count]);

        
        
        return [self.friends count];
    
    
    
    
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    NSLog(@"all good 3");

    
        return @"Friends Using Halfsies";
    
    
}




-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"all good 4");

    
    static NSString *cellIdentifier = @"SettingsCell";
    
    
    
    UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

    
        //NSString *firstNameForTableView = [self.friends objectAtIndex:indexPath.row];
        PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
    
        NSLog(@"POTENTIAL FRIENDS IN PARSE $: %@", self.friends);
        
    
        
        
        UIImage *sendToUserButtonImage = [UIImage imageNamed:@"sendmessagebutton"];
    
        NSLog(@"IS BUTTON 1 WORKING: %@", sendToUserButtonImage);
    
        UIImage *sendToUserButtonImageHighlighted = [UIImage imageNamed:@"sendmessagebuttonselected"];
        
        NSLog(@"IS BUTTON 2 WORKING: %@", sendToUserButtonImageHighlighted);

    
        UIButton *sendToUserButton = [[UIButton alloc]init];
        
        sendToUserButton.frame = CGRectMake(237, 7, 70, 30);
        
        [sendToUserButton setImage:sendToUserButtonImage forState:UIControlStateNormal];
        [sendToUserButton setImage:sendToUserButtonImageHighlighted forState:UIControlStateHighlighted];
        [sendToUserButton setImage:sendToUserButtonImageHighlighted forState:UIControlStateSelected];
        
        [sendToUserButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
        
    
        NSLog(@"INDEX PATH ROW: %ld", (long)indexPath.row);
        NSLog(@"INDEX PATH SECTION: %ld", (long)indexPath.section);
        
        sendToUserButton.tag = indexPath.row;
        
        NSLog(@"THE USER BUTTON TAG IS: %ld", (long)_sendToUserButton.tag);
        
    
        
        [cell.textLabel setText:user.username];
        
        [cell.detailTextLabel setText:@""];
        
        [cell.contentView addSubview:sendToUserButton];
        
        
        NSLog(@"Has the state of the button changed? %u", _sendToUserButton.state);
        
    
    
    //[cell.textLabel setText:userName];

    return cell;
    
    
    
    
}

- (void)handleTouchUpInside:(UIButton *)sender {
    sender.selected = !sender.selected;
    
    
    UIButton *cellButton = (UIButton *)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:0];
    
    //UITableView *tableView = [[UITableView alloc]init];
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    
    cell = [_tableView cellForRowAtIndexPath:indexPath];
    
    //This takes all of the extra blank space out of the username before we place it inside the array.
    
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"    " withString:@""];
    
    //This if statement helps to both add names into the "usersToAddToFriendsList" array and take them out.
    
    if(sender.state == 5) {
        
        //This add's the username to the array.
        
        PFUser *user = [self.friends objectAtIndex:indexPath.row];
        
        [_recipients addObject:user.objectId];
        
        NSLog(@"CONTENTS OF ARRAY 1: %@", _recipients);
        
    } else {
        
        //This removes the username from the array.
        
        PFUser *user = [self.friends objectAtIndex:indexPath.row];

        [_recipients removeObject:user.objectId];
        
        NSLog(@"CONTENTS OF ARRAY 2: %@", _recipients);
        
    }
    
    
}

-(NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
{
    NSScanner* scanner = [NSScanner scannerWithString:str];
    [scanner setCharactersToBeSkipped:nil];
    [scanner scanUpToString:start intoString:NULL];
    if ([scanner scanString:start intoString:NULL]) {
        NSString* result = nil;
        if ([scanner scanUpToString:end intoString:&result]) {
            return result;
        }
    }
    return nil;
}




-(IBAction)finishedChoosingUsersToGoHalfsiesWith {
    
    
    if(self.recipients.count == 0) {
        
        
        NSLog(@"They don't have friends.");
        
        self.alertView1 = [[UIAlertView alloc]initWithTitle:@"You need friends!" message:@"With Halfsies, you take one half of the photo, and then send it to your friend. Your friend takes the second half of the photo, and then you both get the final image." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.alertView1 show];
        
        
        
        
    }
    
    if(self.recipients.count > 0) {
        
        
   NSLog(@"They do have friends.");
    
    [self uploadPhoto];
    
    NSLog(@"just pressed button");
    
    //NSData *imageData = UIImagePNGRepresentation(self.halfsiesPhotoToSend); // 0.7 is JPG quality
    
    //NSData *imageData = UIImageJPEGRepresentation(self.halfsiesPhotoToSend, 0.7);
    
        
    }
    
}




-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(alertView == self.alertView1 && buttonIndex == 0) {
    
    NSLog(@"Alert view dismissed.");
    
    
    self.alertView2 = [[UIAlertView alloc]initWithTitle:@"So let's add some friends!" message:@"You can search for your friends who already use Halfsies by their username, or you can send a text message invite to friends from your address book. Tap OK to add some friends!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    
    
    [self.alertView2 show];
    
    }
    
    
    if(alertView == self.alertView2 && buttonIndex == 0) {
        
        //Segue to FinalFindFriends
        
        
        [self performSegueWithIdentifier:@"segueToFinalFindFriends" sender:self];
        
        
        
        
        
    }
    
    
    
    
}



#pragma mark - Helper Methods


-(void)uploadPhoto {
    
    NSString *fileType;
    NSString *halfOrFull;

    
    if(self.halfsiesPhotoToSend != nil) {
        
        fileType = @"image";
        halfOrFull = @"half";
        
      NSData *imageData = UIImageJPEGRepresentation(self.halfsiesPhotoToSend, 0.7);
        
      PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
      NSLog(@"PFFile has been created: %@", imageFile);
        
      [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          
          if(error) {
              
              NSLog(@"There has been an error: %@ %@", error, [error userInfo]);
              
              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
              
              [alertView show];
              
          } else {
              
              NSLog(@"Step 1 successful.");
              
              PFObject *message = [PFObject objectWithClassName:@"Messages"];
              [message setObject:imageFile forKey:@"file"];
              [message setObject:fileType forKey:@"fileType"];
              [message setObject:self.recipients forKey:@"recipientIds"];
              [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
              [message setObject:[[PFUser currentUser]username]forKey:@"senderName"];
              [message setObject:halfOrFull forKey:@"halfOrFull"];
              
              [message saveInBackgroundWithBlock:^(BOOL succeeded2, NSError *error) {
                  
                  if(error) {
                      
                      NSLog(@"There was an error: %@ %@", error, [error userInfo]);
                      
                      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      
                      [alertView show];
                      
                  } else {
                      //Everything was successful.
                      NSLog(@"Step 2 successful.");
                      
                      if(succeeded == 1 && succeeded2 == 1) {
                          
                          
                          [self performSegueWithIdentifier:@"segueToInboxViewController" sender:self];
                          
                          
                      }
                      
                  }
              
              
              
              }];
          }
          
          
          
      }];
        
    }
    
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    
    
    if([segue.identifier isEqualToString:@"backToMediaCaptureVC"]) {
    
    MediaCaptureVC *mvc = segue.destinationViewController;
        
    
    }
    
    
    
    
    
}

-(IBAction)handleBack {
    
    
    
    [self performSegueWithIdentifier:@"backToMediaCaptureVC" sender:self];
    
    
    
    
}


@end
     
