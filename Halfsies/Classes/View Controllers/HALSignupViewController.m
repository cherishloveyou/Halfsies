#import "HALSignupViewController.h"
#import <Parse/Parse.h>
#import "HALUserDefaults.h"
#import "HALParseConnection.h"

@interface HALSignupViewController () <UITextFieldDelegate, UIAlertViewDelegate>

#pragma mark - Properties
@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (nonatomic) UITextField * activeField;
@property (strong, nonatomic) NSString *userSubmittedUsername;
@property (strong, nonatomic) NSString *lowercaseUsername;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *userSubmittedPassword;
@property (strong, nonatomic) NSString *userSubmittedEmail;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;
@property (nonatomic) HALParseConnection *parseConnection;

#pragma mark - IBActions
- (IBAction)didTapSignup:(id)sender;

@end

@implementation HALSignupViewController

#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self navigationSetup];
    
    [self addNotificationObservers];
    
    self.backgroundImage.image = [UIImage imageNamed:@"launchBackgroundSignup"];

    [self.emailEntry becomeFirstResponder];
}

#pragma mark - Navigation Setup
- (void)navigationSetup
{
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
}

#pragma mark - Notification Observers
- (void)addNotificationObservers
{
    // Add self as observer for both successful signup and unsuccessful signup
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(saveLowercaseUsername)
                                                 name:@"successfulUserSignup"
                                               object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(genericSignupAlert)
                                                 name:@"unsuccessfulUserSignup"
                                               object:nil];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(successfulSignupSegue) name:@"lowercaseUsernameSaved" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(signUpNewUser) name:@"usernameIsAvailable" object:nil];
    
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(usernameNotAvailableAlertView) name:@"usernameIsNotAvailable" object:nil];
}

- (void)signUpNewUser
{
    // Call signup user method
    self.parseConnection = [HALParseConnection sharedHALParseConnection];
    [self.parseConnection signupNewUserWithUsername:self.userSubmittedUsername password:self.userSubmittedPassword email:self.userSubmittedEmail];
}

- (void)saveLowercaseUsername
{
  
    PFUser *currentUser = [PFUser currentUser];
    [currentUser setObject:self.lowercaseUsername forKey:@"lowercaseUsername"];
    [currentUser saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
        if (error) {
            NSLog(@"There was an error trying to set the user's lowercaseUsername key");
        } else if (succeeded == 1) {
            NSLog(@"The user's lowercaseUsername key was successfully set.");
            
            [[NSNotificationCenter defaultCenter]postNotificationName:@"lowercaseUsernameSaved" object:self];
        }
    }];
}

#pragma mark - Text Field Methods
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
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


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
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

#pragma mark - Alert View Methods
- (void) alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex == 0) {
        
        [self.emailEntry becomeFirstResponder];
    }
}

- (void)invalidSignupAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Username and Password must both be at least 4 characters long." delegate:self cancelButtonTitle:@"Okay" otherButtonTitles:nil];
    [alert show];
}

- (void)invalidEmailAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Invalid Entry" message:@"Please enter your email address." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)signupErrorAlert:(NSString *)errorDetails
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:errorDetails delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)genericSignupAlert
{
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"There was an error when trying to signup. Please try again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [alert show];
}

- (void)usernameNotAvailableAlertView
{
    UIAlertView *usernameNotAvailableAlertView = [[UIAlertView alloc]initWithTitle:@"Username Taken" message:@"That username has already been taken. Please choose a new one" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
    [usernameNotAvailableAlertView show];
}

#pragma mark - IBAction Methods
- (IBAction)didTapSignup:(id)sender
{
    self.userSubmittedUsername = [self.usernameEntry text];
    self.userSubmittedPassword = [self.passwordEntry text];
    self.userSubmittedEmail = [self.emailEntry text];
    
    if ([self.userSubmittedUsername length] < 3 || [self.userSubmittedPassword length] < 4) {
        
        [self invalidSignupAlert];
        
    } else if ([self.userSubmittedEmail length] < 8) {
        
        [self invalidEmailAlert];
        
    } else {
        
        self.lowercaseUsername = [self.userSubmittedUsername lowercaseString];
        
        // Make sure it passes the lowercaseUsername test
        self.parseConnection = [HALParseConnection sharedHALParseConnection];
        [self.parseConnection isUsernameAvailable:self.lowercaseUsername];
        
    }
}

- (IBAction)handleBack:(id)sender
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - Segue Methods
- (void)successfulSignupSegue
{
    [self performSegueWithIdentifier:@"signupToAddFriendsSegue" sender:self];
}

#pragma mark - Dealloc Override
- (void)dealloc
{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

@end
