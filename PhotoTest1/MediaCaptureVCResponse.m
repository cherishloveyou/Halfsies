//
//  MediaCaptureVCResponse.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 3/5/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "MediaCaptureVCResponse.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <Social/Social.h>
#import<Accounts/Accounts.h>
#import <FacebookSDK/FacebookSDK.h>
#import "AppDelegate.h"

@interface MediaCaptureVCResponse () <UIActionSheetDelegate, AVCaptureFileOutputRecordingDelegate,AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) NSString *photo;
@property (strong, nonatomic) UIImageView *imageView;
@property (strong, nonatomic) UIImageView *imageView2;
@property (strong, nonatomic) NSString *senderName;

- (UIImage*)rotate:(UIImageOrientation)orient;

@end

static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat  swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}


@implementation MediaCaptureVCResponse

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
    
    
    
    
    self.topHalfView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    
    
    self.takingPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.afterPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);

    
    self.topAndBottomHalfView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    // I had to change the y parameter for bottomHalfView to 0 otherwise the screenshot was not capturing the full image contained in self.bottomHalfView.frame. It must just be because that view is the only view not hidden when the screenshot is captured?
    
    self.bottomHalfView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 284);

    
    NSLog(@"topHalfView frame: %@", NSStringFromCGRect(self.topHalfView.frame));
    NSLog(@"takingPhotoView frame: %@", NSStringFromCGRect(self.takingPhotoView.frame));
    NSLog(@"afterPhotoView frame: %@", NSStringFromCGRect(self.afterPhotoView.frame));
    NSLog(@"topAndBottomHalfView frame: %@", NSStringFromCGRect(self.topAndBottomHalfView.frame));
    
    
    
    PFFile *imageFile = [self.message objectForKey:@"file"];
    
    self.senderName = [self.message objectForKey:@"senderName"];
    
    
    self.imageFileURL = [[NSURL alloc]initWithString:imageFile.url];
    
    imageFile = nil;
    
    self.imageData = [NSData dataWithContentsOfURL:self.imageFileURL];
    
    self.imageFileURL = nil;
    
    self.image9 = [UIImage imageWithData:self.imageData];
    
    
    
    self.imageView = [[UIImageView alloc]initWithImage:self.image9];
    
    self.imageView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height/2);
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;

    [self.imageView setClipsToBounds:YES];
    
    NSLog(@"The image view's content mode is: %d", self.imageView.contentMode);
    
    
    //self.topHalfView.image = [UIImage imageWithData:self.imageData];
    
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    
    
    
    NSLog(@"topHalfView.image.size: %@", NSStringFromCGSize(self.imageView.image.size));

    NSLog(@"IMAGE FOR THE TOP HALF: %@", self.imageView.image);
    
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
    NSLog(@"Just finished signing up? %@", _justFinishedSigningUp);
    
    NSLog(@"Were the phone numbers passed from the add friends VC? %@", self.usersToInviteToHalfsies);
    NSLog(@"Was the text message body passed from the add friends VC? %@", self.textMessageInviteText);
    
    
    
    if ([self respondsToSelector:@selector(setNeedsStatusBarAppearanceUpdate)]) {
        // iOS 7
        [self prefersStatusBarHidden];
        [self performSelector:@selector(setNeedsStatusBarAppearanceUpdate)];
    } else {
        // iOS 6
        [[UIApplication sharedApplication] setStatusBarHidden:YES withAnimation:UIStatusBarAnimationSlide];
    }
    
    
    
    
	
    
    self.session =[[AVCaptureSession alloc]init];
    
    
    [self.session setSessionPreset:AVCaptureSessionPresetPhoto];
    
    
    
    self.inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSLog(@"The current device position is: %d", self.inputDevice.position);
    
    NSError *error;
    
    
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.inputDevice error:&error];
    
    NSLog(@"Currently using this device: %@", _deviceInput.device);
    
    
    if([self.session canAddInput:self.deviceInput])
        [self.session addInput:self.deviceInput];
    
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    
  
    
    
    self.rootLayer = [[self view]layer];
    
    
    [self.rootLayer setMasksToBounds:YES];
    
    
    [_previewLayer setFrame:CGRectMake(0, self.rootLayer.bounds.size.height/2, self.rootLayer.bounds.size.width, self.rootLayer.bounds.size.height/2)];
    
    NSLog(@"The root layer's y coordinate: %f", self.rootLayer.bounds.size.height/2);
    
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    [self.rootLayer insertSublayer:_previewLayer atIndex:0];
    
    
    
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [self.session addOutput:self.videoOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    
    [self.videoOutput setSampleBufferDelegate:self queue:queue];
    
    //Same thing as above statement!
    //[[self videoOutput]setSampleBufferDelegate:self queue:queue];

    
    
    
    [_session startRunning];
    
    
    
}


