//
//  SMSWindowViewController.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/28/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALSMSWindowViewController.h"
#import <MessageUI/MessageUI.h>

@interface HALSMSWindowViewController () <MFMessageComposeViewControllerDelegate>

@end

@implementation HALSMSWindowViewController

#pragma mark - View Methods
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    [self showSMS];
}

#pragma mark - SMS Methods
- (void)showSMS {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = self.usersToInviteToHalfsies;
    NSString *message = self.textMessageInviteText;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setSubject:@"New Message"];
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:NO completion:nil];
}

//This is the method implementation that handles someof the MFMessageComposeViewController's functionality.

#pragma mark - Delegate Methods
- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:NO completion:nil];
    [self performSegueWithIdentifier:@"smsWindowToMediaCaptureSegue" sender:self];
}

@end
