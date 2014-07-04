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
@property (strong, nonatomic) IBOutlet UIButton *toggleFlashButton;
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
@property (nonatomic, retain) NSString *justFinishedSigningUp;
@property (nonatomic, retain) NSArray *usersToInviteToHalfsies;
@property (nonatomic, retain) NSString *textMessageInviteText;
@property (nonatomic, strong) UIAlertView *uploadPhotoAlertView;
@property (nonatomic, strong) UIAlertView *reportAlertView;
@property (nonatomic, strong) NSString *photoUploadAlertViewMessage;
@property (nonatomic, strong) NSURL *imageFileURL;
@property (nonatomic, strong) NSURL *finishedImageFileURL;
@property (nonatomic, strong) PFFile *finishedImageFile;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *image9;

- (IBAction)stillImageCapture;
- (IBAction)toggleFlash;
- (IBAction)xButton;
- (IBAction)toggleCamera;
- (IBAction)backButton;
- (IBAction)shareButton;
- (IBAction)sendButton;

@end

BOOL isUsingFrontFacingCamera;
float finalXValueForCrop;

