//
//  LoginViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "LoginViewController.h"
#import <Parse/Parse.h>

@interface LoginViewController () <UITextFieldDelegate>

@end

@implementation LoginViewController

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
    
    
    self.loginBackgroundImageView.image = [UIImage imageNamed:@"launchBackgroundLogin"];
    
    
    
    
    UIImage* firstButtonImage = [UIImage imageNamed:@"loginbutton1"];
    
    NSLog(@"size of image: %@", NSStringFromCGSize(firstButtonImage.size));
    
    
    
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    //I think 30 is a good height. Now just increase the width.
    //70x370 seems to be the perfect size right now.
    
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(didTapLoginButton:)
         forControlEvents:UIControlEventTouchUpInside];
    
    UIBarButtonItem *rightBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton];
    
    self.navItem.rightBarButtonItem = rightBarButton;

    
    
    //

    
    
    CGRect frame2 = CGRectMake(0, 0, 25, 25);
    
    
    
    UIImage *leftButtonImage = [UIImage imageNamed:@"backarrow2"];
    
    UIButton *leftButton = [[UIButton alloc] initWithFrame:frame2];
    
    [leftButton addTarget:self action:@selector(handleBack:) forControlEvents:UIControlEventTouchUpInside];
    
    [leftButton setImage:leftButtonImage forState:UIControlStateNormal];
    
    UIBarButtonItem *backButton = [[UIBarButtonItem alloc] initWithCustomView:leftButton];
    
    self.navigationItem.leftBarButtonItem = backButton;
    
    [self.navigationItem setHidesBackButton:YES animated:YES];
    [self.navigationItem setBackBarButtonItem:nil];

    
    
    
    
    
    [self.usernameEntry becomeFirstResponder];

    
    
    NSLog(@"after");
    
    [self.usernameEntry setDelegate:self];
    [self.passwordEntry setDelegate:self];
    
    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];

    
    [self.usernameEntry setText:[standardDefaults objectForKey:@"username"]];
    
    
     NSLog(@"NSLOG FOR THE NSUSERDEFAULT testing: %@", [standardDefaults objectForKey:@"testing"]);
    
        NSLog(@"NSLOG FOR THE NSUSERDEFAULT username: %@", [standardDefaults objectForKey:@"username"]);

    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(IBAction)didTapLoginButton:(id)sender {
    
    
    
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    
    if ([user length] < 4 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        [self.activityIndicator startAnimating];
        
        [PFUser logInWithUsernameInBackground:user password:pass block:^(PFUser *user, NSError *error) {
            [self.activityIndicator stopAnimating];
            if (user) {
                NSLog(@"Successful login");
                
                //[self performSegueWithIdentifier:@"loginToMainAppSegue" sender:self];
                [self performSegueWithIdentifier:@"loginToMediaCaptureVC" sender:self];

                
            } else {
                NSLog(@"%@",error);
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Login Failed." message:@"Invalid Username and/or Password." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
                
                [alert show];
                
                
                
            }
        }];
    }

    
    
}


-(BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    if(textField.tag == 1) {
        
        [self.passwordEntry becomeFirstResponder];
        
    } else {
        
        [self.passwordEntry resignFirstResponder];
        
        [self didTapLoginButton:self];
    }
    
    //[textField resignFirstResponder];
    
    return YES;
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    
    //u need to change 0 to other value(,1,2,3) if u have more buttons.then u can check which button was pressed.
    
    if (buttonIndex == 0) {
        
        [self.passwordEntry becomeFirstResponder];

        
        
    }
    
    
    
}


-(IBAction)handleBack:(id)sender
{
    //    [self dismissViewControllerAnimated:YES completion:nil];
    [self.navigationController popViewControllerAnimated:YES];
}



@end
