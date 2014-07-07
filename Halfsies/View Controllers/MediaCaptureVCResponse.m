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
#import "HALAppDelegate.h"

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
    
    [self.view addSubview:self.imageView];
    [self.view sendSubviewToBack:self.imageView];
    
    [self.navigationController setNavigationBarHidden:YES];
    
    
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
    
    
    NSError *error;
    
    
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.inputDevice error:&error];
    
    
    
    if([self.session canAddInput:self.deviceInput])
        [self.session addInput:self.deviceInput];
    
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    
  
    
    
    self.rootLayer = [[self view]layer];
    
    
    [self.rootLayer setMasksToBounds:YES];
    
    
    [self.previewLayer setFrame:CGRectMake(0, self.rootLayer.bounds.size.height/2, self.rootLayer.bounds.size.width, self.rootLayer.bounds.size.height/2)];
    
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    [self.rootLayer insertSublayer:self.previewLayer atIndex:0];
    
    
    
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [self.session addOutput:self.videoOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    
    [self.videoOutput setSampleBufferDelegate:self queue:queue];
    
    [self.session startRunning];
    
}


-(BOOL)prefersStatusBarHidden {
    
    return YES;
    
}




-(IBAction)stillImageCapture {
    
    AudioServicesPlaySystemSound(1108);

    
    
    self.hasUserTakenAPhoto = @"YES";
    
    
    [self.session stopRunning];
    
    
    
    
    
    if(self.inputDevice.position == 2) {
        
        
        
        self.image = [self rotate:UIImageOrientationRightMirrored];

        
        
    } else {
        
        
        self.image = [self rotate:UIImageOrientationRight];
        
    }
    
    CGFloat widthToHeightRatio = self.previewLayer.bounds.size.width / self.previewLayer.bounds.size.height;
    
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


    
    
    
    if ([self.hasUserTakenAPhoto isEqual:@"YES"] && self.inputDevice.position == 2) {
        
        
        
        [self.takingPhotoView setHidden:YES];
        
        [self.topHalfView setHidden:YES];
        
        //tophalfview and topandbottomhalfview
        
        
        
        
        self.imageView2 = [[UIImageView alloc]initWithImage:self.image];
        
        self.imageView2.frame = CGRectMake(0, 0, self.view.bounds.size.width, 284);
        
        

        
        self.imageView2.contentMode = UIViewContentModeScaleAspectFill;
        
        [self.imageView2 setClipsToBounds:YES];
        
        
        
        
        [self.view addSubview:self.imageView2];
        
        
        
        self.image = [self screenshot];
        
        [self.imageView2 setHidden:YES];

        
        
        [self.imageView setHidden:NO];

        
 
        self.image = [self imageByCombiningImage:self.image9 withImage:self.image];
        


        
        [self.afterPhotoView setHidden:NO];
        
        
        
    } else if ([self.hasUserTakenAPhoto isEqual:@"YES"]) {
        
        
        
    
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
    
    
    if (UIGraphicsBeginImageContextWithOptions != NULL) {
        
        
        
        UIGraphicsBeginImageContextWithOptions(newImageSize, NO, [[UIScreen mainScreen] scale]);
        
    } else {
        
        
        
        
        UIGraphicsBeginImageContext(newImageSize);
        
        
    }
    
    
    [firstImage drawInRect:CGRectMake(0, 0, self.view.bounds.size.width, 568/2)];
    
    [secondImage drawInRect:CGRectMake(0, 568/2, self.view.bounds.size.width, 568/2)];
    
        image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
    
}




- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    
    
    self.image = [self imageFromSampleBuffer:sampleBuffer];
    
    
    
    
    self.image = [self rotate:UIImageOrientationRight];
    
    }




-(IBAction)toggleFlash {
    
    
    NSArray *devices = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    for (AVCaptureDevice *device in devices) {
        
        
        
        if ([device hasTorch] == YES) {
            
            
            
            [device lockForConfiguration:nil];
            
            
            if(device.torchMode == 0) {
                
                [device setTorchMode:AVCaptureTorchModeOn];
                
                
            } else if (device.torchMode == 1) {
                
                [device setTorchMode:AVCaptureTorchModeOff];
                
                
                
                
            } else if (device.torchMode == 2) {
                
                [device setTorchMode:AVCaptureTorchModeOn];

                
                
            }
            
            [device unlockForConfiguration];
        }
    }
    
}




-(IBAction)xButton {
    
    
    
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
        
        
        
        
        [self.session removeInput:self.deviceInput];
        
        [self.session removeOutput:self.stillImageOutput];
        
        [self.session stopRunning];
        
        
        
        self.session = nil;
        
        self.inputDevice = nil;
        
        self.deviceInput = nil;
        
        self.previewLayer = nil;
        
        self.stillImageOutput = nil;
        
        self.imageData = nil;
        self.image = nil;
        self.topHalfView.image = nil;
        
        
        self.xButtonBeforePhotoTaken = [[UIActionSheet alloc]initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:nil otherButtonTitles:@"Back to Inbox",@"Report User", nil];
        
        [self.xButtonBeforePhotoTaken showInView:self.view];
        
        
    
        
        
        
    }
}



- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 0)
    {
        
        //Now, after the user has captured a photo, if they press the "Delete" button on the action sheet, it will call this method below which basically refreshes the sublayer.
        
        
        //We set the self.afterPhotoView to hidden "YES" becuase this is the UIView we display only after the photo is taken.
        
        [self.afterPhotoView setHidden:YES];
        
        //We set the self.takingPhotoView back to hidden "NO" because this is the view we want for a fresh camera interface.
        
        [self.takingPhotoView setHidden:NO];
        
        self.image = nil;
        self.bottomHalfView.image = nil;
        
        
        [self.session startRunning];

        
        
    }
    
    
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        
        
        
        [self.topHalfView setHidden:NO];
        
        
        //The 2 comments above would not work for fixing the "disappearing" top half view after taking one response photo.
        //The only way to fix it was with the statement below, which sets the top and bottom half view's image property to nil.
        
        
        self.topAndBottomHalfView.image = nil;
        self.bottomHalfView.image = nil;
        
        self.hasUserTakenAPhoto = @"NO";
        
        //self.subLayer = nil;
        self.imageData = nil;
        self.image = nil;
        
        NSLog(@"hasUserTakenAPhoto should be NO? %@", self.hasUserTakenAPhoto);
        //NSLog(@"Was subLayer deleted? %@", self.subLayer);
        NSLog(@"Was imageData deleted? %@", self.imageData);
        NSLog(@"Was image deleted? %@", self.image);
        
    }
    
    
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 1)
        
    {
        
       
        
        
        [self uploadPhoto];
        
        
      
        
        
    }
    
    
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 2)
        
    {
        
        
        
        
        
    }
    
    
    if(actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 3) {
        
        
    }
    

    
    
    
    if ((actionSheet == self.shareSheet && buttonIndex == 0) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 0))
        
    {
        
        
        
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
                          NSLog(@"Twitter HTTP response: %li",
                                (long)[urlResponse statusCode]);
                          
                          if(error) {
                              
                              NSLog(@"There was an error when trying to post to Twitter.");
                              
                          }
                          
                          
                      }];
                     
                     
                     
                     
                     
                     
                     
                 }
                 
                 
                 
                 
             }
             
             
             
         }];
        
        
        
        
    }
    

        
        
    
    if((actionSheet == self.shareSheet && buttonIndex == 1) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 1)) {
        
        
       
        [self saveToLibray];
        
      
       
    }
    
        
    if((actionSheet == self.shareSheet && buttonIndex == 2) || (actionSheet == self.uploadPhotoShareSheet && buttonIndex == 2)) {
        
        
        
        
        
        
        //Copy imageFileURL to the user's clipboard.
        
        UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
        
        
        pasteboard.URL = self.finishedImageFileURL;
        
        
        
        
    }
    
    
    if(actionSheet == self.uploadPhotoShareSheet && buttonIndex == 3) {
        
        
        
        //Take the user back to their inbox.
        
        [self performSegueWithIdentifier:@"segueToInbox" sender:self];
        

        
        
        
    }
    
    
    
    if(actionSheet == self.xButtonBeforePhotoTaken && buttonIndex == 0) {
        
        
        
        
        [self performSegueWithIdentifier:@"segueToInbox" sender:self];
        
    }

    
    
    
    if(actionSheet == self.xButtonBeforePhotoTaken && buttonIndex == 1) {
        
        
        
        
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
        if ([self.inputDevice position] == desiredPosition) {
            [[self.previewLayer session] beginConfiguration];
            self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.inputDevice error:nil];
            for (AVCaptureInput *oldInput in [[self.previewLayer session] inputs]) {
                [[self.previewLayer session] removeInput:oldInput];
            }
            [[self.previewLayer session] addInput:self.deviceInput];
            [[self.previewLayer session] commitConfiguration];
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
    
    
}



- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    
        if ([segue.identifier isEqualToString:@"mediaCaptureToSendToFriendsSegue"]) {
        
        
        SendToFriendsViewController *sendFriendsVC = segue.destinationViewController;
            
        sendFriendsVC.halfsiesPhotoToSend = _image;
        
        
        
    }
    
    
    
    
    
    
    
}







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
    
    
    NSString *fileType;
    NSString *halfOrFull;
    
    
    if(self.image != nil) {
        
        fileType = @"image";
        halfOrFull = @"full";
        
        NSData *imageData = UIImageJPEGRepresentation(self.image, 0.7);
        
        PFFile *imageFile = [PFFile fileWithName:@"Image.jpg" data:imageData];
        
        
        NSString *originalSender = [[NSString alloc]init];
        
        originalSender = [self.message objectForKey:@"senderId"];
        
        
        
        
        
        
        
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
                        
                        
                        
                        
                        if(succeeded == 1) {
                            
                            
                            
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
                                    
                                
                                    if(succeeded == 1) {
                                        
                                        
                                        
                                        
                                        
                                        NSString *originalSender2 = [[NSString alloc]init];
                                        
                                        originalSender2 = [self.message objectForKey:@"senderName"];
                                        
                                        self.photoUploadAlertViewMessage = [[NSString alloc]initWithFormat:@"You just finished going halfsies with %@!", originalSender2];
                                        
                                        
                                        self.finishedImageFile = imageFile;

                                        self.finishedImageFileURL = [[NSURL alloc]initWithString:self.finishedImageFile.url];
                                        
                                        self.uploadPhotoAlertView = [[UIAlertView alloc]initWithTitle:nil message:self.photoUploadAlertViewMessage delegate:self cancelButtonTitle:@"Sweet!" otherButtonTitles:nil];
                                        
                                        [self.uploadPhotoAlertView show];
                                        

                                        
                                    }
                                    
                                    
                                    
                                    
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



-(void)saveToLibray {
    
    
    ALAssetsLibrary *library = [[ALAssetsLibrary alloc] init];
    
    
    // Request to save the image to camera roll
    [library writeImageToSavedPhotosAlbum:[self.image CGImage] orientation:(ALAssetOrientation)[self.image imageOrientation] completionBlock:^(NSURL *assetURL, NSError *error){
        
        if (error) {
            
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