-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}




-(IBAction)stillImageCapture {
    
    AudioServicesPlaySystemSound(1108);

    
    
    self.hasUserTakenAPhoto = @"YES";
    
    
    [self.session stopRunning];
    
    
    NSLog(@"self.image: %@", self.image);
    NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
    
    
    if(self.inputDevice.position == 2) {
        
        NSLog(@"Input device position 2!");
        
        //self.image = [self selfieCorrection:self.image];
        
        //self.image = [self selfieCorrection:self.image];
        
        self.image = [self rotate:UIImageOrientationRightMirrored];

        
        NSLog(@"self.image: %@", self.image);
        NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
        
        
    } else {
        
        
        self.image = [self rotate:UIImageOrientationRight];
        
        NSLog(@"self.image: %@", self.image);
        NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
        
        
    }
    
    CGFloat widthToHeightRatio = _previewLayer.bounds.size.width / _previewLayer.bounds.size.height;
    
    CGRect cropRect;
    // Set the crop rect's smaller dimension to match the image's smaller dimension, and
    // scale its other dimension according to the width:height ratio.
    if (self.image.size.width < self.image.size.height) {
        cropRect.size.width = self.image.size.width;
        cropRect.size.height = cropRect.size.width / widthToHeightRatio;
    } else {
        cropRect.size.width = self.image.size.height * widthToHeightRatio;
        cropRect.size.height = self.image.size.height;
    }
    
    // Center the rect in the longer dimension
    if (cropRect.size.width < cropRect.size.height) {
        cropRect.origin.x = 0;
        cropRect.origin.y = (self.image.size.height - cropRect.size.height)/2.0;
        
        NSLog(@"Y Math: %f", (self.image.size.height - cropRect.size.height));
        
        
    } else {
        
        cropRect.origin.x = (self.image.size.width - cropRect.size.width)/2.0;
        cropRect.origin.y = 0;
        
        
        
        //The below statement creates a float that is almost perfect, but the value is still doubled.
        
        float cropValueDoubled = self.image.size.height - 568;
        
        //So we need to create a new float and set it equal to the doubled value divided by 2.
        
        float final = cropValueDoubled/2;
        
        //We now have our perfect x coordinate for our crop below.
        
        finalXValueForCrop = final;
        
        //The crop is now working perfectly for BOTH selfies and regular photos.
        
    }
    
    
    
    
    
    CGRect cropRectFinal = CGRectMake(cropRect.origin.x, finalXValueForCrop, cropRect.size.width, 568);
    
    CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], cropRectFinal);
    
    UIImage *image2 = [[UIImage alloc]initWithCGImage:imageRef];
    
    
    self.image = image2;
    
    
    
    
    CGImageRelease(imageRef);


    
    //self.bottomHalfView.image = self.image;
    
    
    if ([self.hasUserTakenAPhoto isEqual:@"YES"] && self.inputDevice.position == 2) {
        
        NSLog(@"Bottom half is a selfie");
        
        
        [self.takingPhotoView setHidden:YES];
        
        [self.topHalfView setHidden:YES];
        
        //tophalfview and topandbottomhalfview
        
        
        //self.bottomHalfView.image = self.image;
        
        
        self.imageView2 = [[UIImageView alloc]initWithImage:self.image];
        
        self.imageView2.frame = CGRectMake(0, 0, self.view.bounds.size.width, 284);
        
        //self.image = self.imageView2.image;
        
        //[self performSelector:@selector(uploadPhoto)];
        
        NSLog(@"the frame of imageView2 is: %@", NSStringFromCGRect(self.imageView2.frame));

        
        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.imageView2 setClipsToBounds:YES];
        
        NSLog(@"The image view's content mode is: %d", self.imageView2.contentMode);
        
        
        //self.topHalfView.image = [UIImage imageWithData:self.imageData];
        
        [self.view addSubview:self.imageView2];
        //[self.view sendSubviewToBack:self.imageView2];
        
        //[self.imageView setHidden:YES];
        
        NSLog(@"Context of screenshot: %@", NSStringFromCGSize(self.imageView2.bounds.size));
        
        self.image = [self screenshot];
        
        NSLog(@"self.image size BEFORE combining: %@", NSStringFromCGSize (self.image.size));

        //[self performSelector:@selector(uploadPhoto)];

        NSLog(@"Just took screenshot");
        NSLog(@"Uploading screenshot to Parse");
        
        //[self performSelector:@selector(uploadPhoto)];
        
        
        //[self saveToLibray];
        
        
        [self.imageView2 setHidden:YES];

        
        
        [self.imageView setHidden:NO];

        
 
        self.image = [self imageByCombiningImage:self.image9 withImage:self.image];
        

        NSLog(@"self.image size AFTER combining: %@", NSStringFromCGSize(self.image.size));

        
        [self.afterPhotoView setHidden:NO];
        
        
        
    } else if ([self.hasUserTakenAPhoto isEqual:@"YES"]) {
        
        
    NSLog(@"This should not NSLog when the bottom half is a selfie");
        
    
    [self.takingPhotoView setHidden:YES];
    
    self.image = [self imageByCombiningImage:self.image9 withImage:self.image];
        
    [self.afterPhotoView setHidden:NO];

        
    }
    
        
}





