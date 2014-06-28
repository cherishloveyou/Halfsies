//
//  FinishedHalfsieVC.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/6/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "FinishedHalfsieVC.h"
#import <Social/Social.h>
#import<Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"
#import "InboxViewController.h"
#import <Parse/Parse.h>

@interface FinishedHalfsieVC () <UIActionSheetDelegate, UIAlertViewDelegate>

@property (strong, nonatomic) NSString *senderName;
@property (strong, nonatomic) PFUser *currentUser;
@property (strong, nonatomic) NSString *recipientId;
@property (strong, nonatomic) NSString *originalSender;
@property (strong, nonatomic) NSString *twitterStatus;

@end

@implementation FinishedHalfsieVC

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
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }

    
    self.senderName = [self.messagePassedFromInbox objectForKey:@"senderName"];
    self.recipientId = [self.messagePassedFromInbox objectForKey:@"recipientIds"];
    self.originalSender = [self.messagePassedFromInbox objectForKey:@"originalSender"];

    self.currentUser = [PFUser currentUser];

    
    PFFile *imageFile = [self.messagePassedFromInbox objectForKey:@"file"];
    
    self.imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    
    self.imageData = [NSData dataWithContentsOfURL:self.imageFileURL];
    
    
    
    if([UIScreen mainScreen].bounds.size.height == 568) {
        
        
    
    self.image = [[UIImage alloc]initWithData:self.imageData];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];

    imageView.frame = CGRectMake(0, 0, 320, 568);
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
        
    } else {
    
   

    self.image = [[UIImage alloc]initWithData:self.imageData];


    UIImageView *imageView2 = [[UIImageView alloc]initWithImage:self.image];
   
    
    imageView2.frame = CGRectMake(0, -30, 320, 568);
    
    [self.view addSubview:imageView2];
    [self.view sendSubviewToBack:imageView2];
        
    }
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}





- (BOOL)prefersStatusBarHidden
{
    return YES;
}




#pragma mark Share Button Methods


