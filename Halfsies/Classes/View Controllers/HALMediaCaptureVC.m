//
//  MediaCaptureVC.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/19/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "HALMediaCaptureVC.h"
#import "UIImage+so1.h"
#import <MessageUI/MessageUI.h>
#import <CoreGraphics/CoreGraphics.h>
#import "HALSendToFriendsViewController.h"

@interface HALMediaCaptureVC () <UIActionSheetDelegate, AVCaptureFileOutputRecordingDelegate, MFMessageComposeViewControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) UIImage *image;
@property (strong, nonatomic) UIImageView *imageView;
@property (nonatomic, strong) AVAudioPlayer *myAudioPlayer;
@property (nonatomic,retain) AVCaptureSession *session;
@property (nonatomic, retain) AVCaptureStillImageOutput *stillImageOutput;
@property (nonatomic, retain) AVCaptureVideoPreviewLayer *previewLayer;
@property (nonatomic, retain) AVCaptureDevice *inputDevice;
@property (nonatomic, retain) NSString *hasUserTakenAPhoto;
@property (nonatomic, retain) CALayer *subLayer;
@property (nonatomic, retain) UIActionSheet *xButtonAfterPhotoTaken;
@property (nonatomic, retain) NSString *xButtonActionSheetTitle;
@property (nonatomic, retain) AVCaptureDeviceInput *deviceInput;
@property (nonatomic, retain) AVCaptureVideoDataOutput *videoOutput;
@property (nonatomic, retain) IBOutlet UIView *takingPhotoView;
@property (nonatomic, retain) IBOutlet UIView *afterPhotoView;
@property (nonatomic, retain) IBOutlet UIImageView *topHalfView;
@property (nonatomic, retain) IBOutlet UIView *smsWindowAfterSignup;
@property (nonatomic, retain) NSMutableArray *usersToAddToFriendsList;


//The NSString property below will be used to pass an NSString object like "YES" from the Add Friends View Controller. That way if the user has just finished signing up and is leaving the AddFriendsViewController, and they also have selected to send a text message invite to some of their contacts, we will place a string of "YES" in this object. Then, we can setup an if statemenet that checks for a "YES" in the object, and if it finds it, then we know to launch the SMS window.

@property (nonatomic, retain) NSString *justFinishedSigningUp;

//These are the properties to pass the phone numbers and the text message body with user's username to this view controller.

@property (nonatomic, retain) NSArray *usersToInviteToHalfsies;
@property (nonatomic, retain) NSString *textMessageInviteText;
@property (strong, nonatomic) IBOutlet UIButton *toggleFlashButton;

- (IBAction)stillImageCapture;
- (IBAction)toggleFlash;
- (IBAction)xButton;
- (IBAction)toggleCamera;
- (IBAction)sendButton;

@end

SystemSoundID SoundID;



static inline CGFloat degreesToRadians(CGFloat degrees)
{
    return M_PI * (degrees / 180.0);
}

static inline CGSize swapWidthAndHeight(CGSize size)
{
    CGFloat swap = size.width;
    
    size.width  = size.height;
    size.height = swap;
    
    return size;
}

BOOL isUsingFrontFacingCamera;

float finalXValueForCrop;


@implementation HALMediaCaptureVC


int myCfunction(int a)
{
    a = 200;
    return a;
}



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    

    self.takingPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height    );
    
    self.afterPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.topHalfView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 284);
    
    
    

    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 284)];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imageView setClipsToBounds:YES];
    
    [self.view addSubview:self.imageView];

    
    
    
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
    NSLog(@"The current device position is: %ld", self.inputDevice.position);
    
    

    NSError *error;

    
    self.deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:self.inputDevice error:&error];
    
    
    
    if([self.session canAddInput:self.deviceInput])
        [self.session addInput:self.deviceInput];
  
    
    self.previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:self.session];
    
    
    CALayer *rootLayer = [[self view]layer];
    
    [rootLayer setMasksToBounds:YES];
    
    
    [self.previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.width, rootLayer.bounds.size.height/2)];
    
    [self.previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    [rootLayer insertSublayer:self.previewLayer atIndex:0];

    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [self.session addOutput:self.videoOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    
    [self.videoOutput setSampleBufferDelegate:self queue:queue];
    
    
    
    
    
    [self.session startRunning];
    
    
    }

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:NO];
    
    [self.navigationController setNavigationBarHidden:YES];   //it hides
    
    
    
    
    
}