- (UIImage *) screenshot {
    
    UIGraphicsBeginImageContextWithOptions(self.imageView2.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (UIImage*)imageByCombiningImage:(UIImage*)firstImage withImage:(UIImage*)secondImage {
    UIImage *image = nil;
    
    CGSize newImageSize = CGSizeMake(MAX(self.view.bounds.size.width, self.view.bounds.size.width), MAX(568, 568));
    
    NSLog(@"newImageSize: %@", NSStringFromCGSize(newImageSize));
    
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        
        NSLog(@"It's not NULL");
        
        NSLog(@"UIScreen mainScreen scale: %f", [[UIScreen mainScreen]scale]);
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
        
    } else {
        
        
        NSLog(@"It is NULL");
        
        
        UIGraphicsBeginImageContext(newImageSize);
        
        
    }
    
    
    [firstImage drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, 568/2)];
    
    [secondImage drawInRect:CGRectMake(0, 568/2, self.view.bounds.size.width, 568/2)];
    
    NSLog(@"Here come the crop values for firstImage");
    
    NSLog(@"firstImage's self.view.bounds.size.width: %f", self.view.bounds.size.width);
    NSLog(@"firstImage's self.view.bounds.size.height/2: %f", self.view.bounds.size.height/2);
    
    NSLog(@"Here come the crop values for secondImage");
    
    NSLog(@"secondImage's self.view.bounds.size.height/2: %f", self.view.bounds.size.height/2);
    
    
    
    NSLog(@"secondImage size: %@", NSStringFromCGSize(secondImage.size));
    NSLog(@"secondImage description: %@", secondImage.description);
    
    NSLog(@"secondImage height divided by 2: %f", self.view.bounds.size.height/2);
    
    
    image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}




- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    NSLog(@"1: %@", self.image.description);
    
    
    // Create a UIImage from the sample buffer data
    
    // You are manually calling this.
    
    
    
    
    self.image = [self imageFromSampleBuffer:sampleBuffer];
    
    
    
    
    self.image = [self rotate:UIImageOrientationRight];
    
    //self.topHalfView.image = self.image;
    
    
    
    //< Add your code here that uses the image >
    
    //NSLog(@"2: %@", self.image.description);
    
}




-(IBAction)toggleFlash {
    
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        
        NSLog(@"Does this device support flash? %d", [device hasFlash]);
        NSLog(@"Does this device support torch? %d", [device hasTorch]);

        
        if ([device hasTorch] == YES) {
            
            NSLog(@"Current Device Torch Mode: %d", device.torchMode);
            
            
            [device lockForConfiguration:nil];
            
            
            if(device.torchMode == 0) {
                
                //[device setFlashMode:AVCaptureFlashModeOn];
                [device setTorchMode:AVCaptureTorchModeOn];
                
                NSLog(@"New device flash mode: %d", device.flashMode);
                NSLog(@"New device torch mode: %d", device.torchMode);
                

                
                
            } else if (device.torchMode == 1) {
                
                //[device setFlashMode:AVCaptureFlashModeOff];
                [device setTorchMode:AVCaptureTorchModeOff];
                
                
                NSLog(@"New device flash mode: %d", device.flashMode);
                NSLog(@"New device torch mode: %d", device.torchMode);

                
                
            } else if (device.torchMode == 2) {
                
                //[device setFlashMode:AVCaptureFlashModeOn];
                [device setTorchMode:AVCaptureTorchModeOn];

                
                
            }
            
            [device unlockForConfiguration];
        }
    }
    
}




