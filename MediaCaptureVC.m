//
//  MediaCaptureVC.m
//  PhotoTest1
//
//  Created by Mitchell Porter on 2/19/14.
//  Copyright (c) 2014 Mitchell Porter. All rights reserved.
//

#import "MediaCaptureVC.h"
#import "UIImage+so1.h"
#import <MessageUI/MessageUI.h>
#import <CoreGraphics/CoreGraphics.h>

@interface MediaCaptureVC () <UIActionSheetDelegate, AVCaptureFileOutputRecordingDelegate, MFMessageComposeViewControllerDelegate, AVCaptureVideoDataOutputSampleBufferDelegate>

@property (strong, nonatomic) NSData *imageData;
@property (strong, nonatomic) UIImage *image;
//@property (strong, nonatomic) CGImageRef *imageRef;

@property (strong, nonatomic) UIImageView *imageView;




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


@implementation MediaCaptureVC


int myCfunction(int a)
{
    a = 200;
    return a;
}



- (void)viewDidLoad
{
    
    
    [super viewDidLoad];
    
    NSLog(@"MediaCaptureVC has loaded");
    
    NSLog(@"%d", myCfunction(27));
    

    self.takingPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height    );
    
    self.afterPhotoView.frame = CGRectMake(0, 0, self.view.bounds.size.width, self.view.bounds.size.height);
    
    self.topHalfView.frame = CGRectMake(0, 0, self.view.bounds.size.width, 284);
    
    
    NSLog(@"Is takingPhotoView hidden? %d", [self.takingPhotoView isHidden]);
    NSLog(@"Is afterPhotoView hidden? %d", [self.afterPhotoView isHidden]);
    NSLog(@"Is topHalfView hidden? %d", [self.topHalfView isHidden]);

    NSLog(@"are they null? %@", self.takingPhotoView);
    
    
    NSLog(@"takingPhotoView frame: %@", NSStringFromCGRect(self.takingPhotoView.frame));
    NSLog(@"afterPhotoView frame: %@", NSStringFromCGRect(self.afterPhotoView.frame));
    NSLog(@"topHalfview frame: %@", NSStringFromCGRect(self.topHalfView.frame));

    
    
    self.imageView = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.view.bounds.size.width, 284)];
    
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    
    [self.imageView setClipsToBounds:YES];
    
    [self.view addSubview:self.imageView];

    
   /* if([_justFinishedSigningUp isEqual:@"YES"]) {
        
        
        //[self performSelector:@selector(showSMS)];
        [self showSMS];

        
        
    } */
    
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
    
    

	
    
    _session =[[AVCaptureSession alloc]init];
    
    
    [_session setSessionPreset:AVCaptureSessionPresetPhoto];
    
  
    
    _inputDevice = [AVCaptureDevice defaultDeviceWithMediaType:AVMediaTypeVideo];
    
    NSLog(@"The current device position is: %d", _inputDevice.position);
    
    

    NSError *error;

    
    _deviceInput = [AVCaptureDeviceInput deviceInputWithDevice:_inputDevice error:&error];
    
    NSLog(@"Currently using this device: %@", _deviceInput.device);
    
    
    if([_session canAddInput:_deviceInput])
        [_session addInput:_deviceInput];
  
    
    _previewLayer = [[AVCaptureVideoPreviewLayer alloc]initWithSession:_session];
    
    
    CALayer *rootLayer = [[self view]layer];
    
    [rootLayer setMasksToBounds:YES];
    
    //zzzzzzz
    
    [_previewLayer setFrame:CGRectMake(0, 0, rootLayer.bounds.size.width, rootLayer.bounds.size.height/2)];
    
    [_previewLayer setVideoGravity:AVLayerVideoGravityResizeAspectFill];
    
    
    NSLog(@"THE FRAME: %@", NSStringFromCGRect(_previewLayer.frame));
    
    NSLog(@"Coordinates 1: %f", rootLayer.bounds.size.width);
    NSLog(@"Coordinates 2: %f", rootLayer.bounds.size.height/2);
    
    
    [rootLayer insertSublayer:_previewLayer atIndex:0];


   // _stillImageOutput = [[AVCaptureStillImageOutput alloc] init];
    
    
    
    
    
    
    
    self.videoOutput = [[AVCaptureVideoDataOutput alloc] init];
    self.videoOutput.videoSettings = @{ (NSString *)kCVPixelBufferPixelFormatTypeKey : @(kCVPixelFormatType_32BGRA) };
    
    [self.session addOutput:self.videoOutput];
    
    dispatch_queue_t queue = dispatch_queue_create("MyQueue", NULL);
    
    [self.videoOutput setSampleBufferDelegate:self queue:queue];
    
    
    
    
    //[_session addOutput:_stillImageOutput];
    
    [_session startRunning];
    
    
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
    
    //play then shutter.wav sound
    //AudioServicesPlaySystemSound(SoundID);
    
    AudioServicesPlaySystemSound(1108);

    
   /* NSString *soundFilePath = [[NSBundle mainBundle] pathForResource:@"shutter" ofType: @"wav"];
    NSURL *fileURL = [[NSURL alloc] initFileURLWithPath:soundFilePath ];
    self.myAudioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:fileURL error:nil];
    //self.myAudioPlayer.numberOfLoops = 0; //infinite loop
    [self.myAudioPlayer play]; */

    
    
    self.imageData = [[NSData alloc]init];
    //self.image = [[UIImage alloc]init];
    
    _hasUserTakenAPhoto = @"YES";
    
    [self.session stopRunning];

    
    NSLog(@"self.image: %@", self.image);
    NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
    
    
    
    
            if(_inputDevice.position == 2) {
           
            //_subLayer.frame = _previewLayer.frame;
                
                NSLog(@"Input device position 2! It's a selfie!");

            
                self.image = [self rotate:UIImageOrientationRightMirrored];

                
                NSLog(@"self.image: %@", self.image);
                NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
                
            
            } else {
                
                
                
                self.image = [self rotate:UIImageOrientationRight];
                
                NSLog(@"self.image: %@", self.image);
                NSLog(@"self.image.size after rotation: %@", NSStringFromCGSize(self.image.size));
                
                
                
                
                
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
                
                //852 - 480 =
                
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
    
    //CGRect cropRectFinal = CGRectMake(cropRect.origin.x, finalXValueForCrop, cropRect.size.width, 568);

    
            NSLog(@"cropRectFinal: %@", NSStringFromCGRect(cropRectFinal));

    
                CGImageRef imageRef = CGImageCreateWithImageInRect([self.image CGImage], cropRectFinal);
    
    
                UIImage *image2 = [[UIImage alloc]initWithCGImage:imageRef];
    
    
                self.image = image2;
    
                
    
                CGImageRelease(imageRef);

                
                
    
    
    
    
    
    
            
            if ([_hasUserTakenAPhoto isEqual:@"YES"] && self.inputDevice.position == 2) {
                
                NSLog(@"Logic");
                
                
                [self.takingPhotoView setHidden:YES];
                
                
                // Set the topHalfView's image property to the captured image.
                
                self.imageView.image = self.image;
                
                // We take the screenshot right after we set the image.

                NSLog(@"self.image size before screenshot: %@", NSStringFromCGSize(self.image.size));

                
                self.image = [self screenshot];
                
                NSLog(@"self.image size after screenshot: %@", NSStringFromCGSize(self.image.size));
                
                // Because the image is bigger than half the screen on a 3.5 inch phone, we set the topHalfView to hidden right after we take the screenshot. This allows us to capture our 4 inch half screenshot without the user noticing a "half" view that is actually too large.
                
                // All the really see is the perfectly sized preview layer with the paused session.
                
                [self.imageView setHidden:YES];


                
                [self.afterPhotoView setHidden:NO];
                
                
                
                
            } else if([self.hasUserTakenAPhoto isEqual:@"YES"]) {
                
                
                
                NSLog(@"Not a selfie");
                
                
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
    
    NSLog(@"1: %@", self.image.description);
    
    
    // Create a UIImage from the sample buffer data
    
    // You are manually calling this.
    
    
    
    
    self.image = [self imageFromSampleBuffer:sampleBuffer];
    
    
    NSLog(@"self.image.size: %@", NSStringFromCGSize(self.image.size));
    
    //self.image = [self rotate:UIImageOrientationRight];
    
    //self.topHalfView.image = self.image;
    
    
    
    //< Add your code here that uses the image >
    
    //NSLog(@"2: %@", self.image.description);
    
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
    
    NSLog(@"Has the user take a photo? %@", self.hasUserTakenAPhoto);
    
    //NSString *title;
    
    //Check the global variable "hasUserTakenAPhoto" to see if it contains the string "YES"
    
    if ([self.hasUserTakenAPhoto isEqual:@"YES"])
    {
        _xButtonAfterPhotoTaken = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"Cancel" destructiveButtonTitle:@"Delete" otherButtonTitles:nil];
        
        [_xButtonAfterPhotoTaken showInView:self.view];
        
        
    } else {
        
    
        //[_session removeInput:_deviceInput];
        
        //[_session removeOutput:_stillImageOutput];
        
        [_session stopRunning];
        
        
        
        _session = nil;
        
        _inputDevice = nil;
        
        _deviceInput = nil;
        
        _previewLayer = nil;
        
        _stillImageOutput = nil;
        
        self.imageData = nil;
        self.image = nil;
        self.topHalfView.image = nil;
        
        
[self performSegueWithIdentifier:@"backToInboxFromMediaCaptureVC" sender:self];
    }
}




- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    // Check if it's the correct action sheet and the delete button (the only one) has been selected.
    if (actionSheet == _xButtonAfterPhotoTaken && buttonIndex == 0)
    {
        //[self performSegueWithIdentifier:@"backToHomeFromMediaCaptureVC" sender:self];
        
        //Now, after the user has captured a photo, if they press the "Delete" button on the action sheet, it will call this method below which basically refreshes the sublayer.
        
        
        //We set the _afterPhotoView to hidden "YES" becuase this is the UIView we display only after the photo is taken.
        
        [self.afterPhotoView setHidden:YES];
        
        //We set the _takingPhotoView back to hidden "NO" because this is the view we want for a fresh camera interface.
        
        [self.takingPhotoView setHidden:NO];
        
        [self.topHalfView setHidden:NO];
        
        self.image = nil;
        self.topHalfView.image = nil;
        
        [self.session startRunning];


    }
    
    if (buttonIndex == actionSheet.destructiveButtonIndex)
    {
        // Do something...
        
        NSLog(@"DELETE BUTTON HAS BEEN PRESSED!");
        
        _hasUserTakenAPhoto = @"NO";
        
        
        _subLayer = nil;
        self.imageData = nil;
        self.image = nil;
        
        
        
        NSLog(@"hasUserTakenAPhoto should be NO? %@", _hasUserTakenAPhoto);
        NSLog(@"Was subLayer deleted? %@", _subLayer);
        NSLog(@"Was imageData deleted? %@", self.imageData);
        NSLog(@"Was image deleted? %@", self.image);

    }
    
    
}



