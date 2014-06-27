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
    
    //[self.navigationItem hidesBackButton];
    
    
    //self.finishedHalfsieImageView.frame = CGRectMake(0, 0, 320, 480);
    
    //NSLog(@"finishedHalfsieImageView frame: %@", NSStringFromCGRect(self.finishedHalfsieImageView.frame));
    
    
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

    NSLog(@"The sender name is: %@", self.senderName);
    NSLog(@"The original sender name is: %@", self.originalSender);
    
    PFFile *imageFile = [self.messagePassedFromInbox objectForKey:@"file"];
    
    self.imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    
    self.imageData = [NSData dataWithContentsOfURL:self.imageFileURL];
    
    //self.finishedHalfsieImageView.image = [UIImage imageWithData:self.imageData];
    
    
    if([UIScreen mainScreen].bounds.size.height == 568) {
        
    // This is the code for 4 inch phones. 160, 284, 320, 568.

        
    NSLog(@"Screen size is 4 inches.");
    
    
    self.image = [[UIImage alloc]initWithData:self.imageData];

    UIImageView *imageView = [[UIImageView alloc]initWithImage:self.image];

    imageView.frame = CGRectMake(0, 0, 320, 568);
    
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
        
    } else {
    
    // This is the code for 3.5 inch phones.
        
    NSLog(@"Screen size is 3.5 inches.");

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
        
        
        NSLog(@"Share on Twitter has been pressed.");
        
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
                 
                 NSLog(@"Granted is equal to NO");
                 
                 dispatch_async(dispatch_get_main_queue(), ^{
                     
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Halfsies needs permission to share to your twitter account. Please go to Settings > Privacy > Twitter and enable Halfsies." delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     [alertView show];
                     
                 });
                 
                 NSLog(@"Alert View should show now");
                 
             }
             
             
             
             
             if (granted == YES)
             {
                 // Get account and communicate with Twitter API
                 
                 NSLog(@"Twitter access has been granted!");
                 
                 //Now that access has been granted, we need to place the Twitter account in an object.
                 
                 
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount =
                     [arrayOfAccounts lastObject];
                     
                     
                     //This code below creates a new message to post to the user's Twitter feed.
                     
                     NSLog(@"self.senderName: %@", self.senderName);
                     NSLog(@"self.currentUser.username: %@", self.currentUser.username);
                     
                     
                     if([self.currentUser.username isEqualToString:self.senderName]) {
                         
                         NSLog(@"Current user's username is equal to the senderName key in Parse.");
                         
                         NSLog(@"The original sender name is: %@", self.originalSender);
                         
                         
                         self.twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies get.halfsies.co", self.originalSender];
                         
                         
                     }
                     
                     if(![self.currentUser.username isEqualToString:self.senderName]) {
                         
                         
                         NSLog(@"Current user's username is NOT equal to the senderName key in Parse.");
                         
                         
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
        
        
        

        
        
     /*   NSLog(@"Share on Facebook Has Been Pressed.");
        
        //We will now segue to the Share View Controller.
        //We'll also have to pass the correct info that the Share View Controller will need.
        
        NSLog(@"Session's permissions777: %@", FBSession.activeSession.permissions);

        
        // If the session state is any of the two "open" states when the button is clicked
        
        if (FBSession.activeSession.state == FBSessionStateOpen
            || FBSession.activeSession.state == FBSessionStateOpenTokenExtended) {
            
            // Close the session and remove the access token from the cache
            // The session state handler (in the app delegate) will be called automatically
            //[FBSession.activeSession closeAndClearTokenInformation];
            
            // If the session state is not any of the two "open" states when the button is clicked
            
            
            
            NSLog(@"fbsesion 1");
            
        } else {
            
            NSLog(@"fbsesion 2");
            
            // Open a session showing the user the login UI
            // You must ALWAYS ask for basic_info permissions when opening a session
            
            
            
            [FBSession openActiveSessionWithReadPermissions:@[@"basic_info"]
                                               allowLoginUI:YES
                                          completionHandler:
             ^(FBSession *session, FBSessionState state, NSError *error) {
                 
                 
                 if(error) {
                     
                     
                     NSLog(@"There was an error when opening the new active session with read permissions");
                     
                     NSLog(@"Here's the error: %@", error);
                     
                     UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong. Please try again and make sure Halfsies is enabled in Settings > Privacy > Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                     
                     [alertView show];
                     
                     
                 }
                 
                 NSLog(@"Active session has been opened!");
                 
                 NSLog(@"Session: %@", session);
                 
                 NSLog(@"Session state: %u", state);
                 
                 
                 // Retrieve the app delegate
                 AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
                 
                 // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
                 //[appDelegate sessionStateChanged:session state:state error:error];
                 
                 NSLog(@"Session's permissions1: %@", FBSession.activeSession.permissions);
                 
                 [FBSession setActiveSession:session];
                 
                 
                 
             }];
            
            
            
            
            
            
        }

        
      
        
        //NSLog(@"About to run the image staging code.");
        
        //You have commented out this code now that you have found another solution that is exactly like how Frontback shares to Facebook.
        
        //The below code should be used for complex "activity" sharing via open graph.
        
      /*
        // stage an image
        [FBRequestConnection startForUploadStagingResourceWithImage:self.finishedHalfsieImageView.image completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
            if(!error) {
                
                // Log the uri of the staged image
                NSLog(@"Successfuly staged image with staged URI: %@", [result objectForKey:@"uri"]);
                
                // Further code to post the OG story goes here
                
                
                // instantiate a Facebook Open Graph object
                NSMutableDictionary<FBOpenGraphObject> *object = [FBGraphObject openGraphObjectForPost];
                
                // specify that this Open Graph object will be posted to Facebook
                object.provisionedForPost = YES;
                
                // for og:title
                object[@"title"] = @"Going halfsies on photos with friends! #halfsies #halfsiesapp";
                
                // for og:type, this corresponds to the Namespace you've set for your app and the object type name
                
                object[@"type"] = @"phototestnamespace:halfsies";
                
                // for og:description
                //object[@"description"] = @"Crunchy pumpkin seeds roasted in butter and lightly salted.";
                
                // for og:url, we cover how this is used in the "Deep Linking" section below
                //object[@"url"] = @"http://example.com/roasted_pumpkin_seeds";
                
                // for og:image we assign the image that we just staged, using the uri we got as a response
                // the image has to be packed in a dictionary like this:
                object[@"image"] = @[@{@"url": [result objectForKey:@"uri"], @"user_generated" : @"false" }];
                
                
                // Post custom object
                [FBRequestConnection startForPostOpenGraphObject:object completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
                    if(!error) {
                        
                        // get the object ID for the Open Graph object that is now stored in the Object API
                        NSString *objectId = [result objectForKey:@"id"];
                        NSLog([NSString stringWithFormat:@"object id: %@", objectId]);
                        
                        // Further code to post the OG story goes here
                        
                        
                        // create an Open Graph action
                        id<FBOpenGraphAction> action = (id<FBOpenGraphAction>)[FBGraphObject graphObject];
                        [action setObject:objectId forKey:@"halfsies"];
                        
                        // create action referencing user owned object
                        [FBRequestConnection startForPostWithGraphPath:@"/me/phototestnamespace:finish" graphObject:action completionHandler:^(FBRequestConnection *connection, id  result, NSError *error) {
                            if(!error) {
                                NSLog([NSString stringWithFormat:@"OG story posted, story id: %@", [result objectForKey:@"id"]]);
                                [[[UIAlertView alloc] initWithTitle:@"Success!"
                                                            message:@"This halfsies photo was shared to your Facebook profile."
                                                           delegate:self
                                                  cancelButtonTitle:@"OK"
                                                  otherButtonTitles:nil] show];
                                
                                
                                
                                
                                

                                
                            } else {
                                // An error occurred
                                NSLog(@"Encountered an error posting to Open Graph: %@", error);
                            }
                        }];
                        
                        
                        
                        
                    } else {
                        // An error occurred
                        NSLog(@"Error posting the Open Graph object to the Object API: %@", error);
                    }
                }];
                
                
                
            } else {
                
                // An error occurred
                NSLog(@"Error staging an image: %@", error);
            }
        }];
        
        
        
        NSString *album = @"FrontStack";
        
        //NSArray *arrayz = [[NSArray alloc]initWithObjects:self.finishedHalfsieImageView.image, nil];
        
        UIImage *imageForFacebook = [[UIImage alloc]initWithData:self.imageData];

        [self postPhotosToFacebook:imageForFacebook withAlbumID:album];
        
       */
    
    }
    
    
    
    
    if(buttonIndex == 1) {
        
        
        NSLog(@"Save to Library has been pressed.");
        
        
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
        
        
        NSLog(@"Copy Share Link has been pressed.");
        
        //Copy imageFileURL to the user's clipboard.
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        NSLog(@"The image file URL before copying is: %@", self.imageFileURL);
        
        pasteboard.URL = self.imageFileURL;
        
        NSLog(@"The final pasteboard URL is: %@", pasteboard.URL);

        
        
    }
    
    
    if(buttonIndex == 3) {
        
        NSLog(@"Report user has been pressed.");
        
        
       UIAlertView *reportAlertView = [[UIAlertView alloc]initWithTitle:@"Report User" message:@"By tapping the OK button, you will be reporting this user and the content they sent you as inappropriate." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        
        [reportAlertView show];

        
        
    }
    
    
    
    
    
    
    
}



-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    if(buttonIndex == 1) {
        
        NSLog(@"OK button has been pressed.");
        
        
        //[self performSelector:@selector(backButton)];
        
        [self.navigationController popViewControllerAnimated:NO];
    }
    
    
    
    
}