-(IBAction)xButton {
    
    
    NSLog(@"Has the user take a photo? %@", self.hasUserTakenAPhoto);
    
    //NSString *title;
    
    //Check the global variable "hasUserTakenAPhoto" to see if it contains the string "YES"
    
    if ([self.hasUserTakenAPhoto isEqual:@"YES"])
        
    {
        
        
        NSString *originalSender = [[NSString alloc]init];
        
        originalSender = [self.message objectForKey:@"senderName"];
        
        NSString *buttonIndex1title = [[NSString alloc]initWithFormat:@"Finish and send to %@!", originalSender];
        
        
        self.xButtonAfterPhotoTaken = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Retake Your Half" otherButtonTitles:buttonIndex1title,nil];
        
        [self.xButtonAfterPhotoTaken showInView:self.view];
        
        
        
    }
    
    else
        
    {
        
        //Delete as much as you can here before you segue.
        
        
        
        [_session removeInput:_deviceInput];
        
        [_session removeOutput:_stillImageOutput];
        
        [_session stopRunning];
        
        
        
        _session = nil;
        
        _inputDevice = nil;
        
        _deviceInput = nil;
        
        _previewLayer = nil;
        
        _stillImageOutput = nil;
        
        self.imageData = nil;
        self.image = nil;
        self.topHalfView.image = nil;
        
        
        self.xButtonBeforePhotoTaken = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Back to Inbox",@"Report User", nil];
        
        [self.xButtonBeforePhotoTaken showInView:self.view];
        
        
    
        
        
        //[self performSegueWithIdentifier:@"segueToInbox" sender:self];
        
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    if (actionSheet == _xButtonAfterPhotoTaken && buttonIndex == 0)
    {
        //[self performSegueWithIdentifier:@"backToHomeFromMediaCaptureVC" sender:self];
        
        //Now, after the user has captured a photo, if they press the "Delete" button on the action sheet, it will call this method below which basically refreshes the sublayer.
        
        //[_subLayer setNeedsDisplay];
        
        //We set the _afterPhotoView to hidden "YES" becuase this is the UIView we display only after the photo is taken.
        
        [_afterPhotoView setHidden:YES];
        
        //We set the _takingPhotoView back to hidden "NO" because this is the view we want for a fresh camera interface.
        
        [_takingPhotoView setHidden:NO];
        
        self.image = nil;
        self.bottomHalfView.image = nil;
        
        
        [self.session startRunning];

        
        
    }
    
    
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        // Do something...
        
        NSLog(@"DELETE BUTTON HAS BEEN PRESSED!");
        
        [self.topHalfView setHidden:NO];
        
        //[self.topAndBottomHalfView setHidden:YES];
        //self.topAndBottomHalfView = nil;
        
        //The 2 comments above would not work for fixing the "disappearing" top half view after taking one response photo.
        //The only way to fix it was with the statement below, which sets the top and bottom half view's image property to nil.
        
        
        self.topAndBottomHalfView.image = nil;
        self.bottomHalfView.image = nil;
        
        self.hasUserTakenAPhoto = @"NO";
        
        //self.subLayer = nil;
        self.imageData = nil;
        self.image = nil;
        
        NSLog(@"hasUserTakenAPhoto should be NO? %@", _hasUserTakenAPhoto);
        //NSLog(@"Was subLayer deleted? %@", _subLayer);
        NSLog(@"Was imageData deleted? %@", self.imageData);
        NSLog(@"Was image deleted? %@", self.image);
        
    }
    
    
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 1)
        
    {
        
        NSLog(@"Finish going halfsies button pressed.");
        
        //We will now segue to the Share View Controller.
        //We'll also have to pass the correct info that the Share View Controller will need.
        
        
        [self uploadPhoto];
        
        
        //[self performSegueWithIdentifier:@"segueToShareVC" sender:self];
        
        NSLog(@"Dismiss the current action sheet!");
        
      /*  [actionSheet dismissWithClickedButtonIndex:1 animated:YES];
        
        
        //Create the new action sheet for sharing.
        
        self.shareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Share on Facebook", @"Share on Twitter", @"Copy Share Link", nil];
        
        //Display the new sharing action sheet.
        
        [self.shareSheet showInView:self.view]; */
        
        
    }
    
    
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 2)
        
    {
        
        NSLog(@"Cancel button pressed!");
        
        // Do something...
        
       /* NSLog(@"Save to Library Has Been Pressed.");
        
        NSLog(@"Authorization Status for Photo Library Access: %d", [ALAssetsLibrary authorizationStatus]);
        
        
        ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
        
        
        // Request to save the image to camera roll
        [library writeImageToSavedPhotosAlbum:[self.image CGImage] orientation:(ALAssetOrientation)[self.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
            
            if (error) {
                
                //NOT SAVED
                //DISPLAY ERROR THE PICTURE CAN'T BE SAVED
                
                
                NSLog(@"There was an error: %@", error);
                
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Could not save photo to your library. Please enable Halfsies in Settings > Privacy > Photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                
                
            } else {
                
                //SAVED
                
                NSLog(@"No errors with access and image was saved!");
                
                //Once we know that there hasn't been an error in the completion block, we release the core graphics image that we created above to save to the library.
                
                CGImageRelease([self.image CGImage]);
                
                
                
            }
        }];
        
        */
        
        
        
    }
    
    
    if(actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 3) {
        
        NSLog(@"Cancel button pressed!");
        
    }
    

    
    
    
    if ((actionSheet == self.shareSheet && buttonIndex == 0) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 0))
        
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
                 // Get account and communicate with Twitter API.
                 
                 NSLog(@"Twitter access has been granted!");
                 
                 //Now that access has been granted, we need to place the Twitter account in an object.
                 
                 
                 NSArray *arrayOfAccounts = [account
                                             accountsWithAccountType:accountType];
                 
                 if ([arrayOfAccounts count] > 0)
                 {
                     ACAccount *twitterAccount =
                     [arrayOfAccounts lastObject];
                     
                     
                     //This code below creates a new message to post to the user's Twitter feed.
                     
                     NSString *twitterStatus = [[NSString alloc]initWithFormat:@"Just finished going halfsies with %@. #halfsies get.halfsies.co", self.senderName];
                     
                     NSDictionary *message = @{ @"status": twitterStatus};
                     
                     
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
    

        
        
       /* NSLog(@"Share on Facebook Has Been Pressed.");
        
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
            
            
            
            NSLog(@"fbsession 1");
            
            //If the if statement above is true, then we are ready to call the post photos to facebook method.
            //NOTE: As of April 2nd, it seems like the above if statement is never true.
            
            NSString *album = @"FrontStack";
            
            NSLog(@"right before facebook method call in app delegate");
            
            [self postPhotosToFacebook:self.image withAlbumID:album];
            
            
            
            
        } else {
            
            
            //Since the above if statement was not met, we have to do extra work to successfully post to Facebook.
            
            //Create user defaults object.
            
            NSUserDefaults *standardDefaults = [NSUserDefaults standardUserDefaults];
            
            //Create PNG vesion of self.image and set as user default/
            
            [[NSUserDefaults standardUserDefaults] setObject:UIImagePNGRepresentation(self.image) forKey:@"specialfacebookimage"];
            
            NSLog(@"self.image right before synchronize: %@", self.image);
            
            //Save the new user defaults.
            
            [standardDefaults synchronize];
            
            //These defaults will be used now in AppDelegate.m once a facebook session has been successfully opened.
            

            
            NSLog(@"fbsession 2");
            
            // Open a session showing the user the login UI
            // You must ALWAYS ask for basic_info permissions when opening a session
            
            //[self performSegueWithIdentifier:@"segueToInbox" sender:self];

            
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
                 
                 NSLog(@"facebook session set1");
                 
                 
                 
                 NSLog(@"right before method call in app delegate");
                 
                 NSString *album = @"FrontStack";
                 
                 
                 [self postPhotosToFacebook:self.image withAlbumID:album];
                 
                 
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
        
        NSLog(@"right before facebook upload method call runs");
        
        NSString *album = @"FrontStack";
        
        //NSArray *arrayz = [[NSArray alloc]initWithObjects:self.finishedHalfsieImageView.image, nil];
        
        [self postPhotosToFacebook:self.image withAlbumID:album];
        
      
        
        
    } */
    
    
    if((actionSheet == self.shareSheet && buttonIndex == 1) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 1)) {
        
        
       
        [self saveToLibray];
        
      
       
    }
    
        
    if((actionSheet == self.shareSheet && buttonIndex == 2) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 2)) {
        
        
        
        
        NSLog(@"Copy Share Link has been pressed.");
        
        
        //Copy imageFileURL to the user's clipboard.
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        NSLog(@"The finished image file URL before copying is: %@", self.finishedImageFileURL);
        
        pasteboard.URL = self.finishedImageFileURL;
        
        NSLog(@"The final pasteboard URL is: %@", pasteboard.URL);
        
        
        
    }
    
    
    if(actionSheet == self.uploadPhotoShareSheet && buttonIndex == 3) {
        
        
        NSLog(@"Cancel button on special uploadPhotoShareSheet has been pressed!");
        
        //Take the user back to their inbox.
        
        [self performSegueWithIdentifier:@"segueToInbox" sender:self];
        

        
        
        
    }
    
    
    
    if(actionSheet == self.xButtonBeforePhotoTaken && buttonIndex == 0) {
        
        
        
        NSLog(@"Back to inbox has been pressed.");
        
        [self performSegueWithIdentifier:@"segueToInbox" sender:self];
        
    }

    
    
    
    if(actionSheet == self.xButtonBeforePhotoTaken && buttonIndex == 1) {
        
        
        
        NSLog(@"Report user has been pressed.");
        
        self.reportAlertView = [[UIAlertView alloc]initWithTitle:@"Report User" message:@"By tapping the OK button, you will be reporting this user and the content they sent you as inappropriate." delegate:self cancelButtonTitle:@"Cancel" otherButtonTitles:@"OK", nil];
        
        
        [self.reportAlertView show];
        
        
        
    }
    
    
    
    
}









