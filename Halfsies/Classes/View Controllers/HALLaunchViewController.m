//
//  LaunchViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "HALLaunchViewController.h"

@interface HALLaunchViewController ()

#pragma mark - Properties
@property (strong, nonatomic) IBOutlet UIImageView *launchBackground;
@property (strong, nonatomic) IBOutlet UIBarButtonItem *backBarButton;

#pragma mark - IBActions
- (IBAction)login;
- (IBAction)signup;
- (IBAction)termsOfService;

@end

@implementation HALLaunchViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.launchBackground.image = [UIImage imageNamed:@"launchBackground"];
    [self.navigationController setNavigationBarHidden:YES];   //it hides
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [self.navigationController setNavigationBarHidden:NO];    // it shows
}

#pragma mark - IBAction Methods
- (IBAction)login
{
    [self performSegueWithIdentifier:@"launchToLoginSegue" sender:self];
}

- (IBAction)signup
{
    [self performSegueWithIdentifier:@"launchToSignupSegue" sender:self];
}

- (IBAction)termsOfService
{
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:@"http://www.halfsies.co/terms"]];
}

@end
