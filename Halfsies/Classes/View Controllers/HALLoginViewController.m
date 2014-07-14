//
//  LoginViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "HALLoginViewController.h"
#import <Parse/Parse.h>

@interface HALLoginViewController () <UITextFieldDelegate, UIAlertViewDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (strong, nonatomic) IBOutlet UIImageView *loginBackgroundImageView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

#pragma mark - IBActions
- (IBAction)didTapLoginButton:(id)sender;

@end

@implementation HALLoginViewController

#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.loginBackgroundImageView.image = [UIImage imageNamed:@"launchBackgroundLogin"];
    
    [self navigationSetup];
    
    [self.usernameEntry becomeFirstResponder];

    // Retrieve stored username
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
    [self.usernameEntry setText:[standardDefaults objectForKey:@"username"]];
}

#pragma mark - Navigation Methods
- (void)navigationSetup
{
    
    // Setup the navigation bar and its elements
    UIImage* firstButtonImage = [UIImage imageNamed:@"loginbutton1"];
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(didTapLoginButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navItem.rightBarButtonItem = rightBarButton;

    CGRect frame2 = CGRectMake(0, 0, 25, 25);
   
    UIImage *leftButtonImage = [UIImage imageNamed:@"backarrow2"];
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frame2];
    
    [leftButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];
}

#pragma mark - Text Field Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if(textField.tag == 1) {
        
        [self.passwordEntry becomeFirstResponder];
        
    } else {
        
        [self.passwordEntry resignFirstResponder];
        [self didTapLoginButton:self];
    }
    return YES;
}

#pragma mark - Alert View Methods
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self.passwordEntry becomeFirstResponder];
    }
}

- (void)invalidLoginAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

- (void)loginFailedAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    
    [alert show];
}

#pragma mark - IBAction Methods
- (IBAction)didTapLoginButton:(id)sender
{
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    
    if ([user length] < 4 || [pass length] < 4) {
        
        [self invalidLoginAlert];
        
    } else {
        
        [PFUser logInWithUsernameInBackground:user password:pass block:^(PFUser *user, NSError *error) {
            if (user) {
                NSLog(@"Successful login");
                
                //[self performSegueWithIdentifier:@"loginToMainAppSegue" sender:self];
                [self performSegueWithIdentifier:@"loginToMediaCaptureVC" sender:self];
                
            } else {
                NSLog(@"%@",error);
                [self loginFailedAlert];
            }
        }];
    }
}

- (IBAction)handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

@end