- (void)actionSheetCancel:(UIActionSheet *)actionSheet

{
    NSLog(@"Canceled");
}






- (IBAction)toggleCamera
{
    
    AVCaptureDevicePosition desiredPosition;
    if (isUsingFrontFacingCamera)
        desiredPosition = AVCaptureDevicePositionBack;
    else
        desiredPosition = AVCaptureDevicePositionFront;
    
    for (_inputDevice in [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo]) {
        if ([_inputDevice position] == desiredPosition) {
            [[_previewLayer session] beginConfiguration];
            _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_inputDevice error:nil];
            for (AVCaptureInput *oldInput in [[_previewLayer session] inputs]) {
                [[_previewLayer session] removeInput:oldInput];
            }
            [[_previewLayer session] addInput:_deviceInput];
            [[_previewLayer session] commitConfiguration];
            break;
        }
    }
    isUsingFrontFacingCamera = !isUsingFrontFacingCamera;
    
    if(desiredPosition == AVCaptureDevicePositionBack) {
        
        [self.toggleFlashButton setHidden:NO];
        
    }
    
    if(desiredPosition == AVCaptureDevicePositionFront) {
        
        [self.toggleFlashButton setHidden:YES];
        
    }

}



- (IBAction)backButton {
    
    [self performSegueWithIdentifier:@"segueToInbox" sender:self];
    
}

