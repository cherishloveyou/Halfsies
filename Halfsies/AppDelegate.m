//
//  AppDelegate.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/25/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "AppDelegate.h"
#import <Parse/Parse.h>
#import "AddFriendsViewController.h"
#import <FacebookSDK/FacebookSDK.h>
#import "MediaCaptureVCResponse.h"
#import "InboxViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // This is the code for Parse.
    
    [Parse setApplicationId:@"DbuUgYKaPqMHJ63Nut29Xw4rp95nHw0VCSP7MDAK" clientKey:@"8k0eCg6XO63K43cZE4KkawU3eOSVaXVPEn1t8hzx"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Crashlytics Code
    [Crashlytics startWithAPIKey:@"cc10af8049451966554e6df4d160875030930f4c"];
    
    
    //This is the first block of code from the Parse photo app tutorial located here: https://parse.com/tutorials/saving-images
    
   
    
  /*  PFUser *currentUser = [PFUser currentUser];
    if (currentUser) {
        [currentUser refresh:nil];
    } else {
        // Dummy username and password
        PFUser *user = [PFUser user];
        user.username = @"Matt";
        user.password = @"password";
        user.email = @"Matt@example.com";
        
        [user signUpInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            if (!error) {
                [user refresh:nil];
                NSLog(@"New User? %@", user);

            } else {
                [PFUser logInWithUsername:@"Matt" password:@"password"];
                [user refresh:nil];
                NSLog(@"New User? %@", user);

            }
        }];
    }

    NSLog(@"Current User? %@", currentUser); */
    
    
    
    
    // Whenever a person opens the app, check for a cached session
    
    
    

    
    // Override point for customization after application launch.
    return YES;
    
    }
    
							
- (void)applicationWillResignActive:(UIApplication *)application
{
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application
{
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later. 
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application
{
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
    
    
    // Handle the user leaving the app while the Facebook login dialog is being shown
    // For example: when the user presses the iOS "home" button while the login dialog is active
    [FBAppCall handleDidBecomeActive];
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.


- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error
{
    // If the session was opened successfully
    if (!error && state == FBSessionStateOpen){
        NSLog(@"Session opened");
        // Show the user the logged-in UI
        [self userLoggedIn];
        return;
    }
    if (state == FBSessionStateClosed || state == FBSessionStateClosedLoginFailed){
        // If the session is closed
        NSLog(@"Session closed");
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
    
    // Handle errors
    if (error){
        NSLog(@"Error");
        NSString *alertText;
        NSString *alertTitle;
        // If the error requires people using an app to make an action outside of the app in order to recover
        if ([FBErrorUtility shouldNotifyUserForError:error] == YES){
            alertTitle = @"Something went wrong";
            alertText = [FBErrorUtility userMessageForError:error];
            [self showMessage:alertText withTitle:alertTitle];
            
            
        } else {
            
            // If the user cancelled login, do nothing
            if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
                NSLog(@"User cancelled login");
                
                // Handle session closures that happen outside of the app
            } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession){
                alertTitle = @"Session Error";
                alertText = @"Your current session is no longer valid. Please log in again.";
                [self showMessage:alertText withTitle:alertTitle];
                
                
                
                // For simplicity, here we just show a generic message for all other errors
                // You can learn how to handle other errors using our guide: https://developers.facebook.com/docs/ios/errors
            } else {
                //Get more error information from the error
                NSDictionary *errorInformation = [[[error.userInfo objectForKey:@"com.facebook.sdk:ParsedJSONResponseKey"] objectForKey:@"body"] objectForKey:@"error"];
                
                // Show the user an error message
                alertTitle = @"Something went wrong";
                alertText = [NSString stringWithFormat:@"Please retry. \n\n If the problem persists contact us and mention this error code: %@", [errorInformation objectForKey:@"message"]];
                [self showMessage:alertText withTitle:alertTitle];
                
               
            }
        }
        // Clear this token
        [FBSession.activeSession closeAndClearTokenInformation];
        // Show the user the logged-out UI
        [self userLoggedOut];
    }
}

// Show the user the logged-out UI


- (void)userLoggedOut
{
    
    
    // Confirm logout message
    [self showMessage:@"You're now logged out" withTitle:@""];
}

// Show the user the logged-in UI
- (void)userLoggedIn
{
    // Set the button title as "Log out"
    
    // Welcome message
    
    /*[self showMessage:@"You can now share your halfsies to Facebook. Tap the same button you just did to share this halfsies photo on your Facebook." withTitle:@"Facebook Connected!"]; */
    
    
    //Retreive user default
    
    
    
    NSData* imageData = [[NSUserDefaults standardUserDefaults] objectForKey:@"specialfacebookimage"];
    UIImage* imagez13 = [UIImage imageWithData:imageData];
    
    NSLog(@"Make sure imagez13 is not null: %@", imagez13);
    
    
    //NSData *data = [standardDefaults objectForKey:@"parseMessages1"];

    
    //UIImage *imager = [standardDefaults objectForKey:@"specialfacebookimage"];
    
    //NSLog(@"imager contents: %@", imager);
    
    //Add code here to share to Facebook.
    
    NSLog(@"Image from user defaults: %@", imagez13);
    
    NSString *album = @"FrontStack";

    NSLog(@"right before facebook method call in app delegate");
    
    [self postPhotosToFacebook:imagez13 withAlbumID:album];

    NSLog(@"right after facebook method call in app delegate");
    
    
    
   /* NSLog(@"About to segue to inbox fron AppDelegate.m");
    
    UIStoryboard *storyboard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    InboxViewController *ivc = [storyboard instantiateViewControllerWithIdentifier:@"InboxViewController"];
    
    [(UINavigationController*)self.window.rootViewController pushViewController:ivc animated:NO]; */
    
}

// Show an alert message

- (void)showMessage:(NSString *)text withTitle:(NSString *)title
{
    [[[UIAlertView alloc] initWithTitle:title
                                message:text
                               delegate:self
                      cancelButtonTitle:@"OK!"
                      otherButtonTitles:nil] show];
}

// During the Facebook login flow, your app passes control to the Facebook iOS app or Facebook in a mobile browser.
// After authentication, your app will be called back with the session information.
// Override application:openURL:sourceApplication:annotation to call the FBsession object that handles the incoming URL

- (BOOL)application:(UIApplication *)application
            openURL:(NSURL *)url
  sourceApplication:(NSString *)sourceApplication
         annotation:(id)annotation
{
    // Note this handler block should be the exact same as the handler passed to any open calls.
    [FBSession.activeSession setStateChangeHandler:
     ^(FBSession *session, FBSessionState state, NSError *error) {
         
         // Retrieve the app delegate
         AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
         // Call the app delegate's sessionStateChanged:state:error method to handle session state changes
         [appDelegate sessionStateChanged:session state:state error:error];
     }];
    
    return [FBAppCall handleOpenURL:url sourceApplication:sourceApplication];
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
    // so I know it's a real album.
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
                 
                 /* UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong. Please try again and make sure Halfsies is enabled in Settings > Privacy > Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                  
                  [alertView show]; */
             }
             
         }];
    
    [connection start];
    
}






@end