- (void)actionSheetCancel:(UIActionSheet *)actionSheet

{
    
    NSLog(@"Canceled");
    
}

- (void)postPhotosToFacebook:(UIImage *)photo withAlbumID:(NSString *)albumID {
    
    // Just testing with one image for now; I'll get in to multiple later..
    //UIImage *image = [photos lastObject];
    
    FBRequest *imageUploadRequest = [FBRequest requestForUploadPhoto:photo];
    
    // CALL OUT: I'm guessing my problem is here - but I just don't know!
    [[imageUploadRequest parameters] setValue:albumID
                                       forKey:@"album"];
    
    NSLog(@"imageUploadRequest parameters: %@",[imageUploadRequest parameters]);
    
    // Results of DebugLog:
    // imageUploadRequest parameters: {
    //     album = 10151057144449632;
    //     picture = "<UIImage: 0xc6b6920>";
    // }
    // The album data returns correctly using FB's Graph API explorer tool,
    // so I know it's a legit album.
    // https://developers.facebook.com/tools/explorer
    
    FBRequestConnection *connection = [[FBRequestConnection alloc] init];
    
    [connection addRequest:imageUploadRequest
         completionHandler:^(FBRequestConnection *connection, id result, NSError *error) {
             
             if (!error) {
                 
                 NSLog(@"Photo uploaded successfuly! %@",result);
                 
                 // Results of DebugLog:
                 //
                 // Photo uploaded successfuly! {
                 //     id = 10151057147399632;
                 //     "post_id" = "511304631_10151057094374632";
                 // }
                 // Again, the photo at that ID shows up correctly, etc -
                 // BUT it's in the wrong album! It shows up in the default app album.
                 
             } else {
                 
                 NSLog(@"Photo uploaded failed :( %@",error.userInfo);
             }
             
         }];
    
    [connection start];
    
}



-(IBAction)backButton {
    
    
    InboxViewController *ivc;
    
    
    //[self.navigationController popToViewController:ivc animated:YES];
    [self.navigationController pushViewController:ivc animated:YES];
    
    
    
    
    
    
}



@end
