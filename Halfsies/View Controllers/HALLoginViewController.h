//
//  LoginViewController.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/28/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HALLoginViewController : UIViewController <UITextFieldDelegate, UIAlertViewDelegate>

@property (weak, nonatomic) IBOutlet UITextField *usernameEntry;
@property (weak, nonatomic) IBOutlet UITextField *passwordEntry;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (strong, nonatomic) IBOutlet UIImageView *loginBackgroundImageView;
@property (strong, nonatomic) IBOutlet UINavigationItem *navItem;
@property (strong, nonatomic) IBOutlet UINavigationBar *navBar;

- (IBAction)didTapLoginButton:(id)sender;

@end
