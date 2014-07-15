//
//  AppDelegate.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/25/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import "HALAppDelegate.h"
#import <Parse/Parse.h>
#import "HALAddFriendsViewController.h"
#import "HALMediaCaptureVCResponse.h"
#import "HALInboxViewController.h"
#import <Crashlytics/Crashlytics.h>

@implementation HALAppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    
    // This is the code for Parse.
    
    [Parse setApplicationId:@"DbuUgYKaPqMHJ63Nut29Xw4rp95nHw0VCSP7MDAK" clientKey:@"8k0eCg6XO63K43cZE4KkawU3eOSVaXVPEn1t8hzx"];
    
    [PFAnalytics trackAppOpenedWithLaunchOptions:launchOptions];
    
    //Crashlytics Code
    [Crashlytics startWithAPIKey:@"cc10af8049451966554e6df4d160875030930f4c"];
    
    
    //This is the first block of code from the Parse photo app tutorial located here: https://parse.com/tutorials/saving-images
    
   
 
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
    
}

- (void)applicationWillTerminate:(UIApplication *)application
{
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