- (IBAction)shareButton {
    
    
    //Create the new action sheet for sharing.
    
    self.uploadPhotoShareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Take Me To My Inbox" destructiveButtonTitle:nil otherButtonTitles:@"Share on Twitter",@"Save to Library", @"Copy Share Link", nil];
    
    //Display the new sharing action sheet.
    
    [self.uploadPhotoShareSheet showInView:self.view];
    
    
}



-(IBAction)sendButton {
    
    
    [self uploadPhoto];
    
    //[self performSegueWithIdentifier:@"mediaCaptureToSendToFriendsSegue" sender:self];
    
    NSLog(@"uploadPhoto method called");
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    
    // This is our actual implmenetation body code which starts with an if statement. This says "If our segue identifier is equal to signupYoVerificationSegue then do this...
    if ([segue.identifier isEqualToString:@"mediaCaptureToSendToFriendsSegue"]) {
        
        //If the string IS equal to signupToVerificationSegue then we create a new object of our  custom View Controller class VerificationViewController and we set the value of this object to the segue property of destinationViewController.
        
        //AddFriendsViewController *addFriendsVC = segue.destinationViewController;
        SendToFriendsViewController *sendFriendsVC = segue.destinationViewController;
        
        //We then set the verifyViewController object that we just created to the property of uniqueVerificationCode which we set equal to the value that is stored inside _uniqueVerificationCode.
        
        //addFriendsVC.uniqueVerificationCode = _uniqueVerificationCode;
        
        //UIImage* image2 = [UIImage imageWithCGImage:(__bridge CGImageRef)(_subLayer.contents)];
        
        
        sendFriendsVC.halfsiesPhotoToSend = _image;
        
        
        
    }
    
    
    
    
    
    
    
}




// Delegate routine that is called when a sample buffer was written

//This is a delegate method implementation. This delegate method gets called when a sample buffer is written.




// Create a UIImage from sample buffer data

//This code ONLY runs when it is manually called in the method implementation above.



- (UIImage *) imageFromSampleBuffer:(CMSampleBufferRef) sampleBuffer
{
    // Get a CMSampleBuffer's Core Video image buffer for the media data
    CVImageBufferRef imageBuffer = CMSampleBufferGetImageBuffer(sampleBuffer);
    // Lock the base address of the pixel buffer
    CVPixelBufferLockBaseAddress(imageBuffer, 0);
    
    // Get the number of bytes per row for the pixel buffer
    void *baseAddress = CVPixelBufferGetBaseAddress(imageBuffer);
    
    // Get the number of bytes per row for the pixel buffer
    size_t bytesPerRow = CVPixelBufferGetBytesPerRow(imageBuffer);
    // Get the pixel buffer width and height
    size_t width = CVPixelBufferGetWidth(imageBuffer);
    size_t height = CVPixelBufferGetHeight(imageBuffer);
    
    // Create a device-dependent RGB color space
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    
    // Create a bitmap graphics context with the sample buffer data
    CGContextRef context = CGBitmapContextCreate(baseAddress, width, height, 8,
                                                 bytesPerRow, colorSpace, kCGBitmapByteOrder32Little | kCGImageAlphaPremultipliedFirst);
    
    // Create a Quartz image from the pixel data in the bitmap graphics context
    CGImageRef quartzImage = CGBitmapContextCreateImage(context);
    // Unlock the pixel buffer
    CVPixelBufferUnlockBaseAddress(imageBuffer,0);
    
    // Free up the context and color space
    CGContextRelease(context);
    CGColorSpaceRelease(colorSpace);
    
    // Create an image object from the Quartz image
    UIImage *image = [UIImage imageWithCGImage:quartzImage];
    
    // Release the Quartz image
    CGImageRelease(quartzImage);
    
    return (image);
}



