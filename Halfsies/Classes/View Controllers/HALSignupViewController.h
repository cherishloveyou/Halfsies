//
//  SignupViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALSignupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *emailEntry;
@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property UITextField * activeField;
@property (strong, nonatomic) NSString *uniqueVerificationCode;
@property (strong, nonatomic) NSString *userSubmittedUsername;
@property (strong, nonatomic) NSString *objectId;
@property (strong, nonatomic) NSString *userSubmittedPassword;
@property (strong, nonatomic) NSString *userSubmittedEmail;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;
@property (strong, nonatomic) IBOutlet UIScrollView *scrollView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UIImageView *backgroundImage;

- (IBAction)didTapSignup:(id)sender;

@end