-(IBAction)shareButton {
    
    
    
    self.shareButtonForActionSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Twitter", @"Save to Library" ,@"Copy Share Link", @"Report User", nil];
    
    
    [self.shareButtonForActionSheet showInView:self.view];
    
    

    
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    
    
    
    if (buttonIndex == 0)
        
    {
        
        
        
        //Twitter code from Techtopia
        
        ACAccountStore *account = [[ACAccountStore alloc] init];
        ACAccountType *accountType = [account accountTypeWithAccountTypeIdentifier:
                                      ACAccountTypeIdentifierTwitter];
        
        [account requestAccessToAccountsWithType:accountType
                                         options:nil
                                      completion:^(BOOL granted, NSError *error)
         {
             
             
             if(error) {
                 
                 NSLog(@"There has been an error: %@", error);
                 
             }
             
             
             if(granted == NO) {
                 
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies needs permission to share to your twitter account. Please go to Settings > Privacy > Twitter and enable Halfsies." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     [alertView show];
                     
                 });
                 
                 
             }
             
             
             
             
             if (granted == YES)
             {
                 // Get account and communicate with Twitter API
                 
                 
                 //Now that access has been granted, we need to place the Twitter account in an object.
                 
                 
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount =
                     [arrayOfAccounts lastObject];
                     
                     
                     
                     if([self.currentUser.username isEqualToString:self.senderName]) {
                         
                         
                         self.twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies get.halfsies.co", self.originalSender];
                         
                         
                     }
                     
                     if(![self.currentUser.username isEqualToString:self.senderName]) {
                         
                         
                         
                         self.twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies get.halfsies.co", self.senderName];
                         
                     }
                     
                     NSDictionary *message = @{ @"status": self.twitterStatus};
                     
                     
                     NSURL *requestURL = [NSURL
                                          URLWithString:@"https://api.twitter.com"
                                          @"/1.1/statuses/update_with_media.json"];
                     
                     SLRequest *postRequest = [SLRequest
                                               requestForServiceType:SLServiceTypeTwitter
                                               requestMethod:SLRequestMethodPOST
                                               URL:requestURL parameters:message];
                     
                     postRequest.account = twitterAccount;
                     
                     
                     
                     [postRequest addMultipartData:self.imageData
                                          withName:@"media[]"
                                              type:@"image/jpeg"
                                          filename:@"image.jpg"];
                     
                     [postRequest setAccount:postRequest.account];
                     
                     
                     //Finally, we assign the object and post the request to the Twitter API.
                     
                     
                     
                     [postRequest
                      performRequestWithHandler:^(NSData *responseData,
                                                  NSHTTPURLResponse *urlResponse, NSError *error)
                      {
                          NSLog(@"Twitter HTTP response: %i",
                                [urlResponse statusCode]);
                          
                          if(error) {
                              
                              NSLog(@"There was an error when trying to post to Twitter.");
                              
                          }
                          
                          
                      }];
                     
                     
                     
                     
                     
                     
                     
                 }
                 
                 
                 
                 
             }
             
             
             
         }];
        
        
        

        
        
        
    }
    
    
    
    
    if(buttonIndex == 1) {
        
        
        
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusRestricted || [ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusDenied) {
            
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies does not currently have permission to save photos to your library. Please go to Settings > Privacy > Photos and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            
            [alertView show];
            
            
        }
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusNotDetermined) {
            
            
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            
            
            
            [library writeImageToSavedPhotosAlbum:self.image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                
                
                if(error) {
                    
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies does not currently have permission to save photos to your library. Please go to Settings > Privacy > Photos and tap the button next to Halfsies." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    
                    [alertView show];
                    
                    
                    
                } else {
                    
                    NSLog(@"No errors");
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }];
            
            

            
            
            
            
            
        }
        
        
        
        if([ALAssetsLibrary authorizationStatus] == ALAuthorizationStatusAuthorized) {
            
            
            ALAssetsLibrary *library = [[ALAssetsLibrary alloc]init];
            
            

            [library writeImageToSavedPhotosAlbum:self.image.CGImage orientation:ALAssetOrientationUp completionBlock:^(NSURL *assetURL, NSError *error) {
                
                
                if(error) {
                    
                    NSString *errorString = [[NSString alloc]initWithFormat:@"%@", error];
                    
                    UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:errorString delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                    
                    
                    [alertView show];
                    
                    
                    
                } else {
                    
                    NSLog(@"No errors");
                    
                    
                    
                    
                    
                    
                    
                }
                
                
                
                
                
                
            }];
            
            
            
            
            
        }
        
        
        
        
    }
    
    
    
    if(buttonIndex == 2) {
        
        
       
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        
        pasteboard.URL = self.imageFileURL;
        

        
        
    }
    
    
    if(buttonIndex == 3) {
        
        
        
       UIAlertView *reportAlertView = [[UIAlertView alloc]initWithTitle:@"Report User" message:@"By tapping the OK button, you will be reporting this user and the content they sent you as inappropriate." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        
        [reportAlertView show];

        
        
    }
    
    
    
    
    
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(buttonIndex == 1) {
        
        
        
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    
    
}



- (void)actionSheetCancel:(UIActionSheet *)actionSheet

{
    
    
}

- (void)postPhotosToFacebook:(UIImage *)photo withAlbumID:(NSString *)albumID {
    
    FBRequest *imageUploadRequest = [FBRequest requestForUploadPhoto:photo];
    
    [[imageUploadRequest parameters] setValue:albumID
                                       forKey:@"album"];
    
    NSLog(@"imageUploadRequest parameters: %@",[imageUploadRequest parameters]);
    
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:imageUploadRequest
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSLog(@"Photo uploaded successfuly! %@",result);
                 
                 
                 
             } else {
                 
                 NSLog(@"Photo uploaded failed :( %@",error.userInfo);
             }
             
         }];
    
    [connection start];
    
}



-(IBAction)backButton {
    
    
    InboxViewController *ivc;
    
    
    [self.navigationController pushViewController:ivc animated:YES];
    
    
    
    
    
    
}



@end