-(void)viewWillDisappear:(BOOL)animated {
    
    
    [super viewWillDisappear:YES];
    
    [self.navigationController setNavigationBarHidden:NO];
    
    
}


- (BOOL)prefersStatusBarHidden

{
    return YES;
}




-(IBAction)stillImageCapture {
    
    
    
    AudioServicesPlaySystemSound(1108);

    
    
    
    self.imageData = [[NSData alloc]init];
    
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
    
    
    
            NSLog(@"Here come all of the croprect values!");
    
            NSLog(@"cropRect.origin.x: %f", cropRect.origin.x);
    
            NSLog(@"finalXValueForCrop: %f", finalXValueForCrop);
    
            NSLog(@"cropRect.size.width: %f", cropRect.size.width);

            NSLog(@"cropRect.size.height: %f", cropRect.size.height);

    
    
            CGRect cropRectFinal = CGRectMake(cropRect.origin.x, finalXValueForCrop, cropRect.size.width, 568);
    
                CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], cropRectFinal);
    
    
                UIImage *image2 = [[UIImage alloc]initWithCGImage:imageRef];
    
    
                self.image = image2;
    
                
    
                CGImageRelease(imageRef);

                
                
    
    
    
    
    
    
            
            if ([self.hasUserTakenAPhoto isEqual:@"YES"] && self.inputDevice.position == 2) {
                
                
                
                [self.takingPhotoView setHidden:YES];
                
                
                // Set the topHalfView's image property to the captured image.
                
                self.imageView.image = self.image;
                
                // We take the screenshot right after we set the image.

                

                
                self.image = [self screenshot];
                
                
                // Because the image is bigger than half the screen on a 3.5 inch phone, we set the topHalfView to hidden right after we take the screenshot. This allows us to capture our 4 inch half screenshot without the user noticing a "half" view that is actually too large.
                
                // All the really see is the perfectly sized preview layer with the paused session.
                
                [self.imageView setHidden:YES];


                
                [self.afterPhotoView setHidden:NO];
                
                
                
                
            } else if([self.hasUserTakenAPhoto isEqual:@"YES"]) {
                
                
                
                
                
                [self.takingPhotoView setHidden:YES];
                
                
                
                
                [self.afterPhotoView setHidden:NO];

                
                
                
            }

        }


        

- (UIImage *) screenshot {
    
    UIGraphicsBeginImageContextWithOptions(self.imageView.bounds.size, NO, [UIScreen mainScreen].scale);
    
    [self.view drawViewHierarchyInRect:self.view.bounds afterScreenUpdates:YES];
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
}




- (void)captureOutput:(AVCaptureOutput *)captureOutput
didOutputSampleBuffer:(CMSampleBufferRef)sampleBuffer
       fromConnection:(AVCaptureConnection *)connection
{
    self.image = [self imageFromSampleBuffer:sampleBuffer];
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




#pragma mark Image Rotation


- (UIImage *)normalizedImage {
    if (self.image.imageOrientation == UIImageOrientationUp) return self.image;
    
    UIGraphicsBeginImageContextWithOptions(self.image.size, NO, self.image.scale);
    [self.image drawInRect:(CGRect){0, 0, self.image.size}];
    UIImage *normalizedImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return normalizedImage;
}




- (UIImage *)fixrotation:(UIImage *)image{
    
    
    if (image.imageOrientation == UIImageOrientationUp) return image;
    CGAffineTransform transform = CGAffineTransformIdentity;
    
    switch (image.imageOrientation) {
        case UIImageOrientationDown:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, image.size.height);
            transform = CGAffineTransformRotate(transform, M_PI);
            break;
            
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformRotate(transform, M_PI_2);
            break;
            
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, 0, image.size.height);
            transform = CGAffineTransformRotate(transform, -M_PI_2);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationUpMirrored:
            break;
    }
    
    switch (image.imageOrientation) {
        case UIImageOrientationUpMirrored:
        case UIImageOrientationDownMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.width, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
            
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRightMirrored:
            transform = CGAffineTransformTranslate(transform, image.size.height, 0);
            transform = CGAffineTransformScale(transform, -1, 1);
            break;
        case UIImageOrientationUp:
        case UIImageOrientationDown:
        case UIImageOrientationLeft:
        case UIImageOrientationRight:
            break;
    }
    
    // Now we draw the underlying CGImage into a new context, applying the transform
    // calculated above.
    CGContextRef ctx = CGBitmapContextCreate(NULL, image.size.width, image.size.height,
                                             CGImageGetBitsPerComponent(image.CGImage), 0,
                                             CGImageGetColorSpace(image.CGImage),
                                             CGImageGetBitmapInfo(image.CGImage));
    CGContextConcatCTM(ctx, transform);
    switch (image.imageOrientation) {
        case UIImageOrientationLeft:
        case UIImageOrientationLeftMirrored:
        case UIImageOrientationRight:
        case UIImageOrientationRightMirrored:
            // Grr...
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.height,image.size.width), image.CGImage);
            break;
            
        default:
            CGContextDrawImage(ctx, CGRectMake(0,0,image.size.width,image.size.height), image.CGImage);
            break;
    }
    
    // And now we just create a new UIImage from the drawing context
    CGImageRef cgimg = CGBitmapContextCreateImage(ctx);
    UIImage *img = [UIImage imageWithCGImage:cgimg];
    CGContextRelease(ctx);
    CGImageRelease(cgimg);
    return img;
    
}















