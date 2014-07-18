//
//  SendToFriendsViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/28/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALSendToFriendsViewController.h"
#import <Parse/Parse.h>
#include <stdlib.h>
#include "HALMediaCaptureVC.h"
#import "HALParseConnection.h"

@interface HALSendToFriendsViewController () <UITableViewDataSource, UITableViewDelegate,UIAlertViewDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *friends;
@property (nonatomic, strong) NSMutableArray *recipients;
@property (nonatomic, strong) UIAlertView *alertView1;
@property (nonatomic, strong) UIAlertView *alertView2;

#pragma mark - Instance Methods
- (void)uploadPhoto;

#pragma mark - IBActions
- (IBAction)finishedChoosingUsersToGoHalfsiesWith;
- (IBAction)handleBack;

@end

@implementation HALSendToFriendsViewController

#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Setup navigation and query parse for friends list
    [self navigationSetup];
    [self parseConnectionQuery];
}

#pragma mark - HALParseConnection Queries
- (void)parseConnectionQuery
{
    // Register for the notification
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseQueryFailed:) name:@"performFriendsRelationForCurrentUserQueryFailed" object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(parseQuerySucceeded:) name:@"performFriendsRelationForCurrentUserQuerySucceeded" object:nil];
    
    [HALParseConnection performFriendsRelationForCurrentUserQuery];
}

- (void)parseQueryFailed:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    NSError *error = userInfo[@"error"];
    NSLog(@"There was an error: %@", error);
}

- (void)parseQuerySucceeded:(NSNotification *)aNotification
{
    NSDictionary *userInfo = aNotification.userInfo;
    self.friends = userInfo[@"succeeded"];
    
    [self.tableView reloadData];
}

#pragma mark - Navigation Setup
- (void)navigationSetup
{
    [self.navigationItem setHidesBackButton:YES];
    
    UIImage* firstButtonImage = [UIImage imageNamed:@"sendbutton"];
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    
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
}

#pragma mark - Table View Methods
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1 ;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
        return [self.friends count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
        return @"Friends Using Halfsies";
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
        static NSString *cellIdentifier = @"SettingsCell";
    
        UITableViewCell  *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];

        PFUser *user = [self.friends objectAtIndex:indexPath.row];
    
        UIImage *sendToUserButtonImage = [UIImage imageNamed:@"sendmessagebutton"];
        UIImage *sendToUserButtonImageHighlighted = [UIImage imageNamed:@"sendmessagebuttonselected"];
    
        UIButton *sendToUserButton = [[UIButton alloc]init];
        sendToUserButton.frame = CGRectMake(237, 7, 70, 30);
        
        [sendToUserButton setImage:sendToUserButtonImage forState:UIControlStateNormal];
        [sendToUserButton setImage:sendToUserButtonImageHighlighted forState:UIControlStateHighlighted];
        [sendToUserButton setImage:sendToUserButtonImageHighlighted forState:UIControlStateSelected];
        
        [sendToUserButton addTarget:self action:@selector(handleTouchUpInside:) forControlEvents:UIControlEventTouchUpInside];
    
        sendToUserButton.tag = indexPath.row;
    
        [cell.textLabel setText:user.username];
        [cell.detailTextLabel setText:@""];
        [cell.contentView addSubview:sendToUserButton];
        
    
    return cell;
}

#pragma mark - Touch Events
- (void)handleTouchUpInside:(UIButton *)sender
{
    sender.selected = !sender.selected;
    
    self.recipients = [[NSMutableArray alloc]init];

    
    UIButton *cellButton = (UIButton *)sender;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:cellButton.tag inSection:0];
    
    
    UITableViewCell *cell = [[UITableViewCell alloc]init];
    cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    //This takes all of the extra blank space out of the username before we place it inside the array
    cell.textLabel.text = [cell.textLabel.text stringByReplacingOccurrencesOfString:@"    " withString:@""];
    
    //This if statement helps to both add names into the "usersToAddToFriendsList" array and take them out.
    if(sender.state == 5) {
        
        //This add's the username to the array.
        PFUser *user = [self.friends objectAtIndex:indexPath.row];
        
        [self.recipients addObject:user.objectId];
        
    } else {
        
        //This removes the username from the array.
        PFUser *user = [self.friends objectAtIndex:indexPath.row];

        [self.recipients removeObject:user.objectId];
    }
}

#pragma mark - String Methods
- (NSString*)stringBetweenString:(NSString*)start andString:(NSString *)end withstring:(NSString*)str
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

#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if(alertView == self.alertView1 && buttonIndex == 0) {
    
    self.alertView2 = [[UIAlertView alloc]initWithTitle:@"So let's add some friends!" message:@"You can search for your friends who already use Halfsies by their username, or you can send a text message invite to friends from your address book. Tap OK to add some friends!" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    
    [self.alertView2 show];
    
    } else if (alertView == self.alertView2 && buttonIndex == 0) {
        
        // Segue to FinalFindFriends
        [self performSegueWithIdentifier:@"segueToFinalFindFriends" sender:self];
    }
}

#pragma mark - Photo Upload Method
- (void)uploadPhoto
{
    NSString *fileType;
    NSString *halfOrFull;

    if (self.halfsiesPhotoToSend != nil) {
        
        fileType = @"image";
        halfOrFull = @"half";
        
      NSData *imageData = UIImageJPEGRepresentation(self.halfsiesPhotoToSend, 0.7);
      PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
      [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
          
          if (error) {
        
              UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
              
              [alertView show];
              
          } else {
              
              PFObject *message = [PFObject objectWithClassName:@"Messages"];
              [message setObject:imageFile forKey:@"file"];
              [message setObject:fileType forKey:@"fileType"];
              [message setObject:self.recipients forKey:@"recipientIds"];
              [message setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
              [message setObject:[[PFUser currentUser]username]forKey:@"senderName"];
              [message setObject:halfOrFull forKey:@"halfOrFull"];
              
              [message saveInBackgroundWithBlock:^(BOOL succeeded2, NSError *error) {
                  
                  if(error) {
                    
                      UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                      
                      [alertView show];
                      
                  } else {
                     
                      if(succeeded == 1 && succeeded2 == 1) {
                          
                          [self performSegueWithIdentifier:@"segueToInboxViewController" sender:self];
                      }
                  }
              
              }];
          }
          
      }];
        
    }
}

#pragma mark - Segue Methods
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    if ([segue.identifier isEqualToString:@"backToMediaCaptureVC"]) {

    }
}

#pragma mark - IBAction Methods
- (IBAction)finishedChoosingUsersToGoHalfsiesWith
{
    if(self.recipients.count == 0) {
        
        self.alertView1 = [[UIAlertView alloc]initWithTitle:@"You need friends!" message:@"With Halfsies, you take one half of the photo, and then send it to your friend. Your friend takes the second half of the photo, and then you both get the final image." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
        
        [self.alertView1 show];
        
    } else if (self.recipients.count > 0) {
        
        [self uploadPhoto];
        
    }
}

- (IBAction)handleBack
{
    [self performSegueWithIdentifier:@"backToMediaCaptureVC" sender:self];
}

#pragma mark - Dealloc Override
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}


@end
     
