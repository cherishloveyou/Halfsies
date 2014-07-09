//
//  FinalFindFriendsViewController.m
//  Halfsies
//
//  Created by Mitchell Porter on 5/26/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALFinalFindFriendsViewController.h"

@interface HALFinalFindFriendsViewController ()

#pragma mark - Instance Methods
- (IBAction)cancelButton;
- (IBAction)inviteFriends;
- (IBAction)addFriends;

@end

@implementation HALFinalFindFriendsViewController

#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}

#pragma mark - IBAction Implementations
- (IBAction)cancelButton
{
    [self performSegueWithIdentifier:@"finalFriendsToMediaCapture" sender:self];
}

- (IBAction)inviteFriends
{
    [self performSegueWithIdentifier:@"finalFriendsToFindFriends" sender:self];
}

- (IBAction)addFriends
{
    [self.navigationController setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"finalFriendsToSearch" sender:self];
}

@end
