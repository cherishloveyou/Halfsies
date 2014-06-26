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
#import "SendToFriendsViewController.h"
#import <Parse/Parse.h>
#import <AudioToolbox/AudioToolbox.h>

@interface MediaCaptureVCResponse : UIViewController

-(IBAction)stillImageCapture;
-(IBAction)toggleFlash;
-(IBAction)xButton;
-(IBAction)toggleCamera;

- (IBAction)backButton;

- (IBAction)shareButton;
//This property is used to store the PFObject that is being passed from the Inbox View Controller.

@property (nonatomic, strong) PFObject *message;

@property (strong, nonatomic) IBOutlet UIButton *toggleFlashButton;

-(IBAction)sendButton;

@property (nonatomic,retain) AVCaptureSession *session;


@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;

@property (nonatomic, retain) AVCaptureVideoDataOutput *videoOutput;



@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) AVCaptureDevice *inputDevice;
@property (nonatomic, retain) NSString *hasUserTakenAPhoto;
@property (nonatomic, retain) CALayer *rootLayer;

@property (nonatomic, retain) UIActionSheet *xButtonAfterPhotoTaken;
@property (nonatomic, retain) UIActionSheet *xButtonBeforePhotoTaken;


@property (nonatomic, retain) UIActionSheet *shareSheet;
@property (nonatomic, retain) UIActionSheet *uploadPhotoShareSheet;



@property (nonatomic, retain) NSString *xButtonActionSheetTitle;
@property (nonatomic, retain) AVCaptureDeviceInput *deviceInput;

@property (nonatomic, retain) IBOutlet UIView *takingPhotoView;

@property (nonatomic, retain) IBOutlet UIView *afterPhotoView;

@property (nonatomic, retain) IBOutlet UIView *smsWindowAfterSignup;

@property (nonatomic, retain) IBOutlet UIView *sharePhotoView;


@property (nonatomic, retain) IBOutlet UIImageView *topHalfView;

@property (nonatomic, retain) IBOutlet UIImageView *topAndBottomHalfView;

@property (strong, nonatomic) IBOutlet UIImageView *bottomHalfView;






@property (nonatomic, retain) NSMutableArray *usersToAddToFriendsList;


//The NSString property below will be used to pass an NSString object like "YES" from the Add Friends View Controller. That way if the user has just finished signing up and is leaving the AddFriendsViewController, and they also have selected to send a text message invite to some of their contacts, we will place a string of "YES" in this object. Then, we can setup an if statemenet that checks for a "YES" in the object, and if it finds it, then we know to launch the SMS window.

@property (nonatomic, retain) NSString *justFinishedSigningUp;

//These are the properties to pass the phone numbers and the text message body with user's username to this view controller.

@property (nonatomic, retain) NSArray *usersToInviteToHalfsies;
@property (nonatomic, retain) NSString *textMessageInviteText;


@property (nonatomic, retain) ACAccount *facebookAccount;


@property (nonatomic, strong) UIAlertView *uploadPhotoAlertView;
@property (nonatomic, strong) UIAlertView *reportAlertView;


@property (nonatomic, strong) NSString *photoUploadAlertViewMessage;

@property (nonatomic, strong) NSURL *imageFileURL;

@property (nonatomic, strong) NSURL *finishedImageFileURL;

@property (nonatomic, strong) PFFile *finishedImageFile;

@property (nonatomic, strong) UIImage *image;

@property (nonatomic, strong) UIImage *image9;



@end



BOOL isUsingFrontFacingCamera;
float finalXValueForCrop;

