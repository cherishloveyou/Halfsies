#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController () <UITextFieldDelegate>


@end

@implementation SignupViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    
    self.backgroundImage.image = [UIImage imageNamed:@"launchBackgroundSignup"];
    
    
    UIImage* firstButtonImage = [UIImage imageNamed:@"nextbutton3"];
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    
    UIButton * someButton = [[UIButton alloc] initWithFrame:frame];
    [someButton setBackgroundImage:firstButtonImage forState:UIControlStateNormal];
    [someButton addTarget:self action:@selector(didTapSignup:)
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

    
    
    
    
    [self.emailEntry becomeFirstResponder];
    
    
    
    
    
    [self.usernameEntry setDelegate:self];
    [self.passwordEntry setDelegate:self];
    [self.emailEntry setDelegate:self];
    

}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    
    if (textField.tag == 1) {
        [self.usernameEntry becomeFirstResponder];
    } else if (textField.tag == 2) {
        [self.passwordEntry becomeFirstResponder];
        
    } else {
        
        [self.passwordEntry resignFirstResponder];
        
        [self didTapSignup:self];
        
    }
    return YES;
}


- (IBAction)didTapSignup:(id)sender {
    
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    NSString *email = [self.emailEntry text];
    
    self.userSubmittedUsername = user;
    self.userSubmittedPassword = pass;
    self.userSubmittedEmail = email;
    
  
    
    if ([user length] < 3 || [pass length] < 4) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else if ([email length] < 8) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
        [alert show];
    } else {
        
        
    
        
        PFUser *newUser = [PFUser user];
        newUser.username = user;
        newUser.password = pass;
        newUser.email = email;
        
      
        
        [newUser signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if (error) {
                NSString *errorString = [[error userInfo] objectForKey:@"error"];
                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                
            } else {
                
                
                
                
                
                self.objectId = newUser.objectId;
              
                
                if(succeeded == 1) {
                    
                    
                    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                    
                    
                
                    
                    [standardDefaults setObject:user forKey:@"username"];
                    [standardDefaults synchronize];
                   
                [self performSegueWithIdentifier:@"signupToAddFriendsSegue" sender:self];
                    
                
                }
                
                
                
                          }
        }];
        
        
        
    }
        
        
        
    
    
}


-(void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
   
    
    if (buttonIndex == 0) {
        
        [self.emailEntry becomeFirstResponder];
        
        
        
    }
    
    
    
}





-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
    if(textField == self.usernameEntry || textField == self.passwordEntry)
    {
        
        NSCharacterSet *myCharSet = [NSCharacterSet characterSetWithCharactersInString:@"0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz"];
        for (int i = 0; i < [string length]; i++)
        {
            unichar c = [string characterAtIndex:i];
            if (![myCharSet characterIsMember:c])
            {
                return NO;
            }
        }
        
        return YES;
    }
    
    return YES;
}


-(IBAction)handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}


@end