- (UIImage *)selfieCorrection:(UIImage *)picture
{
    UIImage * flippedImage = [UIImage imageWithCGImage:picture.CGImage scale:picture.scale orientation:UIImageOrientationLeftMirrored];
    
    picture = flippedImage;
    
    return picture;
}



-(UIImage*)rotate:(UIImageOrientation)orient
{
    CGRect             bnds = CGRectZero;
    UIImage*           copy = nil;
    CGContextRef       ctxt = nil;
    CGRect             rect = CGRectZero;
    CGAffineTransform  tran = CGAffineTransformIdentity;
    
    bnds.size = self.image.size;
    rect.size = self.image.size;
    
    switch (orient)
    {
        case UIImageOrientationUp:
			return self.image;
            
        case UIImageOrientationUpMirrored:
			tran = CGAffineTransformMakeTranslation(rect.size.width, 0.0);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			break;
            
        case UIImageOrientationDown:
			tran = CGAffineTransformMakeTranslation(rect.size.width,
													rect.size.height);
			tran = CGAffineTransformRotate(tran, degreesToRadians(180.0));
			break;
            
        case UIImageOrientationDownMirrored:
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.height);
			tran = CGAffineTransformScale(tran, 1.0, -1.0);
			break;
            
        case UIImageOrientationLeft:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(0.0, rect.size.width);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
            
        case UIImageOrientationLeftMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height,
													rect.size.width);
			tran = CGAffineTransformScale(tran, -1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(-90.0));
			break;
            
        case UIImageOrientationRight:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeTranslation(rect.size.height, 0.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
            
        case UIImageOrientationRightMirrored:
			bnds.size = swapWidthAndHeight(bnds.size);
			tran = CGAffineTransformMakeScale(-1.0, 1.0);
			tran = CGAffineTransformRotate(tran, degreesToRadians(90.0));
			break;
            
        default:
			// orientation value supplied is invalid
			assert(false);
			return nil;
    }
    
    UIGraphicsBeginImageContext(bnds.size);
    ctxt = UIGraphicsGetCurrentContext();
    
    switch (orient)
    {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
			CGContextScaleCTM(ctxt, -1.0, 1.0);
			CGContextTranslateCTM(ctxt, -rect.size.height, 0.0);
			break;
            
        default:
			CGContextScaleCTM(ctxt, 1.0, -1.0);
			CGContextTranslateCTM(ctxt, 0.0, -rect.size.height);
			break;
    }
    
    CGContextConcatCTM(ctxt, tran);
    CGContextDrawImage(ctxt, rect, self.image.CGImage);
    
    copy = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return copy;
}










