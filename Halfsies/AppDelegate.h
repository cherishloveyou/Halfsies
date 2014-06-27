//
//  AppDelegate.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 12/25/13.
//  Copyright (c) 2013 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>
#import <FacebookSDK/FacebookSDK.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

- (void)userLoggedIn;
- (void)userLoggedOut;
- (void)sessionStateChanged:(FBSession *)session state:(FBSessionState) state error:(NSError *)error;

@end