- (void)actionSheetCancel:(UIActionSheet *)actionSheet
{
    NSLog(@"Canceled");
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








- (void)showSMS {
    
    if(![MFMessageComposeViewController canSendText]) {
        UIAlertView *warningAlert = [[UIAlertView alloc] initWithTitle:@"Error" message:@"Your device doesn't support SMS!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
        [warningAlert show];
        return;
    }
    
    NSArray *recipents = _usersToInviteToHalfsies;
    NSString *message = _textMessageInviteText;
    
    MFMessageComposeViewController *messageController = [[MFMessageComposeViewController alloc] init];
    messageController.messageComposeDelegate = self;
    [messageController setSubject:@"New Message"];
    [messageController setRecipients:recipents];
    [messageController setBody:message];
    
    // Present message view controller on screen
    [self presentViewController:messageController animated:NO completion:nil];
}





//This is the method implementation that handles someof the MFMessageComposeViewController's functionality.

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
    
    // This is our actual implmenetation body code which starts with an if statement. This says "If our segue identifier is equal to signupYoVerificationSegue then do this...
    if ([segue.identifier isEqualToString:@"mediaCaptureToSendToFriendsSegue"]) {
        
        //If the string IS equal to signupToVerificationSegue then we create a new object of our  custom View Controller class VerificationViewController and we set the value of this object to the segue property of destinationViewController.
        
        //AddFriendsViewController *addFriendsVC = segue.destinationViewController;
        SendToFriendsViewController *sendFriendsVC = segue.destinationViewController;
        
        //We then set the verifyViewController object that we just created to the property of uniqueVerificationCode which we set equal to the value that is stored inside _uniqueVerificationCode.
        
        //addFriendsVC.uniqueVerificationCode = _uniqueVerificationCode;
        
        
        
        sendFriendsVC.halfsiesPhotoToSend = _image;

        
        
    }
}



-(IBAction)sendButton {
    
    
    
    [self performSegueWithIdentifier:@"mediaCaptureToSendToFriendsSegue" sender:self];
    
    
    
}



@end