-(void)uploadPhoto {
    
    NSLog(@"self.image.size right before upload: %@", NSStringFromCGSize(self.image.size));
    
    NSString *fileType;
    NSString *halfOrFull;
    
    
    if(self.image != nil) {
        
        fileType = @"image";
        halfOrFull = @"full";
        
        NSData *imageData = UIImageJPEGRepresentation(self.image, 0.7);
        
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
        
        NSString *originalSender = [[NSString alloc]init];
        
        originalSender = [self.message objectForKey:@"senderId"];
        
        
        
        
        
        
        NSLog(@"PFFile has been created: %@", imageFile);
        
        [imageFile saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            
            if(error) {
                
                NSLog(@"There has been an error: %@ %@", error, [error userInfo]);
                
                UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                
                [alertView show];
                
            } else {
                
                
                [self.afterPhotoView setHidden:YES];

                
                
                
                
                PFObject *returnMessage = [PFObject objectWithClassName:@"Messages"];
                [returnMessage setObject:imageFile forKey:@"file"];
                [returnMessage setObject:fileType forKey:@"fileType"];
                [returnMessage addObject:originalSender forKey:@"recipientIds"];
                [returnMessage setObject:[[PFUser currentUser]objectId] forKey:@"senderId"];
                [returnMessage setObject:[[PFUser currentUser]username]forKey:@"senderName"];
                [returnMessage setObject:halfOrFull forKey:@"halfOrFull"];
                
                NSString *originalSender = [[NSString alloc]init];
                
                originalSender = [self.message objectForKey:@"senderName"];
                
                [returnMessage setObject:originalSender forKey:@"originalSender"];
                
                [returnMessage saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                    
                    if(error) {
                        
                        NSLog(@"There was an error: %@ %@", error, [error userInfo]);
                        
                        UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                        
                        [alertView show];
                        
                    } else {
                        
                        //Everything was successful.
                        
                        NSLog(@"Everything was successful.");
                        
                        
                        
                        if(succeeded == 1) {
                            
                            NSLog(@"Succeeded value right before 2nd save: %d", succeeded);
                            
                            
                            NSString *currentUsersObjectId = [[NSString alloc]init];
                            
                            
                            PFUser *user = [PFUser currentUser];
                            
                            currentUsersObjectId = user.objectId;
                            
                            [self.message addObject:currentUsersObjectId forKey:@"didRespond"];
                            
                            [self.message saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
                                
                                
                                if(error) {
                                    
                                    NSLog(@"There was an error: %@ %@", error, [error userInfo]);
                                    
                                    self.uploadPhotoAlertView = [[UIAlertView alloc]initWithTitle:@"An error occurred!" message:@"Please try sending your message again." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                                    
                                    [self.uploadPhotoAlertView show];
                                    
                                    
                                    
                                } else {
                                    
                                    
                                    
                                    //Everything was successful.
                                    
                                    NSLog(@"Everything was successful.");
                                    
                                    
                                    
                            
                                    
                                    
                                    if(succeeded == 1) {
                                        
                                        
                                        //[self performSegueWithIdentifier:@"segueToInbox" sender:self];
                                        
                                        
                                        NSString *originalSender2 = [[NSString alloc]init];
                                        
                                        originalSender2 = [self.message objectForKey:@"senderName"];
                                        
                                        self.photoUploadAlertViewMessage = [[NSString alloc]initWithFormat:@"You just finished going halfsies with %@!", originalSender2];
                                        
                                        //PFFile *imageFile = [self.message objectForKey:@"file"];
                                        
                                        self.finishedImageFile = imageFile;

                                        self.finishedImageFileURL = [[NSURL alloc]initWithString:self.finishedImageFile.url];
                                        
                                        self.uploadPhotoAlertView = [[UIAlertView alloc]initWithTitle:nil message:self.photoUploadAlertViewMessage delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
                                        
                                        [self.uploadPhotoAlertView show];
                                        
                                        //[self.sharePhotoView setHidden:NO];

                                        
                                    }
                                    
                                    
                                    //[self performSegueWithIdentifier:@"segueToInbox" sender:self];
                                    
                                    
                                }
                                
                                
                                
                                
                            }];
                            
                            
                            
                            
                            
                            
                        }
                        
                        
                        
                        
                        
                        
                        
                        
                    }
                    
                    
                    
                }];
            }
            
            
            
        }];
        
    }
    
    
    
}


- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    
    
    if(alertView == self.uploadPhotoAlertView && buttonIndex == 0) {
        
        
        
        NSLog(@"Sweet! button was pressed.");
        
        //Create the new action sheet for sharing.
        
        self.uploadPhotoShareSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Take Me To My Inbox" destructiveButtonTitle:nil otherButtonTitles:@"Share on Twitter",@"Save to Library", @"Copy Share Link", nil];
        
        //Display the new sharing action sheet.
        
        [self.uploadPhotoShareSheet showInView:self.view];

        [self.sharePhotoView setHidden:NO];

        
    }
    
    
    if(alertView == self.reportAlertView && buttonIndex == 1) {
        
        
        
        NSLog(@"User pressed the OK button.");
        
        [self performSegueWithIdentifier:@"segueToInbox" sender:self];
        
        
    }
    
    
    
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
                 
                 //NSLog(@"And now we segue back to the inbox!");
                 
                 //[self performSegueWithIdentifier:@"segueToInbox" sender:self];

                 
             } else {
                 
                 NSLog(@"Photo uploaded failed :( %@",error.userInfo);
                 
                /* UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:@"Error" message:@"Something went wrong. Please try again and make sure Halfsies is enabled in Settings > Privacy > Facebook" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                 
                 [alertView show]; */
             }
             
         }];
    
    [connection start];
    
}


-(void)saveToLibray {
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[self.image CGImage] orientation:(ALAssetOrientation)[self.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        
        if (error) {
            
            //NOT SAVED
            //DISPLAY ERROR THE PICTURE CAN'T BE SAVED
            
            
            NSLog(@"There was an error: %@", error);
            
            
            UIAlertView *alertView = [[UIAlertView alloc]initWithTitle:nil message:@"Could not save photo to your library. Please enable Halfsies in Settings > Privacy > Photos." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            
            [alertView show];
            
            
        } else {
            
            //SAVED
            
            NSLog(@"No errors with access and image was saved!");
            
            //Once we know that there hasn't been an error in the completion block, we release the core graphics image that we created above to save to the library.
            
            CGImageRelease([self.image CGImage]);
            
            
            
        }
    }];

    
    
}







@end
