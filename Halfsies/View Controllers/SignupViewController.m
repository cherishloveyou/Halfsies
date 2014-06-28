#import "SignupViewController.h"
#import <Parse/Parse.h>

@interface SignupViewController () <UITextFieldDelegate>


@end

@implementation SignupViewController




- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    //self.backgroundImage.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.backgroundImage.image = [UIImage imageNamed:@"launchBackgroundSignup"];
    
    
    UIImage* firstButtonImage = [UIImage imageNamed:@"nextbutton3"];
    
    NSLog(@"size of image: %@", NSStringFromCGSize(firstButtonImage.size));
    
    
    
    
    
    
    
    
    
    CGRect frame = CGRectMake(0, 0, 70, 30);
    
    //I think 30 is a good height. Now just increase the width.
    
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

    
    
    
   /* UIImage* backButtonImage = [UIImage imageNamed:@"nextbutton2"];;
    
    NSLog(@"size of image: %@", NSStringFromCGSize(firstButtonImage.size));
    
    
    CGRect frame2 = CGRectMake(0, 0, 30, 30);
    
    //I think 30 is a good height. Now just increase the width.
    
    UIButton * someButton2 = [[UIButton alloc] initWithFrame:frame2];
    [someButton2 setBackgroundImage:backButtonImage forState:UIControlStateNormal];
    [someButton2 addTarget:self action:@selector(didTapSignup:)
         forControlEvents:UIControlEventTouchUpInside];
    
    self.backBarButton = [[UIBarButtonItem alloc] initWithCustomView:someButton2];
    
    self.navItem.backBarButtonItem = self.backBarButton;
    
    
    */
    
    [self.emailEntry becomeFirstResponder];
    
    
    //Here you are calling the registerForKeyboardNotifications method that you have implemented below.
    
    
    
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
        
        //[textField resignFirstResponder];
    }
    return YES;
}

// Below is our prepareForSegue code and I had to add this because it is needed whenever you want to pass data between View Controllers. This enables us to pass the 4 digit code generated in this VC(Signup), to the Verification View Controller.

// Implements the function prepareForSegue with the input of a UIStoryboardSegue object called segue.






- (IBAction)didTapSignup:(id)sender {
    
    NSString *user = [self.usernameEntry text];
    NSString *pass = [self.passwordEntry text];
    NSString *email = [self.emailEntry text];
    
    self.userSubmittedUsername = user;
    self.userSubmittedPassword = pass;
    self.userSubmittedEmail = email;
    
    
    NSLog(@"%@", user);
    NSLog(@"%@", pass);
    NSLog(@"%@", email);
    
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
                
                
                
                
                
                NSLog(@"No errors in signup process");
                
                NSLog(@"New user's objectId in Parse Database: %@", newUser.objectId);
                
                self.objectId = newUser.objectId;
                
                NSLog(@"New user's objectId placed inside this VC's objectId property object: %@", self.objectId);

                
                //This calls the performSegueWithIdentifier method and actually performs the segue to the Verification View Controller.
                
                if(succeeded == 1) {
                    
                    NSLog(@"Succeeded value right before segue: %d", succeeded);
                    
                    NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
                    
                    
                
                    
                    [standardDefaults setObject:user forKey:@"username"];
                    [standardDefaults synchronize];
                    
                    NSLog(@"NSLOG FOR THE NSUSERDEFAULT username: %@", [standardDefaults objectForKey:@"username"]);
                    
                    

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
