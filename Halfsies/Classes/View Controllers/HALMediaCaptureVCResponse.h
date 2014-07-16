//
//  MediaCaptureVCResponse.h
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/5/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AVFoundation/AVFoundation.h>
#import <AVFoundation/AVVideoSettings.h>
#import "HALSendToFriendsViewController.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioToolbox.h>

@interface HALMediaCaptureVCResponse : UIViewController

@property (nonatomic, strong) PFObject *message;

@end


