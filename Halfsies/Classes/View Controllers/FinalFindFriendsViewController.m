//
//  FinalFindFriendsViewController.m
//  Halfsies
//
//  Created by Mitchell Porter on 5/26/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "FinalFindFriendsViewController.h"

@interface FinalFindFriendsViewController ()

@end

@implementation FinalFindFriendsViewController

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
}


-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:NO];
    [self.navigationController setNavigationBarHidden:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
}


- (IBAction)cancelButton {
    [self performSegueWithIdentifier:@"finalFriendsToMediaCapture" sender:self];
}

- (IBAction)inviteFriends {
    [self performSegueWithIdentifier:@"finalFriendsToFindFriends" sender:self];
}

- (IBAction)addFriends {
    [self.navigationController setNavigationBarHidden:NO];
    [self performSegueWithIdentifier:@"finalFriendsToSearch" sender:self];
}

@end