-(IBAction)xButton {
    
    
    //Check the global variable "hasUserTakenAPhoto" to see if it contains the string "YES"
    
    if ([self.hasUserTakenAPhoto isEqual:@"YES"])
    {
        self.xButtonAfterPhotoTaken = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        
        [self.xButtonAfterPhotoTaken showInView:self.view];
        
        
    } else {
        
    
        
        
        [self.session stopRunning];
        
        
        
        self.session = nil;
        
        self.inputDevice = nil;
        
        self.deviceInput = nil;
        
        self.previewLayer = nil;
        
        self.stillImageOutput = nil;
        
        self.imageData = nil;
        self.image = nil;
        self.topHalfView.image = nil;
        
        
[self performSegueWithIdentifier:@"backToInboxFromMediaCaptureVC" sender:self];
    }
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    if (actionSheet == self.xButtonAfterPhotoTaken && buttonIndex == 0)
    {
        
        [self.afterPhotoView setHidden:YES];
        
        //We set the self.takingPhotoView back to hidden "NO" because this is the view we want for a fresh camera interface.
        
        [self.takingPhotoView setHidden:NO];
        
        [self.topHalfView setHidden:NO];
        
        self.image = nil;
        self.topHalfView.image = nil;
        
        [self.session startRunning];


    }
    
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        
        self.hasUserTakenAPhoto = @"NO";
        
        
        self.subLayer = nil;
        self.imageData = nil;
        self.image = nil;
        
    
    }
    
    
}



- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    
}




- (IBAction)toggleCamera
{
    

    
    AVCaptureDevicePosition desiredPosition;

    
       if (isUsingFrontFacingCamera) {
        

        desiredPosition = AVCaptureDevicePositionBack;
         
   
           
    } else {
        

        desiredPosition = AVCaptureDevicePositionFront;
        

    }
    
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








- (void)showSMS {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = self.usersToInviteToHalfsies;
    NSString *message = self.textMessageInviteText;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setSubject:@"New Message"];
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:NO completion:nil];
}





//This is the method implementation that handles some of the MFMessageComposeViewController's functionality.

- (void)messageComposeViewController:(MFMessageComposeViewController *)controller didFinishWithResult:(MessageComposeResult) result
{
    switch (result) {
        case MessageComposeResultCancelled:
            break;
            
        case MessageComposeResultFailed:
        {
            UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Failed to send SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [warningAlert show];
            break;
        }
            
        case MessageComposeResultSent:
            break;
            
        default:
            break;
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
}









- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:self {
    
    
    if ([segue.identifier isEqualToString:@"mediaCaptureToSendToFriendsSegue"]) {
        
       
        HALSendToFriendsViewController *sendFriendsVC = segue.destinationViewController;
        
        sendFriendsVC.halfsiesPhotoToSend = _image;

        
        
    }
}



-(IBAction)sendButton {
    
    
    
    [self performSegueWithIdentifier:@"mediaCaptureToSendToFriendsSegue" sender:self];
    
    
    
}



@end
